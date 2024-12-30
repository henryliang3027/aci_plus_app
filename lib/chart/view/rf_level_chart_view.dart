import 'dart:io';
import 'dart:math';
import 'package:aci_plus_app/chart/bloc/chart18/chart18_bloc.dart';
import 'package:aci_plus_app/chart/bloc/rf_level_chart/rf_level_chart_bloc.dart';
import 'package:aci_plus_app/chart/shared/message_dialog.dart';
import 'package:aci_plus_app/chart/shared/utils.dart';
import 'package:aci_plus_app/chart/view/full_screen_chart_form.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_button_navigation_bar18.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_chart/speed_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RFLevelChartView extends StatelessWidget {
  const RFLevelChartView({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RFLevelChartBloc, RFLevelChartState>(
      listener: (context, state) {
        if (state.rfInOutRequestStatus.isRequestFailure) {
          showFailureDialog(
            context: context,
            msg: state.errorMessage,
          );
        }
      },
      child: Scaffold(
        body: const _ChartView(),
        bottomNavigationBar: HomeBottomNavigationBar18(
          pageController: pageController,
          selectedIndex: 3,
          onTap: (int index) {
            pageController.jumpToPage(
              index,
            );
          },
        ),
        floatingActionButton: const _SetupWizardFloatingActionButton(),
      ),
    );
  }
}

class _ChartView extends StatelessWidget {
  const _ChartView();

  @override
  Widget build(BuildContext context) {
    List<LineSeries> getChartDataOfOutputRFLevel({
      required List<List<ValuePair>> dateValueCollectionOfLog,
    }) {
      LineSeries rfLevelLineSeries = LineSeries(
        name: 'Output RF Level (${CustomStyle.dBmV})',
        dataList: dateValueCollectionOfLog[0],
        color: Theme.of(context).colorScheme.primary,
        minYAxisValue: 0.0,
        maxYAxisValue: 60.0,
      );

      return [
        rfLevelLineSeries,
      ];
    }

    List<LineSeries> getChartDataOfInputRFLevel({
      required List<List<ValuePair>> dateValueCollectionOfLog,
    }) {
      LineSeries rfLevelLineSeries = LineSeries(
        name: 'Input RF Level (${CustomStyle.dBmV})',
        dataList: dateValueCollectionOfLog[1],
        color: CustomStyle.customGreen,
        minYAxisValue: 0.0,
        maxYAxisValue: 60.0,
      );

      return [
        rfLevelLineSeries,
      ];
    }

    Widget buildChart(List<LineSeries> lineSeriesCollection) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CustomStyle.sizeXL, vertical: 10.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  FullScreenChartForm.route(
                    title: AppLocalizations.of(context)!.monitoringChart,
                    lineSeriesCollection: lineSeriesCollection,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                visualDensity:
                    const VisualDensity(horizontal: -4.0, vertical: -3.0),
              ),
              child: Icon(
                Icons.fullscreen_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          SpeedLineChart(
            lineSeriesCollection: lineSeriesCollection,
            showLegend: true,
            showScaleThumbs: winBeta >= 4
                ? Platform.isWindows
                    ? true
                    : false
                : false,
          ),
        ],
      );
    }

    Widget buildLoadingFormWithProgressiveChartView(
        List<List<ValuePair>> dateValueCollectionOfLog) {
      List<List<ValuePair>> emptyDateValueCollection = [
        [],
        [],
      ];
      String intValue = Random().nextInt(100).toString();
      List<LineSeries> rfOutputData = [];
      List<LineSeries> rfInputData = [];
      if (dateValueCollectionOfLog.isEmpty) {
        rfOutputData = getChartDataOfOutputRFLevel(
            dateValueCollectionOfLog: emptyDateValueCollection);
        rfInputData = getChartDataOfInputRFLevel(
            dateValueCollectionOfLog: emptyDateValueCollection);
      } else {
        rfOutputData = getChartDataOfOutputRFLevel(
            dateValueCollectionOfLog: dateValueCollectionOfLog);
        rfInputData = getChartDataOfInputRFLevel(
            dateValueCollectionOfLog: dateValueCollectionOfLog);
      }

      return Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            // 設定 key, 讓 chart 可以 rebuild 並繪製空的資料
            // 如果沒有設定 key, flutter widget tree 會認為不需要rebuild chart
            key: Key('ChartForm_${intValue}_Chart'),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildChart(rfOutputData),
                  const SizedBox(
                    height: 50.0,
                  ),
                  buildChart(rfInputData),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(70, 158, 158, 158),
            ),
            child: const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      );
    }

    return Builder(
      builder: (context) {
        HomeState homeState = context.watch<HomeBloc>().state;
        RFLevelChartState rfLevelChartState =
            context.watch<RFLevelChartBloc>().state;

        if (homeState.loadingStatus == FormStatus.requestSuccess) {
          if (rfLevelChartState.rfInOutRequestStatus.isNone) {
            print('get rf');
            context.read<Chart18Bloc>().add(const TabChangedDisabled());
            context.read<RFLevelChartBloc>().add(const RFInOutRequested());
            return Stack(
              alignment: Alignment.center,
              children: [
                buildLoadingFormWithProgressiveChartView(
                    rfLevelChartState.valueCollectionOfRFInOut),
              ],
            );
          } else if (rfLevelChartState
              .rfInOutRequestStatus.isRequestInProgress) {
            return Stack(
              alignment: Alignment.center,
              children: [
                buildLoadingFormWithProgressiveChartView(
                    rfLevelChartState.valueCollectionOfRFInOut),
              ],
            );
          } else if (rfLevelChartState.rfInOutRequestStatus.isRequestFailure) {
            context.read<Chart18Bloc>().add(const TabChangedEnabled());
            return Stack(
              alignment: Alignment.center,
              children: [
                buildLoadingFormWithProgressiveChartView(
                    rfLevelChartState.valueCollectionOfRFInOut),
              ],
            );
          } else {
            context.read<Chart18Bloc>().add(const TabChangedEnabled());
            return Center(
              child: SingleChildScrollView(
                // 設定 key, 讓 chart 可以 rebuild
                // 如果沒有設定 key, flutter widget tree 會認為不需要rebuild chart
                key: const Key('ChartForm_Chart'),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 60.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildChart(
                        getChartDataOfOutputRFLevel(
                            dateValueCollectionOfLog:
                                rfLevelChartState.valueCollectionOfRFInOut),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      buildChart(
                        getChartDataOfInputRFLevel(
                            dateValueCollectionOfLog:
                                rfLevelChartState.valueCollectionOfRFInOut),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          return Center(
            child: SingleChildScrollView(
              // 設定 key, 讓 chart 可以 rebuild 並繪製空的資料
              // 如果沒有設定 key, flutter widget tree 會認為不需要rebuild chart
              key: const Key('ChartForm_Empty_Chart'),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildChart(
                      getChartDataOfOutputRFLevel(
                        dateValueCollectionOfLog: [[], [], [], [], []],
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    buildChart(
                      getChartDataOfInputRFLevel(
                        dateValueCollectionOfLog: [[], [], [], [], []],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class _SetupWizardFloatingActionButton extends StatelessWidget {
  const _SetupWizardFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus,
      builder: (context, state) {
        bool enabled = state.loadingStatus.isRequestSuccess;
        return getRFLevelChartSetupWizard(
          context: context,
        );
      },
    );
  }
}

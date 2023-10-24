import 'dart:math';

import 'package:dsim_app/chart/chart/chart18_bloc/chart18_bloc.dart';
import 'package:dsim_app/chart/view/full_screen_chart_form.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/home/views/home_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RFLevelChartView extends StatelessWidget {
  const RFLevelChartView({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const _ChartView(),
      bottomNavigationBar: HomeBottomNavigationBar(
        pageController: pageController,
        selectedIndex: 3,
        onTap: (int index) {
          pageController.jumpToPage(
            index,
          );
        },
      ),
    );
  }
}

class _ChartView extends StatelessWidget {
  const _ChartView({super.key});

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
            padding: const EdgeInsets.only(right: 10.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  FullScreenChartForm.route(
                    title: AppLocalizations.of(context).monitoringChart,
                    lineSeriesCollection: lineSeriesCollection,
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(0.0),
                backgroundColor: Colors.white70,
                elevation: 0,
                side: const BorderSide(
                  width: 1.0,
                  color: Colors.black,
                ),
                visualDensity:
                    const VisualDensity(horizontal: -4.0, vertical: -3.0),
              ),
              child: const Icon(
                Icons.fullscreen_outlined,
                color: Colors.black,
              ),
            ),
          ),
          SpeedLineChart(
            lineSeriesCollection: lineSeriesCollection,
            showLegend: true,
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
              padding: const EdgeInsets.symmetric(vertical: 30.0),
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
        Chart18State chart18State = context.watch<Chart18Bloc>().state;

        if (homeState.loadingStatus == FormStatus.requestInProgress) {
          return Stack(
            alignment: Alignment.center,
            children: [
              buildLoadingFormWithProgressiveChartView(
                  chart18State.dateValueCollectionOfLog),
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
              ),
            ],
          );
        } else if (homeState.loadingStatus == FormStatus.requestSuccess) {
          if (chart18State.rfDataRequestStatus.isNone) {
            print('get rf');
            context.read<Chart18Bloc>().add(const RFInOutDataRequested());
            return Stack(
              alignment: Alignment.center,
              children: [
                buildLoadingFormWithProgressiveChartView(
                    chart18State.dateValueCollectionOfLog),
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
                ),
              ],
            );
          } else if (chart18State.rfDataRequestStatus.isRequestInProgress) {
            return Stack(
              alignment: Alignment.center,
              children: [
                buildLoadingFormWithProgressiveChartView(
                    chart18State.dateValueCollectionOfLog),
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
                ),
              ],
            );
          } else if (chart18State.rfDataRequestStatus.isRequestFailure) {
            return Stack(
              alignment: Alignment.center,
              children: [
                buildLoadingFormWithProgressiveChartView(
                    chart18State.dateValueCollectionOfLog),
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
                ),
              ],
            );
          } else {
            return Center(
              child: SingleChildScrollView(
                // 設定 key, 讓 chart 可以 rebuild 並繪製空的資料
                // 如果沒有設定 key, flutter widget tree 會認為不需要rebuild chart
                key: const Key('ChartForm_Chart'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // ElevatedButton(
                      //     onPressed: () async {
                      //       DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      //       // AndroidDeviceInfo androidInfo =
                      //       //     await deviceInfo.androidInfo;

                      //       IosDeviceInfo iosDeviceInfo =
                      //           await deviceInfo.iosInfo;

                      //       // print(androidInfo.model + ' ' + iosDeviceInfo.model);
                      //       print(iosDeviceInfo.model);
                      //     },
                      //     child: Text('Mobile info')),
                      buildChart(
                        getChartDataOfOutputRFLevel(
                            dateValueCollectionOfLog:
                                chart18State.valueCollectionOfRFInOut),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      buildChart(
                        getChartDataOfInputRFLevel(
                            dateValueCollectionOfLog:
                                chart18State.valueCollectionOfRFInOut),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          return SingleChildScrollView(
            // 設定 key, 讓 chart 可以 rebuild 並繪製空的資料
            // 如果沒有設定 key, flutter widget tree 會認為不需要rebuild chart
            key: const Key('ChartForm_Chart'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildChart(
                    getChartDataOfOutputRFLevel(
                        dateValueCollectionOfLog:
                            chart18State.valueCollectionOfRFInOut),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  buildChart(
                    getChartDataOfInputRFLevel(
                        dateValueCollectionOfLog:
                            chart18State.valueCollectionOfRFInOut),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

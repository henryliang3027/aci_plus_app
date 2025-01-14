import 'dart:io';
import 'dart:math';
import 'package:aci_plus_app/chart/bloc/chart18/chart18_bloc.dart';
import 'package:aci_plus_app/chart/bloc/data_log_chart/data_log_chart_bloc.dart';
import 'package:aci_plus_app/chart/shared/message_dialog.dart';
import 'package:aci_plus_app/chart/shared/utils.dart';
import 'package:aci_plus_app/chart/view/full_screen_chart_form.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setup_wizard_dialog.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_button_navigation_bar18.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_chart/speed_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DataLogChartView extends StatelessWidget {
  const DataLogChartView({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return _LogChartView(
      pageController: pageController,
    );
  }
}

class _LogChartView extends StatelessWidget {
  const _LogChartView({
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataLogChartBloc, DataLogChartState>(
      listener: (context, state) async {
        if (state.formStatus.isRequestSuccess) {
          if (!state.hasNextChunk) {
            // 避免 dialog 重複跳出
            if (ModalRoute.of(context)?.isCurrent == true) {
              showNoMoreDataDialog(context: context);
            }
          }
          // context.read<HomeBloc>().add(const DevicePeriodicUpdateRequested());
        } else if (state.formStatus.isRequestFailure) {
          showFailureDialog(
            context: context,
            msg: state.errorMessage,
          );
          // context.read<HomeBloc>().add(const DevicePeriodicUpdateRequested());
        }

        // // 如果 state.logRequestStatus 滿足 isRequestSuccess, state.eventRequestStatus 滿足 isRequestFailure
        // if (state.eventRequestStatus.isRequestFailure) {
        //   // context.read<HomeBloc>().add(const DevicePeriodicUpdateRequested());
        //   showFailureDialog(
        //     context: context,
        //     msg: state.errorMessage,
        //   );
        // } else if (state.eventRequestStatus.isRequestSuccess) {
        //   // context.read<HomeBloc>().add(const DevicePeriodicUpdateRequested());
        // }
      },
      child: Scaffold(
        body: const _LogChartContent(),
        floatingActionButton: const _DataLogFloatingActionButton(),
        bottomNavigationBar: _DynamicBottomNavigationBar(
          pageController: pageController,
          selectedIndex: 3,
        ),
      ),
    );
  }
}

class _DynamicBottomNavigationBar extends StatelessWidget {
  const _DynamicBottomNavigationBar({
    required this.pageController,
    required this.selectedIndex,
  });

  final PageController pageController;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataLogChartBloc, DataLogChartState>(
      builder: (context, state) {
        if (state.formStatus.isRequestInProgress) {
          return HomeBottomNavigationBar18(
            pageController: pageController,
            selectedIndex: selectedIndex,
            enableTap: false,
            onTap: (int index) {
              pageController.jumpToPage(
                index,
              );
            },
          );
        } else {
          return HomeBottomNavigationBar18(
            pageController: pageController,
            selectedIndex: selectedIndex,
            onTap: (int index) {
              pageController.jumpToPage(
                index,
              );
            },
          );
        }
      },
    );
  }
}

class _DataLogFloatingActionButton extends StatelessWidget {
  const _DataLogFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        bool enabled = state.loadingStatus.isRequestSuccess;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            getDataLogChartSetupWizard(
              context: context,
            ),
            const SizedBox(
              height: 10,
            ),
            _MoreDataFloatingActionButton(
              enabled: enabled,
            ),
          ],
        );
      },
    );
  }
}

class _MoreDataFloatingActionButton extends StatelessWidget {
  const _MoreDataFloatingActionButton({
    required this.enabled,
  });

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataLogChartBloc, DataLogChartState>(
        builder: (context, state) {
      bool isRequesting =
          state.formStatus.isNone || state.formStatus.isRequestInProgress;

      return FloatingActionButton(
        shape: const CircleBorder(
          side: BorderSide.none,
        ),
        // enabled 檢查有沒有在讀取基本資訊,
        // isRequesting 檢查有沒有正在 load log
        // hasNextChunk 檢查是否有下一筆 chunk
        backgroundColor: enabled && !isRequesting && state.hasNextChunk
            ? Theme.of(context).colorScheme.primary.withAlpha(200)
            : Colors.grey.withAlpha(200),
        onPressed: enabled && !isRequesting && state.hasNextChunk
            ? () async {
                await handleUpdateAction(
                  context: context,
                  targetBloc: context.read<DataLogChartBloc>(),
                  waitForState: (state) {
                    DataLogChartState dataLogChartState =
                        state as DataLogChartState;

                    return dataLogChartState.formStatus.isRequestFailure ||
                        dataLogChartState.formStatus.isRequestSuccess;
                  },
                  action: () {
                    context
                        .read<DataLogChartBloc>()
                        .add(const MoreLogRequested());
                  },
                );
              }
            : null,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      );
    });
  }
}

class _LogChartContent extends StatelessWidget {
  const _LogChartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadingStatus.isRequestInProgress) {
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
                        context: context,
                        lineSeriesCollection: getChartDataOfLog1(
                          dateValueCollectionOfLog: [[], [], [], [], []],
                        )),
                    const SizedBox(
                      height: 50.0,
                    ),
                    buildChart(
                      context: context,
                      lineSeriesCollection: getChartDataOfLog2(
                        dateValueCollectionOfLog: [[], [], [], [], []],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const _LogChartListView();
        }
      },
    );
  }
}

class _LogChartListView extends StatelessWidget {
  const _LogChartListView();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // HomeState homeState = context.watch<HomeBloc>().state;
        DataLogChartState dataLogChartState =
            context.watch<DataLogChartBloc>().state;

        // if (homeState.loadingStatus.isRequestSuccess ) {
        if (dataLogChartState.formStatus.isNone) {
          print('===== get log ======');

          context.read<Chart18Bloc>().add(const TabChangedDisabled());

          // load more 的時候不用 Initialized
          if (!dataLogChartState.moreLogRequestStatus.isRequestInProgress) {
            handleUpdateAction(
              context: context,
              targetBloc: context.read<DataLogChartBloc>(),
              waitForState: (state) {
                DataLogChartState dataLogChartState =
                    state as DataLogChartState;

                return dataLogChartState.formStatus.isRequestFailure ||
                    dataLogChartState.formStatus.isRequestSuccess;
              },
              action: () {
                context.read<DataLogChartBloc>().add(const Initialized());
              },
            );

            // context.read<DataLogChartBloc>().add(const Initialized());
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              buildLoadingFormWithProgressiveChartView(
                context: context,
                dateValueCollectionOfLog:
                    dataLogChartState.dateValueCollectionOfLog,
              ),
            ],
          );
          // if (homeState.periodicUpdateEnabled) {
          //   context
          //       .read<HomeBloc>()
          //       .add(const DevicePeriodicUpdateCanceled());

          //   return Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       buildLoadingFormWithProgressiveChartView(
          //         dateValueCollectionOfLog:
          //             dataLogChartState.dateValueCollectionOfLog,
          //       ),
          //     ],
          //   );
          // } else {
          //   print('===== get log ======');

          //   context.read<Chart18Bloc>().add(const TabChangedDisabled());

          //   // load more 的時候不用 Initialized
          //   if (!dataLogChartState.moreLogRequestStatus.isRequestInProgress) {
          //     context.read<DataLogChartBloc>().add(const Initialized());
          //   }

          //   return Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       buildLoadingFormWithProgressiveChartView(
          //         dateValueCollectionOfLog:
          //             dataLogChartState.dateValueCollectionOfLog,
          //       ),
          //     ],
          //   );
          // }
        } else if (dataLogChartState.formStatus.isRequestInProgress) {
          return Stack(
            alignment: Alignment.center,
            children: [
              buildLoadingFormWithProgressiveChartView(
                context: context,
                dateValueCollectionOfLog:
                    dataLogChartState.dateValueCollectionOfLog,
              ),
            ],
          );
        } else if (dataLogChartState.formStatus.isRequestFailure) {
          context.read<Chart18Bloc>().add(const TabChangedEnabled());
          return SingleChildScrollView(
            // 設定 key, 讓 chart 可以 rebuild
            // 如果沒有設定 key, flutter widget tree 會認為不需要rebuild chart
            key: const Key('ChartForm_Chart'),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildChart(
                    context: context,
                    lineSeriesCollection: getChartDataOfLog1(
                        dateValueCollectionOfLog:
                            dataLogChartState.dateValueCollectionOfLog),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  buildChart(
                    context: context,
                    lineSeriesCollection: getChartDataOfLog2(
                        dateValueCollectionOfLog:
                            dataLogChartState.dateValueCollectionOfLog),
                  ),
                ],
              ),
            ),
          );
        } else {
          // dataLogChartState.formStatus.isRequestSuccess
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
                      context: context,
                      lineSeriesCollection: getChartDataOfLog1(
                          dateValueCollectionOfLog:
                              dataLogChartState.dateValueCollectionOfLog),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    buildChart(
                      context: context,
                      lineSeriesCollection: getChartDataOfLog2(
                          dateValueCollectionOfLog:
                              dataLogChartState.dateValueCollectionOfLog),
                    ),
                    const SizedBox(
                      height: CustomStyle.formBottomSpacingS,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        // } else {
        //   context.read<Chart18Bloc>().add(const TabChangedEnabled());
        //   return Center(
        //     child: SingleChildScrollView(
        //       // 設定 key, 讓 chart 可以 rebuild 並繪製空的資料
        //       // 如果沒有設定 key, flutter widget tree 會認為不需要rebuild chart
        //       key: const Key('ChartForm_Empty_Chart'),
        //       child: Padding(
        //         padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 60.0),
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: <Widget>[
        //             buildChart(
        //                 context: context,
        //                 lineSeriesCollection: getChartDataOfLog1(
        //                   dateValueCollectionOfLog: [[], [], [], [], []],
        //                 )),
        //             const SizedBox(
        //               height: 50.0,
        //             ),
        //             buildChart(
        //               context: context,
        //               lineSeriesCollection: getChartDataOfLog2(
        //                 dateValueCollectionOfLog: [[], [], [], [], []],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   );
        // }
      },
    );
  }
}

List<LineSeries> getChartDataOfLog1({
  required List<List<ValuePair>> dateValueCollectionOfLog,
}) {
  LineSeries temperatureLineSeries = LineSeries(
    name: 'Temperature (${CustomStyle.celciusUnit})',
    dataList: dateValueCollectionOfLog[0],
    color: Colors.indigo,
    minYAxisValue: -30.0,
    maxYAxisValue: 100.0,
  );
  LineSeries rfOutputLowPilotLineSeries = LineSeries(
    name: 'RF Output Low Pilot (${CustomStyle.dBmV})',
    dataList: dateValueCollectionOfLog[1],
    color: const Color(0xffff5963),
    minYAxisValue: 0.0,
    maxYAxisValue: 300.0,
  );
  LineSeries rfOutputHighPilotLineSeries = LineSeries(
    name: 'RF Output High Pilot (${CustomStyle.dBmV})',
    dataList: dateValueCollectionOfLog[2],
    color: const Color(0xff249689),
    minYAxisValue: 0.0,
    maxYAxisValue: 300.0,
  );

  return [
    temperatureLineSeries,
    rfOutputLowPilotLineSeries,
    rfOutputHighPilotLineSeries,
  ];
}

List<LineSeries> getChartDataOfLog2({
  required List<List<ValuePair>> dateValueCollectionOfLog,
}) {
  LineSeries voltageLineSeries = LineSeries(
    name: '24 (${CustomStyle.volt})',
    dataList: dateValueCollectionOfLog[3],
    color: const Color(0xffff5963),
    minYAxisValue: 0.0,
    maxYAxisValue: 40.0,
  );
  LineSeries voltageRippleLineSeries = LineSeries(
    name: '24V Ripple (${CustomStyle.milliVolt})',
    dataList: dateValueCollectionOfLog[4],
    color: Colors.indigo,
    minYAxisValue: 0.0,
    maxYAxisValue: 500.0,
  );

  return [
    voltageLineSeries,
    voltageRippleLineSeries,
  ];
}

Widget buildChart({
  required BuildContext context,
  required List<LineSeries> lineSeriesCollection,
}) {
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

Widget buildLoadingFormWithProgressiveChartView({
  required BuildContext context,
  required List<List<ValuePair>> dateValueCollectionOfLog,
}) {
  String intValue = Random().nextInt(100).toString();
  List<LineSeries> log1Data = [];
  List<LineSeries> logVoltage = [];
  if (dateValueCollectionOfLog.isEmpty) {
    log1Data = getChartDataOfLog1(
      dateValueCollectionOfLog: dateValueCollectionOfLog,
    );
    logVoltage = getChartDataOfLog2(
      dateValueCollectionOfLog: dateValueCollectionOfLog,
    );
  } else {
    log1Data = getChartDataOfLog1(
      dateValueCollectionOfLog: dateValueCollectionOfLog,
    );
    logVoltage = getChartDataOfLog2(
      dateValueCollectionOfLog: dateValueCollectionOfLog,
    );
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
              buildChart(
                context: context,
                lineSeriesCollection: log1Data,
              ),
              const SizedBox(
                height: 50.0,
              ),
              buildChart(
                context: context,
                lineSeriesCollection: logVoltage,
              ),
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

import 'dart:math';
import 'package:aci_plus_app/chart/chart/chart18_bloc/chart18_bloc.dart';
import 'package:aci_plus_app/chart/chart/data_log_chart_bloc/data_log_chart_bloc.dart';
import 'package:aci_plus_app/chart/view/full_screen_chart_form.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
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
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    Future<bool?> showNoMoreDataDialog() async {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitleSuccess,
              style: const TextStyle(
                color: CustomStyle.customGreen,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.dialogMessageNoMoreLogs,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageOk,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> showFailureDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitleError,
              style: const TextStyle(
                color: CustomStyle.customRed,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    getMessageLocalization(
                      msg: msg,
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    return BlocListener<DataLogChartBloc, DataLogChartState>(
      listener: (context, state) async {
        if (state.logRequestStatus.isRequestSuccess) {
          if (!state.hasNextChunk) {
            // 避免 dialog 重複跳出
            if (ModalRoute.of(context)?.isCurrent == true) {
              showNoMoreDataDialog();
            }
          }
        } else if (state.logRequestStatus.isRequestFailure) {
          showFailureDialog(state.errorMessage);
        }

        // 如果 state.logRequestStatus 滿足 isRequestSuccess, state.eventRequestStatus 滿足 isRequestFailure
        if (state.eventRequestStatus.isRequestFailure) {
          showFailureDialog(state.errorMessage);
        }
      },
      child: Scaffold(
        body: const _LogChartListView(),
        floatingActionButton: const _MoreDataFloatingActionButton(),
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
    super.key,
    required this.pageController,
    required this.selectedIndex,
  });

  final PageController pageController;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataLogChartBloc, DataLogChartState>(
      builder: (context, state) {
        if (state.eventRequestStatus.isRequestInProgress ||
            state.logRequestStatus.isRequestInProgress) {
          return HomeBottomNavigationBar(
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
          return HomeBottomNavigationBar(
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

class _MoreDataFloatingActionButton extends StatelessWidget {
  const _MoreDataFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataLogChartBloc, DataLogChartState>(
      builder: (context, state) {
        if (state.logRequestStatus.isRequestInProgress) {
          return Container();
        } else {
          return FloatingActionButton(
            shape: const CircleBorder(
              side: BorderSide.none,
            ),
            backgroundColor:
                Theme.of(context).colorScheme.primary.withAlpha(200),
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              context.read<DataLogChartBloc>().add(const MoreLogRequested());
            },
          );
        }
      },
    );
  }
}

class _LogChartListView extends StatelessWidget {
  const _LogChartListView({super.key});

  @override
  Widget build(BuildContext context) {
    List<LineSeries> getChartDataOfLog1({
      required List<List<ValuePair>> dateValueCollectionOfLog,
    }) {
      LineSeries temperatureLineSeries = LineSeries(
        name: 'Temperature (${CustomStyle.celciusUnit})',
        dataList: dateValueCollectionOfLog[0],
        color: Theme.of(context).colorScheme.primary,
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
        name: '24V',
        dataList: dateValueCollectionOfLog[3],
        color: const Color(0xffff5963),
        minYAxisValue: 0.0,
        maxYAxisValue: 40.0,
      );
      LineSeries voltageRippleLineSeries = LineSeries(
        name: '24V Ripple (${CustomStyle.milliVolt})',
        dataList: dateValueCollectionOfLog[4],
        color: Theme.of(context).colorScheme.primary,
        minYAxisValue: 0.0,
        maxYAxisValue: 500.0,
      );
      return [
        voltageLineSeries,
        voltageRippleLineSeries,
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
                    title: AppLocalizations.of(context)!.monitoringChart,
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
      String intValue = Random().nextInt(100).toString();
      List<LineSeries> log1Data = [];
      List<LineSeries> logVoltage = [];
      if (dateValueCollectionOfLog.isEmpty) {
        log1Data = getChartDataOfLog1(
            dateValueCollectionOfLog: dateValueCollectionOfLog);
        logVoltage = getChartDataOfLog2(
            dateValueCollectionOfLog: dateValueCollectionOfLog);
      } else {
        log1Data = getChartDataOfLog1(
            dateValueCollectionOfLog: dateValueCollectionOfLog);
        logVoltage = getChartDataOfLog2(
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
                  buildChart(log1Data),
                  const SizedBox(
                    height: 50.0,
                  ),
                  buildChart(logVoltage),
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
        DataLogChartState dataLogChartState =
            context.watch<DataLogChartBloc>().state;

        if (homeState.loadingStatus == FormStatus.requestInProgress) {
          return Stack(
            alignment: Alignment.center,
            children: [
              buildLoadingFormWithProgressiveChartView(
                  dataLogChartState.dateValueCollectionOfLog),
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
          if (dataLogChartState.logRequestStatus.isNone) {
            print('===== get log ======');
            context.read<Chart18Bloc>().add(const TabChangedDisabled());
            context.read<DataLogChartBloc>().add(const LogRequested());
            return Stack(
              alignment: Alignment.center,
              children: [
                buildLoadingFormWithProgressiveChartView(
                    dataLogChartState.dateValueCollectionOfLog),
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
          } else if (dataLogChartState.logRequestStatus.isRequestInProgress) {
            return Stack(
              alignment: Alignment.center,
              children: [
                buildLoadingFormWithProgressiveChartView(
                    dataLogChartState.dateValueCollectionOfLog),
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
          } else if (dataLogChartState.logRequestStatus.isRequestFailure) {
            context.read<Chart18Bloc>().add(const TabChangedEnabled());
            return SingleChildScrollView(
              // 設定 key, 讓 chart 可以 rebuild
              // 如果沒有設定 key, flutter widget tree 會認為不需要rebuild chart
              key: const Key('ChartForm_Chart'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildChart(
                      getChartDataOfLog1(
                          dateValueCollectionOfLog:
                              dataLogChartState.dateValueCollectionOfLog),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    buildChart(
                      getChartDataOfLog2(
                          dateValueCollectionOfLog:
                              dataLogChartState.dateValueCollectionOfLog),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // dataLogChartState.logRequestStatus.isRequestSuccess
            if (dataLogChartState.eventRequestStatus.isNone) {
              print('===== get event ======');
              context.read<Chart18Bloc>().add(const TabChangedDisabled());
              context.read<DataLogChartBloc>().add(const Event1P8GRequested());
              return Stack(
                alignment: Alignment.center,
                children: [
                  buildLoadingFormWithProgressiveChartView(
                      dataLogChartState.dateValueCollectionOfLog),
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
            } else if (dataLogChartState
                .eventRequestStatus.isRequestInProgress) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  buildLoadingFormWithProgressiveChartView(
                      dataLogChartState.dateValueCollectionOfLog),
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
            } else if (dataLogChartState.eventRequestStatus.isRequestFailure) {
              context.read<Chart18Bloc>().add(const TabChangedEnabled());
              return SingleChildScrollView(
                // 設定 key, 讓 chart 可以 rebuild
                // 如果沒有設定 key, flutter widget tree 會認為不需要rebuild chart
                key: const Key('ChartForm_Chart'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildChart(
                        getChartDataOfLog1(
                            dateValueCollectionOfLog:
                                dataLogChartState.dateValueCollectionOfLog),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      buildChart(
                        getChartDataOfLog2(
                            dateValueCollectionOfLog:
                                dataLogChartState.dateValueCollectionOfLog),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // dataLogChartState.eventRequestStatus.isRequestSuccess
              context.read<Chart18Bloc>().add(const TabChangedEnabled());
              return Center(
                child: SingleChildScrollView(
                  // 設定 key, 讓 chart 可以 rebuild
                  // 如果沒有設定 key, flutter widget tree 會認為不需要rebuild chart
                  key: const Key('ChartForm_Chart'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildChart(
                          getChartDataOfLog1(
                              dateValueCollectionOfLog:
                                  dataLogChartState.dateValueCollectionOfLog),
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        buildChart(
                          getChartDataOfLog2(
                              dateValueCollectionOfLog:
                                  dataLogChartState.dateValueCollectionOfLog),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        } else {
          context.read<Chart18Bloc>().add(const TabChangedEnabled());
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
                    getChartDataOfLog1(
                        dateValueCollectionOfLog:
                            dataLogChartState.dateValueCollectionOfLog),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  buildChart(
                    getChartDataOfLog2(
                        dateValueCollectionOfLog:
                            dataLogChartState.dateValueCollectionOfLog),
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

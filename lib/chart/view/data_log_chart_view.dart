import 'dart:math';
import 'package:dsim_app/chart/chart/chart18_bloc/chart18_bloc.dart';
import 'package:dsim_app/chart/chart/data_log_chart_bloc/data_log_chart_bloc.dart';
import 'package:dsim_app/chart/view/download_indicator.dart';
import 'package:dsim_app/chart/view/full_screen_chart_form.dart';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/message_localization.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/home/views/home_bottom_navigation_bar.dart';
import 'package:dsim_app/repositories/dsim18_parser.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

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
              AppLocalizations.of(context).dialogTitleSuccess,
              style: const TextStyle(
                color: CustomStyle.customGreen,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).dialogMessageNoMoreLogs,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context).dialogMessageOk,
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
              AppLocalizations.of(context).dialogTitleError,
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
            showNoMoreDataDialog();
          }
        } else if (state.logRequestStatus.isRequestFailure) {
          showFailureDialog(state.errorMessage);
        } else if (state.dataExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)
                      .dialogMessageDataExportSuccessful,
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context).open,
                  onPressed: () async {
                    OpenResult result = await OpenFilex.open(
                      state.dataExportPath,
                      type: 'application/vnd.ms-excel',
                      uti: 'com.microsoft.excel.xls',
                    );
                    print(result.message);
                  },
                ),
              ),
            );
        } else if (state.dataShareStatus.isRequestSuccess) {
          String partNo = context
              .read<HomeBloc>()
              .state
              .characteristicData[DataKey.partNo]!;
          String location = context
              .read<HomeBloc>()
              .state
              .characteristicData[DataKey.location]!;

          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          Share.shareXFiles(
            [XFile(state.dataExportPath)],
            subject: state.exportFileName,
            text: '$partNo / $location',
            sharePositionOrigin:
                Rect.fromLTWH(0.0, height / 2, width, height / 2),
          );
        } else if (state.allDataExportStatus.isRequestInProgress) {
          List<dynamic>? resultOfDownload = await showDialog<List<dynamic>>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext buildContext) {
              return WillPopScope(
                onWillPop: () async {
                  // 避免 Android 使用者點擊系統返回鍵關閉 dialog
                  return false;
                },
                child: DownloadIndicatorForm(
                  dsimRepository:
                      RepositoryProvider.of<DsimRepository>(context),
                ),
              );
            },
          );

          if (resultOfDownload != null) {
            bool isSuccessful = resultOfDownload[0];
            List<Log1p8G> log1p8Gs = resultOfDownload[1];
            String errorMessage = resultOfDownload[2];
            // context.read<DataLogChartBloc>().add(AllDataExported(
            //       isSuccessful,
            //       log1p8Gs,
            //       errorMessage,
            //     ));
          }
        } else if (state.allDataExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)
                      .dialogMessageDataExportSuccessful,
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context).open,
                  onPressed: () async {
                    OpenResult result = await OpenFilex.open(
                      state.dataExportPath,
                      type: 'application/vnd.ms-excel',
                      uti: 'com.microsoft.excel.xls',
                    );
                    print(result.message);
                  },
                ),
              ),
            );
        } else if (state.allDataExportStatus.isRequestFailure) {
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
    return BlocBuilder<Chart18Bloc, Chart18State>(
      builder: (context, state) {
        if (state.eventDataRequestStatus.isRequestInProgress ||
            state.dataRequestStatus.isRequestInProgress) {
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
    return BlocBuilder<Chart18Bloc, Chart18State>(
      builder: (context, state) {
        if (state.dataRequestStatus.isRequestInProgress) {
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
          } else {
            if (dataLogChartState.eventRequestStatus.isNone) {
              print('===== get event ======');
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

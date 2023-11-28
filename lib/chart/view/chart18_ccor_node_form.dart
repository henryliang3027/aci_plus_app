import 'dart:math';

import 'package:aci_plus_app/chart/chart/chart18_ccor_node_bloc/chart18_ccor_node_bloc.dart';
import 'package:aci_plus_app/chart/view/download_indicator18_ccor_node.dart';
import 'package:aci_plus_app/chart/view/full_screen_chart_form.dart';
import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_bottom_navigation_bar.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_parser.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

class Chart18CCorNodeForm extends StatelessWidget {
  const Chart18CCorNodeForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
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

    return BlocListener<Chart18CCorNodeBloc, Chart18CCorNodeState>(
      listener: (context, state) async {
        if (state.dataExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)!
                      .dialogMessageDataExportSuccessful,
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.open,
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
                child: DownloadIndicator18CCorNodeForm(
                  dsimRepository:
                      RepositoryProvider.of<Amp18CCorNodeRepository>(context),
                ),
              );
            },
          );

          if (resultOfDownload != null) {
            bool isSuccessful = resultOfDownload[0];
            List<Log1p8GCCorNode> log1p8Gs = resultOfDownload[1];
            String errorMessage = resultOfDownload[2];
            context.read<Chart18CCorNodeBloc>().add(AllDataExported(
                  isSuccessful,
                  log1p8Gs,
                  errorMessage,
                ));
          }
        } else if (state.allDataExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)!
                      .dialogMessageDataExportSuccessful,
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.open,
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
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.monitoringChart,
          ),
          centerTitle: true,
          leading: const _DeviceStatus(),
          actions: const [
            _PopupMenu(),
          ],
        ),
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

class _DeviceStatus extends StatelessWidget {
  const _DeviceStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.scanStatus.isRequestSuccess) {
          if (state.connectionStatus.isRequestSuccess) {
            return const Icon(
              Icons.bluetooth_connected_outlined,
            );
          } else if (state.connectionStatus.isRequestFailure) {
            return const Icon(
              Icons.nearby_error,
              color: Colors.amber,
            );
          } else {
            return const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              ),
            );
          }
        } else if (state.scanStatus.isRequestFailure) {
          return const Icon(
            Icons.nearby_error_outlined,
          );
        } else {
          return const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}

enum DataLogMenu {
  refresh,
  share,
  export,
  downloadAll,
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({super.key});

  Widget buildDataLogPageMenu(BuildContext context) {
    return BlocBuilder<Chart18CCorNodeBloc, Chart18CCorNodeState>(
      builder: (context, state) {
        return PopupMenuButton<DataLogMenu>(
          icon: const Icon(
            Icons.more_vert_outlined,
            color: Colors.white,
          ),
          tooltip: '',
          onSelected: (DataLogMenu item) async {
            switch (item) {
              case DataLogMenu.refresh:
                context.read<HomeBloc>().add(const DeviceRefreshed());
                break;
              case DataLogMenu.share:
                context.read<Chart18CCorNodeBloc>().add(const DataShared());
                break;
              case DataLogMenu.export:
                context.read<Chart18CCorNodeBloc>().add(const DataExported());
                break;
              case DataLogMenu.downloadAll:
                context
                    .read<Chart18CCorNodeBloc>()
                    .add(const AllDataDownloaded());
                break;
              default:
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<DataLogMenu>>[
            PopupMenuItem<DataLogMenu>(
              value: DataLogMenu.refresh,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.refresh,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(AppLocalizations.of(context)!.reconnect),
                ],
              ),
            ),
            PopupMenuItem<DataLogMenu>(
              value: DataLogMenu.share,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.share,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(AppLocalizations.of(context)!.share),
                ],
              ),
            ),
            PopupMenuItem<DataLogMenu>(
              value: DataLogMenu.export,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.download,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(AppLocalizations.of(context)!.export),
                ],
              ),
            ),
            PopupMenuItem<DataLogMenu>(
              value: DataLogMenu.downloadAll,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.cloud_download_outlined,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(AppLocalizations.of(context)!.downloadAll),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state.loadingStatus.isRequestSuccess) {
        return buildDataLogPageMenu(context);
      } else {
        if (!state.connectionStatus.isRequestInProgress) {
          return IconButton(
              onPressed: () {
                context.read<HomeBloc>().add(const DeviceRefreshed());
              },
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onPrimary,
              ));
        } else {
          return Container();
        }
      }
    });
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
    return BlocBuilder<Chart18CCorNodeBloc, Chart18CCorNodeState>(
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
    return BlocBuilder<Chart18CCorNodeBloc, Chart18CCorNodeState>(
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
              context.read<Chart18CCorNodeBloc>().add(const MoreLogRequested());
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

      return [
        temperatureLineSeries,
      ];
    }

    List<LineSeries> getChartDataOfLog2({
      required List<List<ValuePair>> dateValueCollectionOfLog,
    }) {
      LineSeries rfOutputPower1 = LineSeries(
        name: 'Port 1 RF Output Power (${CustomStyle.dBmV})',
        dataList: dateValueCollectionOfLog[1],
        color: const Color(0xffff5963),
        minYAxisValue: 0.0,
        maxYAxisValue: 60.0,
      );
      LineSeries rfOutputPower3 = LineSeries(
        name: 'Port 3 RF Output Power (${CustomStyle.dBmV})',
        dataList: dateValueCollectionOfLog[2],
        color: Theme.of(context).colorScheme.primary,
        minYAxisValue: 0.0,
        maxYAxisValue: 60.0,
      );
      LineSeries rfOutputPower4 = LineSeries(
        name: 'Port 4 RF Output Power (${CustomStyle.dBmV})',
        dataList: dateValueCollectionOfLog[3],
        color: const Color(0xFFFFC859),
        minYAxisValue: 0.0,
        maxYAxisValue: 60.0,
      );
      LineSeries rfOutputPower6 = LineSeries(
        name: 'Port 6 RF Output Power (${CustomStyle.dBmV})',
        dataList: dateValueCollectionOfLog[4],
        color: const Color(0xff249689),
        minYAxisValue: 0.0,
        maxYAxisValue: 60.0,
      );
      return [
        rfOutputPower1,
        rfOutputPower3,
        rfOutputPower4,
        rfOutputPower6,
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
        Chart18CCorNodeState dataLogChartState =
            context.watch<Chart18CCorNodeBloc>().state;

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
            context.read<Chart18CCorNodeBloc>().add(const LogRequested());
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
              context
                  .read<Chart18CCorNodeBloc>()
                  .add(const Event1P8GCCorNodeRequested());
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

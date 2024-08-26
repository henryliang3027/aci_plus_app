import 'dart:io';
import 'dart:math';

import 'package:aci_plus_app/chart/bloc/chart18_ccor_node/chart18_ccor_node_bloc.dart';
import 'package:aci_plus_app/chart/shared/share_file_widget.dart';
import 'package:aci_plus_app/chart/view/code_input_page.dart';
import 'package:aci_plus_app/chart/view/downloader18_ccor_node_page.dart';
import 'package:aci_plus_app/chart/view/full_screen_chart_form.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_button_navigation_bar18.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:open_filex/open_filex.dart';

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
              ElevatedButton(
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
                backgroundColor: Theme.of(context).dialogBackgroundColor,
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)!
                      .dialogMessageDataExportSuccessful,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                action: SnackBarAction(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  label: AppLocalizations.of(context)!.open,
                  onPressed: () async {
                    OpenFilex.open(
                      state.dataExportPath,
                      type: 'application/vnd.ms-excel',
                      uti: 'com.microsoft.excel.xls',
                    ).then((OpenResult result) {
                      if (result.type == ResultType.noAppToOpen) {
                        showFailureDialog(AppLocalizations.of(context)!
                            .dialogMessageFileOpenFailed);
                      }
                    });
                  },
                ),
              ),
            );
        } else if (state.dataShareStatus.isRequestSuccess) {
          String partName = context
              .read<HomeBloc>()
              .state
              .characteristicData[DataKey.partName]!;
          String location = context
              .read<HomeBloc>()
              .state
              .characteristicData[DataKey.location]!;

          openShareFileWidget(
            context: context,
            subject: state.exportFileName,
            body: '$partName / $location',
            attachmentPath: state.dataExportPath,
          );
        } else if (state.allDataExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).dialogBackgroundColor,
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)!
                      .dialogMessageDataExportSuccessful,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                action: SnackBarAction(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  label: AppLocalizations.of(context)!.open,
                  onPressed: () async {
                    OpenFilex.open(
                      state.dataExportPath,
                      type: 'application/vnd.ms-excel',
                      uti: 'com.microsoft.excel.xls',
                    ).then((OpenResult result) {
                      if (result.type == ResultType.noAppToOpen) {
                        showFailureDialog(AppLocalizations.of(context)!
                            .dialogMessageFileOpenFailed);
                      }
                    });
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
        floatingActionButton: const _DataLogFloatingActionButton(),
        bottomNavigationBar: _DynamicBottomNavigationBar(
          pageController: pageController,
          selectedIndex: 3,
        ),
      ),
    );
  }
}

class _DeviceStatus extends StatelessWidget {
  const _DeviceStatus();

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
        } else if (state.scanStatus.isRequestInProgress) {
          return const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        } else {
          return const Center();
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

Future<String?> showEnterCodeDialog({
  required BuildContext context,
}) async {
  return showDialog<String?>(
      context: context,
      builder: (context) {
        return const CodeInputPage();
      });
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu();

  Widget buildDataLogPageMenu(BuildContext context) {
    Map<DataKey, String> characteristicData =
        context.read<HomeBloc>().state.characteristicData;

    Future<List<dynamic>?> showDownloadDialog() async {
      return showDialog<List<dynamic>>(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return const Dialog(
            child: Downloader18CCorNodePage(),
          );
        },
      );
    }

    return BlocBuilder<Chart18CCorNodeBloc, Chart18CCorNodeState>(
      builder: (context, state) {
        return PopupMenuButton<DataLogMenu>(
          icon: const Icon(
            Icons.more_vert_outlined,
            color: Colors.white,
          ),
          tooltip: '',
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<DataLogMenu>>[
              menuItem(
                value: DataLogMenu.refresh,
                iconData: Icons.refresh,
                title: AppLocalizations.of(context)!.reconnect,
                onTap: () {
                  context.read<HomeBloc>().add(const DeviceRefreshed());
                },
              ),
              menuItem(
                value: DataLogMenu.share,
                iconData: Icons.share,
                title: AppLocalizations.of(context)!.share,
                onTap: () {
                  showEnterCodeDialog(context: context).then((String? code) {
                    if (code != null) {
                      if (code.isNotEmpty) {
                        context.read<Chart18CCorNodeBloc>().add(DataShared(
                              code: code,
                            ));
                      }
                    }
                  });
                },
              ),
              menuItem(
                value: DataLogMenu.export,
                iconData: Icons.download,
                title: AppLocalizations.of(context)!.export,
                onTap: () {
                  showEnterCodeDialog(context: context).then((String? code) {
                    if (code != null) {
                      if (code.isNotEmpty) {
                        context.read<Chart18CCorNodeBloc>().add(DataExported(
                              code: code,
                            ));
                      }
                    }
                  });
                },
              ),
              menuItem(
                value: DataLogMenu.downloadAll,
                iconData: Icons.cloud_download_outlined,
                title: AppLocalizations.of(context)!.downloadAll,
                onTap: () {
                  showEnterCodeDialog(context: context).then((String? code) {
                    if (code != null) {
                      if (code.isNotEmpty) {
                        showDownloadDialog()
                            .then((List<dynamic>? resultOfDownload) {
                          if (resultOfDownload != null) {
                            bool isSuccessful = resultOfDownload[0];
                            List<Log1p8GCCorNode> log1p8Gs =
                                resultOfDownload[1];
                            String errorMessage = resultOfDownload[2];

                            context
                                .read<Chart18CCorNodeBloc>()
                                .add(AllDataExported(
                                  isSuccessful: isSuccessful,
                                  log1p8Gs: log1p8Gs,
                                  errorMessage: errorMessage,
                                  code: code,
                                ));
                          }
                        });
                      }
                    }
                  });
                },
              ),
            ];
          },
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
        if (!state.loadingStatus.isRequestInProgress &&
            !state.connectionStatus.isRequestInProgress) {
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
        if (state.loadingStatus.isRequestSuccess) {
          return const _MoreDataFloatingActionButton(
            enabled: true,
          );
        } else {
          return const _MoreDataFloatingActionButton(
            enabled: false,
          );
        }
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
    return BlocBuilder<Chart18CCorNodeBloc, Chart18CCorNodeState>(
      builder: (context, state) {
        bool isRequesting = state.logRequestStatus.isNone ||
            state.logRequestStatus.isRequestInProgress;

        return FloatingActionButton(
          shape: const CircleBorder(
            side: BorderSide.none,
          ),
          backgroundColor: enabled && !isRequesting
              ? Theme.of(context).colorScheme.primary.withAlpha(200)
              : Colors.grey.withAlpha(200),
          onPressed: enabled && !isRequesting
              ? () {
                  context
                      .read<Chart18CCorNodeBloc>()
                      .add(const MoreLogRequested());
                }
              : null,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        );
      },
    );
  }
}

class _LogChartListView extends StatelessWidget {
  const _LogChartListView();

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
            padding: const EdgeInsets.all(10.0),
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
              child: const Icon(
                Icons.fullscreen_outlined,
              ),
            ),
          ),
          SpeedLineChart(
            lineSeriesCollection: lineSeriesCollection,
            showLegend: true,
            showScaleThumbs: Platform.isWindows ? true : false,
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
            // 設定 key, 讓 chart 可以 rebuild
            // 如果沒有設定 key, flutter widget tree 會認為不需要rebuild chart
            key: Key('ChartForm_${intValue}_Chart'),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 60.0),
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

        if (homeState.loadingStatus.isRequestInProgress) {
          return buildLoadingFormWithProgressiveChartView([[], [], [], [], []]);
        } else if (homeState.loadingStatus == FormStatus.requestSuccess) {
          if (dataLogChartState.logRequestStatus.isNone) {
            print('===== get log ======');
            context.read<Chart18CCorNodeBloc>().add(const LogRequested());
            return buildLoadingFormWithProgressiveChartView(
                dataLogChartState.dateValueCollectionOfLog);
          } else if (dataLogChartState.logRequestStatus.isRequestInProgress) {
            return buildLoadingFormWithProgressiveChartView(
                dataLogChartState.dateValueCollectionOfLog);
          } else if (dataLogChartState.logRequestStatus.isRequestFailure) {
            return buildLoadingFormWithProgressiveChartView(
                dataLogChartState.dateValueCollectionOfLog);
          } else {
            if (dataLogChartState.eventRequestStatus.isNone) {
              print('===== get event ======');
              context
                  .read<Chart18CCorNodeBloc>()
                  .add(const Event1P8GCCorNodeRequested());
              return buildLoadingFormWithProgressiveChartView(
                  dataLogChartState.dateValueCollectionOfLog);
            } else if (dataLogChartState
                .eventRequestStatus.isRequestInProgress) {
              return buildLoadingFormWithProgressiveChartView(
                  dataLogChartState.dateValueCollectionOfLog);
            } else if (dataLogChartState.eventRequestStatus.isRequestFailure) {
              return buildLoadingFormWithProgressiveChartView(
                  dataLogChartState.dateValueCollectionOfLog);
            } else {
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
            key: const Key('ChartForm_Empty_Chart'),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildChart(
                    getChartDataOfLog1(
                      dateValueCollectionOfLog: [[], [], [], [], []],
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  buildChart(
                    getChartDataOfLog2(
                      dateValueCollectionOfLog: [[], [], [], [], []],
                    ),
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

import 'dart:io';
import 'dart:math';

import 'package:aci_plus_app/chart/bloc/chart/chart_bloc.dart';
import 'package:aci_plus_app/chart/shared/message_dialog.dart';
import 'package:aci_plus_app/chart/shared/share_file_widget.dart';
import 'package:aci_plus_app/chart/view/full_screen_chart_form.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_speed_chart/speed_chart.dart';

class ChartForm extends StatelessWidget {
  const ChartForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChartBloc, ChartState>(
      listener: (context, state) {
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
                        showFailureDialog(
                          context: context,
                          msg: AppLocalizations.of(context)!
                              .dialogMessageFileOpenFailed,
                        );
                      }
                    });
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

          openShareFileWidget(
            context: context,
            subject: state.exportFileName,
            body: '$partNo / $location',
            attachmentPath: state.dataExportPath,
          );
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
        body: const _LogChartView(),
        bottomNavigationBar: HomeBottomNavigationBar(
          pageController: pageController,
          selectedIndex: 3,
          onTap: (int index) {
            pageController.jumpToPage(
              index,
            );
          },
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

enum Menu { refresh, share, export }

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state.eventLoadingStatus.isRequestSuccess) {
        return PopupMenuButton<Menu>(
          icon: const Icon(
            Icons.more_vert_outlined,
            color: Colors.white,
          ),
          tooltip: '',
          onSelected: (Menu item) async {
            switch (item) {
              case Menu.refresh:
                context.read<HomeBloc>().add(const DeviceRefreshed());
                break;
              case Menu.share:
                context.read<ChartBloc>().add(const DataShared());
                break;
              case Menu.export:
                context.read<ChartBloc>().add(const DataExported());
                break;
              default:
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
            menuItem(
              value: Menu.refresh,
              iconData: Icons.refresh,
              title: AppLocalizations.of(context)!.reconnect,
              onTap: () {
                context.read<HomeBloc>().add(const DeviceRefreshed());
              },
            ),
            menuItem(
              value: Menu.share,
              iconData: Icons.share,
              title: AppLocalizations.of(context)!.share,
              onTap: () {
                context.read<ChartBloc>().add(const DataShared());
              },
            ),
            menuItem(
              value: Menu.export,
              iconData: Icons.download,
              title: AppLocalizations.of(context)!.export,
              onTap: () {
                context.read<ChartBloc>().add(const DataExported());
              },
            ),
          ],
        );
      } else {
        if (!state.eventLoadingStatus.isRequestInProgress &&
            !state.loadingStatus.isRequestInProgress &&
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

class _LogChartView extends StatelessWidget {
  const _LogChartView();

  @override
  Widget build(BuildContext context) {
    List<LineSeries> getChartDataOfLog1({
      required List<List<ValuePair>> dateValueCollectionOfLog,
    }) {
      LineSeries attenuationLineSeries = LineSeries(
        name: 'Attenuation',
        dataList: dateValueCollectionOfLog[0],
        color: const Color(0xffff5963),
        minYAxisValue: 0.0,
        maxYAxisValue: 4000.0,
      );
      LineSeries temperatureLineSeries = LineSeries(
        name: 'Temperature (${CustomStyle.celciusUnit})',
        dataList: dateValueCollectionOfLog[1],
        color: Theme.of(context).colorScheme.primary,
        minYAxisValue: -30.0,
        maxYAxisValue: 100.0,
      );

      LineSeries pilotLineSeries = LineSeries(
        name: 'Pilot',
        dataList: dateValueCollectionOfLog[2],
        color: const Color(0xff249689),
        minYAxisValue: 0.0,
        maxYAxisValue: 300.0,
      );

      return [
        attenuationLineSeries,
        temperatureLineSeries,
        pilotLineSeries,
      ];
    }

    List<LineSeries> getChartDataOfLogVoltage({
      required List<List<ValuePair>> dateValueCollectionOfLog,
    }) {
      LineSeries voltageLineSeries = LineSeries(
        name: '24V',
        dataList: dateValueCollectionOfLog[3],
        color: Theme.of(context).colorScheme.primary,
        minYAxisValue: 0.0,
        maxYAxisValue: 40.0,
      );
      LineSeries voltageRippleLineSeries = LineSeries(
        name: '24V Ripple (${CustomStyle.milliVolt})',
        dataList: dateValueCollectionOfLog[4],
        color: const Color(0xff249689),
        minYAxisValue: 0.0,
        maxYAxisValue: 400.0,
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
      List<List<ValuePair>> emptyDateValueCollection = [
        [],
        [],
        [],
        [],
        [],
      ];
      String intValue = Random().nextInt(100).toString();
      List<LineSeries> log1Data = [];
      List<LineSeries> logVoltage = [];
      if (dateValueCollectionOfLog.isEmpty) {
        log1Data = getChartDataOfLog1(
            dateValueCollectionOfLog: emptyDateValueCollection);
        logVoltage = getChartDataOfLogVoltage(
            dateValueCollectionOfLog: emptyDateValueCollection);
      } else {
        log1Data = getChartDataOfLog1(
            dateValueCollectionOfLog: dateValueCollectionOfLog);
        logVoltage = getChartDataOfLogVoltage(
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

    Widget buildEmptyChartView() {
      List<List<ValuePair>> emptyDateValueCollection = [
        [],
        [],
        [],
        [],
        [],
      ];
      List<LineSeries> log1Data = getChartDataOfLog1(
          dateValueCollectionOfLog: emptyDateValueCollection);
      List<LineSeries> logVoltage = getChartDataOfLogVoltage(
          dateValueCollectionOfLog: emptyDateValueCollection);

      return SingleChildScrollView(
        // 設定 key, 讓 chart 可以 rebuild 並繪製空的資料
        // 如果沒有設定 key, flutter widget tree 會認為不需要rebuild chart
        key: const Key('ChartForm_Empty_Chart'),
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
      );
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadingStatus == FormStatus.requestInProgress) {
          return Stack(
            alignment: Alignment.center,
            children: [
              buildLoadingFormWithProgressiveChartView(
                  state.dateValueCollectionOfLog),
            ],
          );
        } else if (state.loadingStatus == FormStatus.requestSuccess) {
          if (state.eventLoadingStatus.isNone) {
            context.read<HomeBloc>().add(const EventRequested());
            return Stack(
              alignment: Alignment.center,
              children: [
                buildLoadingFormWithProgressiveChartView(
                    state.dateValueCollectionOfLog),
              ],
            );
          } else if (state.eventLoadingStatus.isRequestInProgress) {
            return Stack(
              alignment: Alignment.center,
              children: [
                buildLoadingFormWithProgressiveChartView(
                    state.dateValueCollectionOfLog),
              ],
            );
          } else if (state.loadingStatus.isRequestFailure) {
            return buildEmptyChartView();
          } else {
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
                                state.dateValueCollectionOfLog),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      buildChart(
                        getChartDataOfLogVoltage(
                            dateValueCollectionOfLog:
                                state.dateValueCollectionOfLog),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          return buildEmptyChartView();
        }
      },
    );
  }
}

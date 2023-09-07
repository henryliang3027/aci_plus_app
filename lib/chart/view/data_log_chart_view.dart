import 'dart:math';

import 'package:dsim_app/chart/view/full_screen_chart_form.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DataLogChartView extends StatelessWidget {
  const DataLogChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LogChartView();
  }
}

class _LogChartView extends StatelessWidget {
  const _LogChartView({super.key});

  @override
  Widget build(BuildContext context) {
    List<LineSeries> getChartDataOfLog1({
      required List<List<ValuePair>> dateValueCollectionOfLog,
    }) {
      LineSeries temperatureLineSeries = LineSeries(
        name: 'Temperature',
        dataList: [],
        color: Theme.of(context).colorScheme.primary,
        minYAxisValue: -30.0,
        maxYAxisValue: 100.0,
      );
      LineSeries rfOutputLowPilotLineSeries = const LineSeries(
        name: 'RF Output Low Pilot',
        dataList: [],
        color: Color(0xffff5963),
        minYAxisValue: 0.0,
        maxYAxisValue: 300.0,
      );
      LineSeries rfOutputHighPilotLineSeries = const LineSeries(
        name: 'RF Output High Pilot',
        dataList: [],
        color: Color(0xff249689),
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
      LineSeries temperatureLineSeries = LineSeries(
        name: 'Temperature',
        dataList: [],
        color: Theme.of(context).colorScheme.primary,
        minYAxisValue: -30.0,
        maxYAxisValue: 100.0,
      );
      LineSeries voltageLineSeries = const LineSeries(
        name: '24V',
        dataList: [],
        color: Color(0xffff5963),
        minYAxisValue: 0.0,
        maxYAxisValue: 40.0,
      );
      return [
        temperatureLineSeries,
        voltageLineSeries,
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
        logVoltage = getChartDataOfLog2(
            dateValueCollectionOfLog: emptyDateValueCollection);
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

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state.loadingStatus == FormStatus.requestInProgress) {
        return Stack(
          alignment: Alignment.center,
          children: [
            buildLoadingFormWithProgressiveChartView(
                state.dateValueCollectionOfLog),
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
      } else if (state.loadingStatus == FormStatus.requestSuccess) {
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
                      dateValueCollectionOfLog: state.dateValueCollectionOfLog),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                buildChart(
                  getChartDataOfLog2(
                      dateValueCollectionOfLog: state.dateValueCollectionOfLog),
                ),
              ],
            ),
          ),
        );
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
                      dateValueCollectionOfLog: state.dateValueCollectionOfLog),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                buildChart(
                  getChartDataOfLog2(
                      dateValueCollectionOfLog: state.dateValueCollectionOfLog),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}

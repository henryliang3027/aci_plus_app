import 'dart:math';

import 'package:dsim_app/chart/view/full_screen_chart_form.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OneGRFLevelChartView extends StatelessWidget {
  const OneGRFLevelChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ChartView();
  }
}

class _ChartView extends StatelessWidget {
  const _ChartView({super.key});

  @override
  Widget build(BuildContext context) {
    List<LineSeries> getChartDataOfRFLevel({
      required List<List<DateValuePair>> dateValueCollectionOfLog,
    }) {
      LineSeries rfLevelLineSeries = LineSeries(
        name: '1G RF Level',
        dataList: [],
        color: Theme.of(context).colorScheme.primary,
        minYAxisValue: -30.0,
        maxYAxisValue: 100.0,
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
        List<List<DateValuePair>> dateValueCollectionOfLog) {
      List<List<DateValuePair>> emptyDateValueCollection = [
        [],
        [],
        [],
        [],
        [],
      ];
      String intValue = Random().nextInt(100).toString();
      List<LineSeries> log1Data = [];
      if (dateValueCollectionOfLog.isEmpty) {
        log1Data = getChartDataOfRFLevel(
            dateValueCollectionOfLog: emptyDateValueCollection);
      } else {
        log1Data = getChartDataOfRFLevel(
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
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(70, 158, 158, 158),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
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
                child: CircularProgressIndicator(),
              ),
            )
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
                  getChartDataOfRFLevel(
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
                  getChartDataOfRFLevel(
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

import 'dart:io';

import 'package:aci_plus_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_chart/speed_chart.dart';

class FullScreenChartForm extends StatefulWidget {
  const FullScreenChartForm({
    super.key,
    required this.title,
    required this.lineSeriesCollection,
  });

  static Route route({
    required String title,
    required List<LineSeries> lineSeriesCollection,
  }) {
    return MaterialPageRoute(
      builder: (_) => FullScreenChartForm(
        title: title,
        lineSeriesCollection: lineSeriesCollection,
      ),
    );
  }

  final String title;
  final List<LineSeries> lineSeriesCollection;

  @override
  State<FullScreenChartForm> createState() => _FullScreenChartFormState();
}

class _FullScreenChartFormState extends State<FullScreenChartForm> {
  @override
  void initState() {
    super.initState();
    setFullScreenOrientation();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) {
        setPreferredOrientation();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SpeedLineChart(
                lineSeriesCollection: widget.lineSeriesCollection,
                showLegend: true,
                showMultipleYAxises: true,
                showScaleThumbs: winBeta >= 4
                    ? Platform.isWindows
                        ? true
                        : false
                    : false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

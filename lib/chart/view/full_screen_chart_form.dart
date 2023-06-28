import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return true;
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

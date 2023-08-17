import 'package:flutter/material.dart';

class OneGRFLevelChartView extends StatefulWidget {
  const OneGRFLevelChartView({super.key});

  @override
  State<OneGRFLevelChartView> createState() => _OneGRFLevelChartViewState();
}

class _OneGRFLevelChartViewState extends State<OneGRFLevelChartView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

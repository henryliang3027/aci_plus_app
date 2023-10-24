import 'package:dsim_app/chart/chart/data_log_chart_bloc/data_log_chart_bloc.dart';
import 'package:dsim_app/chart/view/data_log_chart_view.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataLogChartPage extends StatelessWidget {
  const DataLogChartPage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataLogChartBloc(
        dsimRepository: RepositoryProvider.of<DsimRepository>(context),
      ),
      child: DataLogChartView(
        pageController: pageController,
      ),
    );
  }
}

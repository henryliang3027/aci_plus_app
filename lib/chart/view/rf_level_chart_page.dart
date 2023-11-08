import 'package:aci_plus_app/chart/chart/rf_level_chart_bloc/rf_level_chart_bloc.dart';
import 'package:aci_plus_app/chart/view/rf_level_chart_view.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RFLevelChartPage extends StatelessWidget {
  const RFLevelChartPage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RFLevelChartBloc(
        dsimRepository: RepositoryProvider.of<DsimRepository>(context),
      ),
      child: RFLevelChartView(
        pageController: pageController,
      ),
    );
  }
}

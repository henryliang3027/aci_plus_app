import 'package:aci_plus_app/chart/chart/chart18_bloc/chart18_bloc.dart';
import 'package:aci_plus_app/chart/chart/data_log_chart_bloc/data_log_chart_bloc.dart';
import 'package:aci_plus_app/chart/chart/rf_level_chart_bloc/rf_level_chart_bloc.dart';
import 'package:aci_plus_app/chart/view/chart18_form.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chart18Page extends StatelessWidget {
  const Chart18Page({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => Chart18Bloc(
            dsimRepository: RepositoryProvider.of<DsimRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => DataLogChartBloc(
            dsimRepository: RepositoryProvider.of<DsimRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => RFLevelChartBloc(
            dsimRepository: RepositoryProvider.of<DsimRepository>(context),
          ),
        )
      ],
      child: Chart18Form(
        pageController: pageController,
      ),
    );
  }
}

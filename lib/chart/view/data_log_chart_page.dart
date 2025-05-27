import 'package:aci_plus_app/chart/bloc/data_log_chart/data_log_chart_bloc.dart';
import 'package:aci_plus_app/chart/view/data_log_chart_view.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
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
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
        aciDeviceRepository:
            RepositoryProvider.of<ACIDeviceRepository>(context),
      ),
      child: DataLogChartView(
        pageController: pageController,
      ),
    );
  }
}

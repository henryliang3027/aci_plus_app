import 'package:aci_plus_app/chart/bloc/chart/chart_bloc.dart';
import 'package:aci_plus_app/chart/view/chart_form.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartBloc(
          dsimRepository: RepositoryProvider.of<DsimRepository>(context)),
      child: ChartForm(
        pageController: pageController,
      ),
    );
  }
}

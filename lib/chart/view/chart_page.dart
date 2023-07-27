import 'package:dsim_app/chart/chart/chart_bloc/chart_bloc.dart';
import 'package:dsim_app/chart/view/chart_form.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartBloc(
          dsimRepository: RepositoryProvider.of<DsimRepository>(context)),
      child: const ChartForm(),
    );
  }
}

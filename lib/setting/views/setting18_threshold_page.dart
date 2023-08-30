import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/repositories/unit_repository.dart';
import 'package:dsim_app/setting/bloc/setting18_threshold/setting18_threshold_bloc.dart';
import 'package:dsim_app/setting/views/setting18_threshold_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ThresholdPage extends StatelessWidget {
  const Setting18ThresholdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18ThresholdBloc(
        dsimRepository: RepositoryProvider.of<DsimRepository>(context),
        unitRepository: RepositoryProvider.of<UnitRepository>(context),
      ),
      child: Setting18ThresholdView(),
    );
  }
}

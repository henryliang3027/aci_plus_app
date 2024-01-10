import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_threshold/setting18_threshold_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_threshold_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ThresholdPage extends StatelessWidget {
  const Setting18ThresholdPage({super.key});

  @override
  Widget build(BuildContext context) {
    // return Setting18ThresholdView();
    return BlocProvider(
      create: (context) => Setting18ThresholdBloc(
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
        unitRepository: RepositoryProvider.of<UnitRepository>(context),
      ),
      child: Setting18ThresholdView(),
    );
  }
}

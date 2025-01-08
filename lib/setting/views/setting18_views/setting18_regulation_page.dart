import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_regulation/setting18_regulation_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_regulation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18RegulationPage extends StatelessWidget {
  const Setting18RegulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18RegulationBloc(
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
      ),
      child: Setting18RegulationView(),
    );
  }
}

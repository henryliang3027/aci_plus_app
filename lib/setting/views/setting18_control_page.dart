import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_control/setting18_control_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_control_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ControlPage extends StatelessWidget {
  const Setting18ControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18ControlBloc(
          dsimRepository: RepositoryProvider.of<DsimRepository>(context)),
      child: Setting18ControlView(),
    );
  }
}

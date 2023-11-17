import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_control/setting18_ccor_node_control_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_control_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18CCorNodeControlPage extends StatelessWidget {
  const Setting18CCorNodeControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18CCorNodeControlBloc(
          dsimRepository: RepositoryProvider.of<DsimRepository>(context)),
      child: const Setting18CCorNodeControlView(),
    );
  }
}

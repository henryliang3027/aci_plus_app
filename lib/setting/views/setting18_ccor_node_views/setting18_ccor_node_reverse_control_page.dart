import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_reverse_control_dart/setting18_ccor_node_reverse_control_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_reverse_control_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18CCorNodeReverseControlPage extends StatelessWidget {
  const Setting18CCorNodeReverseControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18CCorNodeReverseControlBloc(
          amp18CCorNodeRepository:
              RepositoryProvider.of<Amp18CCorNodeRepository>(context)),
      child: const Seting18CCorNodeReverseControlView(),
    );
  }
}

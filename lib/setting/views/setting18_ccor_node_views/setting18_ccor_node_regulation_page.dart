import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_regulation/setting18_ccor_node_regulation_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_regulation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18CCorNodeRegulationPage extends StatelessWidget {
  const Setting18CCorNodeRegulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // return Setting18RegulationView();
    return BlocProvider(
      create: (context) => Setting18CCorNodeRegulationBloc(
        amp18CCorNodeRepository:
            RepositoryProvider.of<Amp18CCorNodeRepository>(context),
      ),
      child: Setting18CCorNodeRegulationView(),
    );
  }
}

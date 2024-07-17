import 'package:aci_plus_app/information/bloc/information18_ccor_node_preset/information18_ccor_node_preset_bloc.dart';
import 'package:aci_plus_app/information/views/information18_ccor_node_preset_form.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/node_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Information18CCorNodePresetPage extends StatelessWidget {
  const Information18CCorNodePresetPage({
    super.key,
    required this.nodeConfig,
  });

  final NodeConfig nodeConfig;

  static Route route({
    required NodeConfig nodeConfig,
  }) {
    return MaterialPageRoute(
      builder: (_) => Information18CCorNodePresetPage(
        nodeConfig: nodeConfig,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Information18CCorNodePresetBloc(
        amp18CCorNodeRepository:
            RepositoryProvider.of<Amp18CCorNodeRepository>(context),
        nodeConfig: nodeConfig,
      ),
      child: const Information18CCorNodePresetForm(),
    );
  }
}

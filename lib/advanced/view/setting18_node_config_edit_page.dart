import 'package:aci_plus_app/advanced/bloc/setting18_ccor_node_config_edit/setting18_ccor_node_config_edit_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_node_config_edit_form.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18NodeConfigEditPage extends StatelessWidget {
  const Setting18NodeConfigEditPage({
    super.key,
    this.nodeConfig,
    this.isEdit = false,
  });

  final NodeConfig? nodeConfig;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18CCorNodeConfigEditBloc(
        amp18CCorNodeRepository:
            RepositoryProvider.of<Amp18CCorNodeRepository>(context),
        configRepository: RepositoryProvider.of<ConfigRepository>(context),
        nodeConfig: nodeConfig,
      ),
      child: Setting18NodeConfigEditForm(
        isEdit: isEdit,
      ),
    );
  }
}

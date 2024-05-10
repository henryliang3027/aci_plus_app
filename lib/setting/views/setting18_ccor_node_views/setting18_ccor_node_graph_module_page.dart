import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_graph_module/setting18_ccor_node_graph_module_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_graph_module_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18CCorNodeGraphModulePage extends StatelessWidget {
  const Setting18CCorNodeGraphModulePage({
    super.key,
    required this.moduleName,
  });

  final String moduleName;

  // static Route<void> route(int moduleId) {
  //   return MaterialPageRoute(
  //       builder: (_) => Setting18GraphModulePage(moduleId: moduleId));
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18CCorNodeGraphModuleBloc(
        amp18CCorNodeRepository:
            RepositoryProvider.of<Amp18CCorNodeRepository>(context),
      ),
      child: Setting18CCorNodeGraphModuleForm(
        moduleName: moduleName,
      ),
    );
  }
}

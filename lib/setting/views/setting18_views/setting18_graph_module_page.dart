import 'package:aci_plus_app/setting/bloc/setting18_graph_module_bloc/setting18_graph_module_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_module_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18GraphModulePage extends StatelessWidget {
  const Setting18GraphModulePage({
    super.key,
    required this.moduleId,
  });

  final int moduleId;

  // static Route<void> route(int moduleId) {
  //   return MaterialPageRoute(
  //       builder: (_) => Setting18GraphModulePage(moduleId: moduleId));
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18GraphModuleBloc(
          amp18Repository: RepositoryProvider.of(context)),
      child: Setting18GraphModuleForm(
        moduleId: moduleId,
      ),
    );
  }
}

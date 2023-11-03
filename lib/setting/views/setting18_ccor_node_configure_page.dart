import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/setting/bloc/setting18_ccor_node_configure/setting18_ccor_node_configure_bloc.dart';
import 'package:dsim_app/setting/views/setting18_ccor_node_configure_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18CCorNodeConfigurePage extends StatelessWidget {
  const Setting18CCorNodeConfigurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18CCorNodeConfigureBloc(
          dsimRepository: RepositoryProvider.of<DsimRepository>(context)),
      child: Setting18CCorNodeConfigureView(),
    );
  }
}

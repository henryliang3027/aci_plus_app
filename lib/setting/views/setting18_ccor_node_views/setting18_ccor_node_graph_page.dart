import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_graph_view/setting18_ccor_node_graph_view_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_graph_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18CCorNodeGraphPage extends StatelessWidget {
  const Setting18CCorNodeGraphPage({
    super.key,
    required this.graphFilePath,
    this.editable = true,
  });

  static Route<void> route({
    required String graphFilePath,
    bool editable = true,
  }) {
    return MaterialPageRoute(
        builder: (_) => Setting18CCorNodeGraphPage(
              graphFilePath: graphFilePath,
              editable: editable,
            ));
  }

  final String graphFilePath;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18CCorNodeGraphViewBloc(
        amp18CCorNodeRepository:
            RepositoryProvider.of<Amp18CCorNodeRepository>(context),
        graphFilePath: graphFilePath,
        editable: editable,
      ),
      child: const Setting18CCorNodeGraphView(),
    );
  }
}

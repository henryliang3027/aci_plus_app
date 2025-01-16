import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_graph_view/setting18_graph_view_bloc.dart';

import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18GraphPage extends StatelessWidget {
  const Setting18GraphPage({
    super.key,
    required this.graphFilePath,
    this.editable = true,
  });

  static Route<void> route({
    required String graphFilePath,
    bool editable = true,
  }) {
    return MaterialPageRoute(
        builder: (_) => Setting18GraphPage(
              graphFilePath: graphFilePath,
              editable: editable,
            ));
  }

  final String graphFilePath;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18GraphViewBloc(
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
        graphFilePath: graphFilePath,
        editable: editable,
      ),
      child: const Setting18GraphView(),
    );
  }
}

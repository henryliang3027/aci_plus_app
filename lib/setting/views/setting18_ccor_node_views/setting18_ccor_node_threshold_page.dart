import 'package:aci_plus_app/repositories/dsim18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_threshold/setting18_ccor_node_threshold_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_threshold_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18CCorNodeThresholdPage extends StatelessWidget {
  const Setting18CCorNodeThresholdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18CCorNodeThresholdBloc(
        dsimRepository:
            RepositoryProvider.of<Dsim18CCorNodeRepository>(context),
        unitRepository: RepositoryProvider.of<UnitRepository>(context),
      ),
      child: Setting18CCorNodeThresholdView(),
    );
  }
}

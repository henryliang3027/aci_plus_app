import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_ccor_node_attribute/setting18_ccor_node_attribute_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_attribute_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18CCorNodeAttributePage extends StatelessWidget {
  const Setting18CCorNodeAttributePage({super.key});

  @override
  Widget build(BuildContext context) {
    // return Setting18AttributeView();
    return BlocProvider(
      create: (context) => Setting18CCorNodeAttributeBloc(
        amp18CCorNodeRepository:
            RepositoryProvider.of<Amp18CCorNodeRepository>(context),
        gpsRepository: RepositoryProvider.of<GPSRepository>(context),
      ),
      child: Setting18CCorNodeAttributeView(),
    );
  }
}

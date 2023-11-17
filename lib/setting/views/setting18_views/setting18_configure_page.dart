import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_configure/setting18_configure_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_configure_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ConfigurePage extends StatelessWidget {
  const Setting18ConfigurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18ConfigureBloc(
        dsimRepository: RepositoryProvider.of<DsimRepository>(context),
        gpsRepository: RepositoryProvider.of<GPSRepository>(context),
      ),
      child: Setting18ConfigureView(),
    );
  }
}

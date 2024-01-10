import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_bloc/setting18_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_configure/setting18_configure_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_control/setting18_control_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_threshold/setting18_threshold_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18Page extends StatelessWidget {
  const Setting18Page({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => Setting18Bloc(
            amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
          ),
        ),
        // BlocProvider(
        //   create: (context) => Setting18ConfigureBloc(
        //     amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
        //     gpsRepository: RepositoryProvider.of<GPSRepository>(context),
        //   ),
        // ),
        // BlocProvider(
        //   create: (context) => Setting18ThresholdBloc(
        //     amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
        //     unitRepository: RepositoryProvider.of<UnitRepository>(context),
        //   ),
        // ),
        // BlocProvider(
        //   create: (context) => Setting18ControlBloc(
        //     amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
        //   ),
        // ),
      ],
      child: Setting18Form(
        pageController: pageController,
      ),
    );
  }
}

import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/status/bloc/status18/status18_bloc.dart';
import 'package:aci_plus_app/status/views/status18_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Status18Page extends StatelessWidget {
  const Status18Page({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Status18Bloc(
        unitRepository: RepositoryProvider.of<UnitRepository>(context),
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
      ),
      child: Status18Form(
        pageController: pageController,
      ),
    );
  }
}

import 'package:aci_plus_app/chart/chart/chart18_bloc/chart18_bloc.dart';
import 'package:aci_plus_app/chart/view/chart18_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chart18Page extends StatelessWidget {
  const Chart18Page({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Chart18Bloc(
          amp18Repository: RepositoryProvider.of<Amp18Repository>(context)),
      child: Chart18Form(
        pageController: pageController,
      ),
    );
  }
}

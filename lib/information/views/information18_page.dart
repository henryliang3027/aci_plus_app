import 'package:aci_plus_app/information/bloc/information18/information18_bloc.dart';
import 'package:aci_plus_app/information/views/information18_form.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Information18Page extends StatelessWidget {
  const Information18Page({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Information18Bloc(
        configRepository: RepositoryProvider.of<ConfigRepository>(context),
      ),
      child: Information18Form(
        pageController: pageController,
      ),
    );
  }
}

import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting_bloc/setting_bloc.dart';
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
          create: (context) => SettingBloc(
            dsimRepository: RepositoryProvider.of<DsimRepository>(context),
          ),
        ),
      ],
      child: Setting18Form(
        pageController: pageController,
      ),
    );
  }
}

import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_tabbar/setting18_tabbar_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_tabbar_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18TabBarPage extends StatelessWidget {
  const Setting18TabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18TabBarBloc(
          amp18Repository: RepositoryProvider.of<Amp18Repository>(context)),
      child: const Setting18TabBarForm(),
    );
  }
}

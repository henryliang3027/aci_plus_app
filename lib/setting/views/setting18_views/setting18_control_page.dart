import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_control/setting18_control_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_control_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ControlPage extends StatelessWidget {
  const Setting18ControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    // return const Setting18ControlView();
    return BlocProvider(
      create: (context) => Setting18ControlBloc(
          amp18Repository: RepositoryProvider.of<Amp18Repository>(context)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        child: const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Setting18ControlTabBar(),
        ),
      ),
    );
  }
}

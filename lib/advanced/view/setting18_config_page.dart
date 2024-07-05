import 'package:aci_plus_app/advanced/bloc/setting18_config/setting18_config_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_form.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_tab_bar.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ConfigPage extends StatelessWidget {
  const Setting18ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18ConfigBloc(
        configRepository: RepositoryProvider.of<ConfigRepository>(context),
      ),
      child: Setting18ConfigForm(),

      // Container(
      //   decoration: BoxDecoration(
      //     color: Theme.of(context).colorScheme.onPrimary,
      //   ),
      //   child: const Padding(
      //     padding: EdgeInsets.only(top: 6),
      //     child: Setting18ConfigTabBar(),
      //   ),
      // ),
    );
  }
}

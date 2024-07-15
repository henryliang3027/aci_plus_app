import 'package:aci_plus_app/advanced/bloc/configs/setting18_trunk_config/setting18_trunk_config_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_trunk_config_form.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18TrunkConfigPage extends StatelessWidget {
  const Setting18TrunkConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18TrunkConfigBloc(
        configRepository: RepositoryProvider.of<ConfigRepository>(context),
      ),
      child: const Setting18TrunkConfigForm(),
    );
  }
}

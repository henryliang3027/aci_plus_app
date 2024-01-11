import 'package:aci_plus_app/advanced/view/setting18_config_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_config/setting18_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ConfigPage extends StatelessWidget {
  const Setting18ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18ConfigBloc(
        amp18repository: RepositoryProvider.of<Amp18Repository>(context),
      ),
      child: const Setting18ConfigForm(),
    );
  }
}

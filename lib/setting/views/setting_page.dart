import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:dsim_app/setting/views/setting_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingBloc(
        dsimRepository: RepositoryProvider.of<DsimRepository>(context),
      ),
      child: const SettingForm(),
    );
  }
}

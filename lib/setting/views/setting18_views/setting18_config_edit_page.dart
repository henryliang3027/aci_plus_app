import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_config_edit/setting18_config_edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ConfigEditPage extends StatelessWidget {
  const Setting18ConfigEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18ConfigEditBloc(
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
      ),
      child: const Setting18ConfigEditPage(),
    );
  }
}

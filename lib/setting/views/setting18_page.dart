import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/setting/bloc/setting18_list_view_bloc/setting18_list_view_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:dsim_app/setting/views/setting18_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18Page extends StatelessWidget {
  const Setting18Page({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingBloc(
            dsimRepository: RepositoryProvider.of<DsimRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => Setting18ListViewBloc(
            dsimRepository: RepositoryProvider.of<DsimRepository>(context),
          ),
        ),
      ],
      child: const Setting18Form(),
    );
  }
}

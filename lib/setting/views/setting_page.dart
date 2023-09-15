import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_graph_view_bloc/setting_graph_view_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_list_view_bloc/setting_list_view_bloc.dart';
import 'package:dsim_app/setting/views/setting_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({
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
        BlocProvider(
          create: (context) => SettingGraphViewBloc(
            dsimRepository: RepositoryProvider.of<DsimRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => SettingListViewBloc(
            dsimRepository: RepositoryProvider.of<DsimRepository>(context),
          ),
        )
      ],
      child: SettingForm(
        pageController: pageController,
      ),
    );
  }
}

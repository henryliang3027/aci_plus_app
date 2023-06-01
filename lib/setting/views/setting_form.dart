import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:dsim_app/setting/views/setting_graph_view.dart';
import 'package:dsim_app/setting/views/setting_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingForm extends StatelessWidget {
  SettingForm({super.key});

  final TextEditingController _locationTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).setting),
        centerTitle: true,
        actions: const [
          _ViewAction(),
        ],
      ),
      body: const _ViewLayout(),
    );
  }
}

class _ViewLayout extends StatelessWidget {
  const _ViewLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(builder: (context, state) {
      return state.isGraphType ? SettingGraphView() : SettingListView();
    });
  }
}

class _ViewAction extends StatelessWidget {
  const _ViewAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(builder: (context, state) {
      return state.isGraphType
          ? IconButton(
              onPressed: () {
                context.read<SettingBloc>().add(const ListViewToggled());
              },
              icon: const Icon(
                Icons.grain_sharp,
              ),
            )
          : IconButton(
              onPressed: () {
                context.read<SettingBloc>().add(const GraphViewToggled());
              },
              icon: const Icon(
                Icons.list_outlined,
              ));
    });
  }
}

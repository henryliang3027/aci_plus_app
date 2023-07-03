import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/pilot_channel.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:dsim_app/setting/views/setting_graph_view.dart';
import 'package:dsim_app/setting/views/setting_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingForm extends StatelessWidget {
  const SettingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).setting),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        actions: const [
          _ViewAction(),
        ],
      ),
      body: _ViewLayout(),
      // Center(
      //   child: Icon(
      //     Icons.settings,
      //   ),
      // ),
    );
  }
}

class _ViewLayout extends StatelessWidget {
  _ViewLayout({super.key});

  final TextEditingController locationTextEditingController =
      TextEditingController();

  final TextEditingController userPilotTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> _showInProgressDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text(
              // AppLocalizations.of(context)!.dialogTitle_settingUp,
              'Setting',
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              CircularProgressIndicator(),
            ],
          );
        },
      );
    }

    Future<void> _showSuccessDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Success',
              style: TextStyle(
                color: CustomStyle.customGreen,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(msg),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await _showInProgressDialog();
        } else if (state.submissionStatus.isSubmissionSuccess) {
          Navigator.of(context).pop();
          _showSuccessDialog('success');
        } else if (state.isInitialize) {
          locationTextEditingController.text = state.location.value;

          userPilotTextEditingController.text =
              PilotChannel.channelCode[state.pilotCode] ?? '';
        }
      },
      child: Builder(
        builder: (context) {
          final homeState = context.watch<HomeBloc>().state;
          final settingState = context.watch<SettingBloc>().state;
          if (homeState.settingParametersLoading.isRequestSuccess) {
            if (settingState.isInitialize) {
              context.read<SettingBloc>().add(const Initialized());
            }
          }

          return settingState.isGraphType
              ? SettingGraphView()
              : SettingListView(
                  locationTextEditionController: locationTextEditingController,
                  userPilotTextEditingController:
                      userPilotTextEditingController,
                );
        },
      ),
    );
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

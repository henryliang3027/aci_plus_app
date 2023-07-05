import 'package:dsim_app/core/command.dart';
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

  final TextEditingController userPilot2TextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> showInProgressDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).dialogTitleProcessing,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: const <Widget>[
              CircularProgressIndicator(),
            ],
          );
        },
      );
    }

    Future<void> showResultDialog(List<Row> messageRows) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).dialogTitleSettingResult,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: messageRows,
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

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context).dialogMaessageSettingSuccessful
          : AppLocalizations.of(context).dialogMaessageSettingFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.location.name) {
        return AppLocalizations.of(context).dialogMaessageLocationSetting;
      } else if (item == DataKey.tgcCableLength.name) {
        return AppLocalizations.of(context).dialogMaessageTGCCableLengthSetting;
      } else if (item == DataKey.logInterval.name) {
        return AppLocalizations.of(context).dialogMaessageLogIntervalSetting;
      } else if (item == DataKey.dsimMode.name) {
        return AppLocalizations.of(context).dialogMaessageWorkingModeSetting;
      } else {
        return '';
      }
    }

    Color getResultValueColor(String resultValue) {
      return resultValue == 'true' ? Colors.green : Colors.red;
    }

    List<Row> getMessageRows(List<String> settingResultList) {
      List<Row> rows = [];
      for (String settingResult in settingResultList) {
        String item = settingResult.split(',')[0];
        String value = settingResult.split(',')[1];
        Color valueColor = getResultValueColor(value);

        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatResultItem(item),
              style: TextStyle(fontSize: 16),
            ),
            Text(
              formatResultValue(value),
              style: TextStyle(
                fontSize: 16,
                color: valueColor,
              ),
            )
          ],
        ));
      }
      return rows;
    }

    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await showInProgressDialog();
        } else if (state.submissionStatus.isSubmissionSuccess) {
          Navigator.of(context).pop();
          List<Row> rows = getMessageRows(state.settingResult);
          showResultDialog(rows);
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
            return settingState.isGraphType
                ? SettingGraphView()
                : SettingListView(
                    locationTextEditionController:
                        locationTextEditingController,
                    userPilotTextEditingController:
                        userPilotTextEditingController,
                    userPilot2TextEditingController:
                        userPilot2TextEditingController,
                  );
          } else if (homeState.settingParametersLoading.isRequestFailure) {
            return Expanded(
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                color: Colors.white,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      size: 200,
                      color: Color(0xffffc107),
                    ),
                    Text(
                      'Load Setting failed',
                    ),
                    SizedBox(height: 40.0),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
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
                Icons.list_outlined,
              ),
            )
          : IconButton(
              onPressed: () {
                context.read<SettingBloc>().add(const GraphViewToggled());
              },
              icon: const Icon(
                Icons.grain_sharp,
              ));
    });
  }
}

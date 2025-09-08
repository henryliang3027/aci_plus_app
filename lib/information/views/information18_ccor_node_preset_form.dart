import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/information/bloc/information18_ccor_node_preset/information18_ccor_node_preset_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Information18CCorNodePresetForm extends StatelessWidget {
  const Information18CCorNodePresetForm({super.key});

  @override
  Widget build(BuildContext context) {
    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.forwardMode.name) {
        return AppLocalizations.of(context)!.dialogMessageForwardModeSetting;
      } else if (item == DataKey.forwardConfig.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardConfigModeSetting;
      } else if (item == DataKey.splitOption.name) {
        return AppLocalizations.of(context)!.dialogMessageSplitOptionSetting;
      } else {
        return '';
      }
    }

    Color getResultValueColor(String resultValue) {
      return resultValue == 'true' ? Colors.green : Colors.red;
    }

    List<Widget> getMessageRows(List<String> settingResultList) {
      List<Widget> rows = [];
      for (String settingResult in settingResultList) {
        String item = settingResult.split(',')[0];
        String value = settingResult.split(',')[1];
        Color valueColor = getResultValueColor(value);

        rows.add(Padding(
          padding: const EdgeInsets.only(
            bottom: 14.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  formatResultItem(item),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Text(
                formatResultValue(value),
                style: TextStyle(
                  fontSize: CustomStyle.sizeL,
                  color: valueColor,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ));
      }
      return rows;
    }

    return BlocListener<Information18CCorNodePresetBloc,
        Information18CCorNodePresetState>(
      listener: (context, state) async {
        if (state.settingStatus.isSubmissionInProgress) {
          await showInProgressDialog(context);
        } else if (state.settingStatus.isSubmissionSuccess) {
          Navigator.of(context).pop();
          List<Widget> rows = getMessageRows(state.settingResult);
          showResultDialog(
            context: context,
            messageRows: rows,
          ).then((_) {
            Navigator.of(context).pop();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: const _PartName(),
          centerTitle: true,
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              _ForwardMode(),
              _ForwardConfig(),
              // _SplitOption(),
              SizedBox(
                height: 200.0,
              ),
            ],
          ),
        ),
        floatingActionButton: const _ActionButton(),
      ),
    );
  }
}

class _PartName extends StatelessWidget {
  const _PartName();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18CCorNodePresetBloc,
        Information18CCorNodePresetState>(
      builder: (context, state) {
        return Text(
          state.nodeConfig.name,
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18CCorNodePresetBloc,
        Information18CCorNodePresetState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              shape: const CircleBorder(
                side: BorderSide.none,
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withAlpha(200),
              child: Icon(
                CustomIcons.cancel,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            FloatingActionButton(
              shape: const CircleBorder(
                side: BorderSide.none,
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withAlpha(200),
              onPressed: () async {
                bool shouldSubmit = false;

                if (kDebugMode) {
                  // In debug mode, we always submit
                  shouldSubmit = true;
                } else {
                  // In release mode, show the confirmation dialog
                  bool? isMatch =
                      await showConfirmInputDialog(context: context);
                  if (context.mounted) {
                    shouldSubmit = isMatch ?? false;
                  }
                }

                if (shouldSubmit) {
                  handleUpdateAction(
                    context: context,
                    targetBloc: context.read<Information18CCorNodePresetBloc>(),
                    action: () {
                      context
                          .read<Information18CCorNodePresetBloc>()
                          .add(const ConfigExecuted());
                    },
                    waitForState: (state) {
                      Information18CCorNodePresetState
                          information18CCorNodePresetState =
                          state as Information18CCorNodePresetState;

                      return information18CCorNodePresetState
                          .settingStatus.isSubmissionSuccess;
                    },
                  );
                }
              },
              child: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget buildCard({
  required BuildContext context,
  required String title,
  required String content,
  double contentFontSize = CustomStyle.size4XL,
}) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: CustomStyle.sizeL,
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Text(
            content,
            style: TextStyle(
              fontSize: contentFontSize,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ForwardMode extends StatelessWidget {
  const _ForwardMode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18CCorNodePresetBloc,
        Information18CCorNodePresetState>(
      buildWhen: (previous, current) =>
          previous.nodeConfig.forwardMode != current.nodeConfig.forwardMode,
      builder: (context, state) {
        return buildCard(
          context: context,
          title: AppLocalizations.of(context)!.forwardMode,
          content: '${forwardModeExportTexts[state.nodeConfig.forwardMode]}',
        );
      },
    );
  }
}

class _ForwardConfig extends StatelessWidget {
  const _ForwardConfig();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18CCorNodePresetBloc,
        Information18CCorNodePresetState>(
      buildWhen: (previous, current) =>
          previous.nodeConfig.forwardConfig != current.nodeConfig.forwardConfig,
      builder: (context, state) {
        return buildCard(
          context: context,
          title: AppLocalizations.of(context)!.forwardConfigMode,
          content:
              '${forwardConfigExportTexts[state.nodeConfig.forwardConfig]}',
        );
      },
    );
  }
}

// class _SplitOption extends StatelessWidget {
//   const _SplitOption();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Information18CCorNodePresetBloc,
//         Information18CCorNodePresetState>(
//       buildWhen: (previous, current) =>
//           previous.nodeConfig.splitOption != current.nodeConfig.splitOption,
//       builder: (context, state) {
//         return buildCard(
//           context: context,
//           title: AppLocalizations.of(context)!.splitOption,
//           content:
//               '${splitBaseLine[state.nodeConfig.splitOption]!.$1}/${splitBaseLine[state.nodeConfig.splitOption]!.$2} ${CustomStyle.mHz}',
//         );
//       },
//     );
//   }
// }

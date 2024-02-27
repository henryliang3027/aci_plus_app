import 'package:aci_plus_app/advanced/bloc/setting18_config_edit/setting18_config_edit_bloc.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/information/bloc/information18_preset_bloc/information18_preset_bloc.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_wisgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Information18PresetForm extends StatefulWidget {
  const Information18PresetForm({
    super.key,
  });

  @override
  State<Information18PresetForm> createState() =>
      _Information18PresetFormState();
}

class _Information18PresetFormState extends State<Information18PresetForm> {
  late final TextEditingController nameTextEditingController;
  late final TextEditingController
      firstChannelLoadingFrequencyTextEditingController;
  late final TextEditingController
      firstChannelLoadingLevelTextEditingController;
  late final TextEditingController
      lastChannelLoadingFrequencyTextEditingController;
  late final TextEditingController lastChannelLoadingLevelTextEditingController;

  @override
  void initState() {
    nameTextEditingController = TextEditingController();
    firstChannelLoadingFrequencyTextEditingController = TextEditingController();
    firstChannelLoadingLevelTextEditingController = TextEditingController();
    lastChannelLoadingFrequencyTextEditingController = TextEditingController();
    lastChannelLoadingLevelTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.read<HomeBloc>().state;
    String currentDetectedSplitOption =
        homeState.characteristicData[DataKey.currentDetectedSplitOption] ?? '0';
    String partId = homeState.characteristicData[DataKey.partId] ?? '';

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.splitOption.name) {
        return AppLocalizations.of(context)!.dialogMessageSplitOptionSetting;
      } else if (item == DataKey.pilotFrequencyMode.name) {
        return AppLocalizations.of(context)!
            .dialogMessagePilotFrequencyModeSetting;
      } else if (item == DataKey.firstChannelLoadingFrequency.name) {
        return AppLocalizations.of(context)!
            .dialogMessageFirstChannelLoadingFrequencySetting;
      } else if (item == DataKey.firstChannelLoadingLevel.name) {
        return AppLocalizations.of(context)!
            .dialogMessageFirstChannelLoadingLevelSetting;
      } else if (item == DataKey.lastChannelLoadingFrequency.name) {
        return AppLocalizations.of(context)!
            .dialogMessageLastChannelLoadingFrequencySetting;
      } else if (item == DataKey.lastChannelLoadingLevel.name) {
        return AppLocalizations.of(context)!
            .dialogMessageLastChannelLoadingLevelSetting;
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
              Expanded(
                child: Text(
                  formatResultValue(value),
                  style: TextStyle(
                    fontSize: CustomStyle.sizeL,
                    color: valueColor,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ));
      }
      return rows;
    }

    return BlocListener<Information18PresetBloc, Information18PresetState>(
      listener: (context, state) async {
        if (state.settingStatus.isSubmissionInProgress) {
          await showInProgressDialog(context);
        } else if (state.settingStatus.isSubmissionSuccess) {
          Navigator.of(context).pop();
          List<Widget> rows = getMessageRows(state.settingResult);
          showResultDialog(
            context: context,
            messageRows: rows,
          );
        }

        if (state.isInitialize) {
          Config config = state.config;
          nameTextEditingController.text = config.name;
          firstChannelLoadingFrequencyTextEditingController.text =
              config.firstChannelLoadingFrequency;
          firstChannelLoadingLevelTextEditingController.text =
              config.firstChannelLoadingLevel;
          lastChannelLoadingFrequencyTextEditingController.text =
              config.lastChannelLoadingFrequency;
          lastChannelLoadingLevelTextEditingController.text =
              config.lastChannelLoadingLevel;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: _PartName(
              nameTextEditingController: nameTextEditingController,
            ),
          ),
          // _QRCodeCard(
          //   isShortcut: widget.isShortcut,
          // ),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                child: Column(
                  children: [
                    const _SplitOption(),
                    _FirstChannelLoading(
                      firstChannelLoadingFrequencyTextEditingController:
                          firstChannelLoadingFrequencyTextEditingController,
                      firstChannelLoadingLevelTextEditingController:
                          firstChannelLoadingLevelTextEditingController,
                      currentDetectedSplitOption: currentDetectedSplitOption,
                    ),
                    _LastChannelLoading(
                      lastChannelLoadingFrequencyTextEditingController:
                          lastChannelLoadingFrequencyTextEditingController,
                      lastChannelLoadingLevelTextEditingController:
                          lastChannelLoadingLevelTextEditingController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // const _ActionTool(),
                    const _ActionButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartName extends StatelessWidget {
  const _PartName({
    super.key,
    required this.nameTextEditingController,
  });

  final TextEditingController nameTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      builder: (context, state) {
        return Theme(
          data: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Theme.of(context).colorScheme.onPrimary,
              selectionColor: Color.fromARGB(128, 255, 255, 255),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 140.0,
            ),
            child: TextField(
              controller: nameTextEditingController,
              key: const Key('Information18PresetForm_nameInput_textField'),
              style: TextStyle(
                fontSize: CustomStyle.sizeXL,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              textInputAction: TextInputAction.done,
              onChanged: null,
              textAlign: TextAlign.center,
              maxLength: 10,
              decoration: InputDecoration(
                // label: Text(AppLocalizations.of(context)!.name),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2.0,
                      color: Theme.of(context).colorScheme.onPrimary),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),

                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                contentPadding: const EdgeInsets.fromLTRB(4.0, 8.0, 0.0, 8.0),
                isDense: true,
                filled: true,
                fillColor: Theme.of(context).colorScheme.primary,
                counterText: '',
                errorMaxLines: 2,
                errorStyle: const TextStyle(
                  fontSize: CustomStyle.sizeS,
                ),
                // errorText: editMode1 ? errorText1 : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget getCancelButton() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 20.0,
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            AppLocalizations.of(context)!.dialogMessageCancel,
          ),
        ),
      );
    }

    Widget getExecuteButton() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: ElevatedButton(
          onPressed: () async {
            if (kDebugMode) {
              context
                  .read<Information18PresetBloc>()
                  .add(const ConfigExecuted());
            } else {
              bool? isMatch = await showConfirmInputDialog(context: context);

              if (context.mounted) {
                if (isMatch != null) {
                  if (isMatch) {
                    context
                        .read<Information18PresetBloc>()
                        .add(const ConfigExecuted());
                  }
                }
              }
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 20.0,
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            AppLocalizations.of(context)!.dialogMessageExecute,
          ),
        ),
      );
    }

    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            alignment: WrapAlignment.end,
            children: [
              getCancelButton(),
              getExecuteButton(),
            ],
          ),
        );
      },
    );
  }
}

class _SplitOption extends StatelessWidget {
  const _SplitOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      buildWhen: (previous, current) =>
          previous.config.splitOption != current.config.splitOption,
      builder: (context, state) {
        return splitOptionGridViewButton(
          context: context,
          editMode: true,
          splitOption: state.config.splitOption,
          onGridPressed: (index) {},
        );
      },
    );
  }
}

class _FirstChannelLoading extends StatelessWidget {
  const _FirstChannelLoading({
    super.key,
    required this.firstChannelLoadingFrequencyTextEditingController,
    required this.firstChannelLoadingLevelTextEditingController,
    required this.currentDetectedSplitOption,
  });

  final TextEditingController firstChannelLoadingFrequencyTextEditingController;
  final TextEditingController firstChannelLoadingLevelTextEditingController;
  final String currentDetectedSplitOption;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.startFrequency}:',
          editMode1: true,
          editMode2: true,
          reaOnly1: true,
          reaOnly2: true,
          textEditingControllerName1:
              'information18PresetForm_firstChannelLoadingFrequencyInput_textField',
          textEditingControllerName2:
              'information18PresetForm_firstChannelLoadingLevelInput_textField',
          textEditingController1:
              firstChannelLoadingFrequencyTextEditingController,
          textEditingController2: firstChannelLoadingLevelTextEditingController,
          onChanged1: (firstChannelLoadingFrequency) {},
          onChanged2: (firstChannelLoadingLevel) {},
        );
      },
    );
  }
}

class _LastChannelLoading extends StatelessWidget {
  const _LastChannelLoading({
    super.key,
    required this.lastChannelLoadingFrequencyTextEditingController,
    required this.lastChannelLoadingLevelTextEditingController,
  });

  final TextEditingController lastChannelLoadingFrequencyTextEditingController;
  final TextEditingController lastChannelLoadingLevelTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.stopFrequency}:',
          editMode1: true,
          editMode2: true,
          reaOnly1: true,
          reaOnly2: true,
          textEditingControllerName1:
              'information18PresetForm_lastChannelLoadingFrequencyInput_textField',
          textEditingControllerName2:
              'information18PresetForm_lastChannelLoadingLevelInput_textField',
          textEditingController1:
              lastChannelLoadingFrequencyTextEditingController,
          textEditingController2: lastChannelLoadingLevelTextEditingController,
          onChanged1: (lastChannelLoadingFrequency) {},
          onChanged2: (lastChannelLoadingLevel) {},
        );
      },
    );
  }
}

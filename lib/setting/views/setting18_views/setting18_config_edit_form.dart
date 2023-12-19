import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/setting/bloc/setting18_config_edit/setting18_config_edit_bloc.dart';
import 'package:aci_plus_app/setting/model/setting_wisgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ConfigEditForm extends StatelessWidget {
  Setting18ConfigEditForm({
    super.key,
    required this.selectedPartId,
  });

  final String selectedPartId;
  final TextEditingController
      firstChannelLoadingFrequencyTextEditingController =
      TextEditingController();
  final TextEditingController firstChannelLoadingLevelTextEditingController =
      TextEditingController();
  final TextEditingController lastChannelLoadingFrequencyTextEditingController =
      TextEditingController();
  final TextEditingController lastChannelLoadingLevelTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<Setting18ConfigEditBloc>().add(ConfigIntitialized(
          selectedPartId: selectedPartId,
        ));

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.firstChannelLoadingFrequency.name) {
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
                    fontSize: 16,
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

    return BlocListener<Setting18ConfigEditBloc, Setting18ConfigEditState>(
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
        } else if (state.saveStatus.isSubmissionSuccess) {
          showSuccessDialog(context);
        }

        if (state.isInitialize) {
          firstChannelLoadingFrequencyTextEditingController.text =
              state.firstChannelLoadingFrequency;
          firstChannelLoadingLevelTextEditingController.text =
              state.firstChannelLoadingLevel;
          lastChannelLoadingFrequencyTextEditingController.text =
              state.lastChannelLoadingFrequency;
          lastChannelLoadingLevelTextEditingController.text =
              state.lastChannelLoadingLevel;
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              18.0,
            ),
            child: Column(
              children: [
                _FirstChannelLoading(
                  firstChannelLoadingFrequencyTextEditingController:
                      firstChannelLoadingFrequencyTextEditingController,
                  firstChannelLoadingLevelTextEditingController:
                      firstChannelLoadingLevelTextEditingController,
                ),
                _LastChannelLoading(
                  lastChannelLoadingFrequencyTextEditingController:
                      lastChannelLoadingFrequencyTextEditingController,
                  lastChannelLoadingLevelTextEditingController:
                      lastChannelLoadingLevelTextEditingController,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FirstChannelLoading extends StatelessWidget {
  const _FirstChannelLoading({
    super.key,
    required this.firstChannelLoadingFrequencyTextEditingController,
    required this.firstChannelLoadingLevelTextEditingController,
  });

  final TextEditingController firstChannelLoadingFrequencyTextEditingController;
  final TextEditingController firstChannelLoadingLevelTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigEditBloc, Setting18ConfigEditState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.startFrequency}:',
          editMode1: true,
          editMode2: true,
          textEditingControllerName1:
              'setting18Form_firstChannelLoadingFrequencyInput_textField',
          textEditingControllerName2:
              'setting18Form_firstChannelLoadingLevelInput_textField',
          textEditingController1:
              firstChannelLoadingFrequencyTextEditingController,
          textEditingController2: firstChannelLoadingLevelTextEditingController,
          onChanged1: (firstChannelLoadingFrequency) {
            context.read<Setting18ConfigEditBloc>().add(
                FirstChannelLoadingFrequencyChanged(
                    firstChannelLoadingFrequency));
          },
          onChanged2: (firstChannelLoadingLevel) {
            context
                .read<Setting18ConfigEditBloc>()
                .add(FirstChannelLoadingLevelChanged(firstChannelLoadingLevel));
          },
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
    return BlocBuilder<Setting18ConfigEditBloc, Setting18ConfigEditState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.stopFrequency}:',
          editMode1: true,
          editMode2: true,
          textEditingControllerName1:
              'setting18Form_lastChannelLoadingFrequencyInput_textField',
          textEditingControllerName2:
              'setting18Form_lastChannelLoadingLevelInput_textField',
          textEditingController1:
              lastChannelLoadingFrequencyTextEditingController,
          textEditingController2: lastChannelLoadingLevelTextEditingController,
          onChanged1: (lastChannelLoadingFrequency) {
            context.read<Setting18ConfigEditBloc>().add(
                LastChannelLoadingFrequencyChanged(
                    lastChannelLoadingFrequency));
          },
          onChanged2: (lastChannelLoadingLevel) {
            context
                .read<Setting18ConfigEditBloc>()
                .add(LastChannelLoadingLevelChanged(lastChannelLoadingLevel));
          },
        );
      },
    );
  }
}

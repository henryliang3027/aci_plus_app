import 'package:aci_plus_app/advanced/bloc/setting18_config_edit/setting18_config_edit_bloc.dart';
import 'package:aci_plus_app/advanced/view/qr_code_generator_page.dart';
import 'package:aci_plus_app/advanced/view/qr_code_scanner.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_wisgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ConfigEditForm extends StatefulWidget {
  const Setting18ConfigEditForm({
    super.key,
    required this.isShortcut,
  });

  final bool isShortcut;

  @override
  State<Setting18ConfigEditForm> createState() =>
      _Setting18ConfigEditFormState();
}

class _Setting18ConfigEditFormState extends State<Setting18ConfigEditForm> {
  late final TextEditingController
      firstChannelLoadingFrequencyTextEditingController;
  late final TextEditingController
      firstChannelLoadingLevelTextEditingController;
  late final TextEditingController
      lastChannelLoadingFrequencyTextEditingController;
  late final TextEditingController lastChannelLoadingLevelTextEditingController;

  @override
  void initState() {
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
    int intCurrentDetectedSplitOption = int.parse(currentDetectedSplitOption);

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.pilotFrequencyMode.name) {
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

    Future<void> showGeneratedQRCodeDialog({
      required String encodedData,
    }) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;

          return Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: width * 0.01,
            ),
            child: QRCodeGeneratorPage(
              encodedData: encodedData,
            ),
          );
        },
      );
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
        } else if (state.encodeStaus.isRequestSuccess) {
          showGeneratedQRCodeDialog(
            encodedData: state.encodedData,
          );
        }

        if (state.isInitialize) {
          firstChannelLoadingFrequencyTextEditingController.text =
              state.firstChannelLoadingFrequency.value;
          firstChannelLoadingLevelTextEditingController.text =
              state.firstChannelLoadingLevel.value;
          lastChannelLoadingFrequencyTextEditingController.text =
              state.lastChannelLoadingFrequency.value;
          lastChannelLoadingLevelTextEditingController.text =
              state.lastChannelLoadingLevel.value;
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
            child: const _PartName(),
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
                    _FirstChannelLoading(
                      firstChannelLoadingFrequencyTextEditingController:
                          firstChannelLoadingFrequencyTextEditingController,
                      firstChannelLoadingLevelTextEditingController:
                          firstChannelLoadingLevelTextEditingController,
                      currentDetectedSplitOption: intCurrentDetectedSplitOption,
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
                    _ActionTool(
                      isShortcut: widget.isShortcut,
                    ),
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
  const _PartName({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigEditBloc, Setting18ConfigEditState>(
      builder: (context, state) {
        return Text(
          partIdMap[state.selectedPartId] ?? '',
          style: TextStyle(
            fontSize: CustomStyle.sizeXXL,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        );
      },
    );
  }
}

class _QRCodeCard extends StatelessWidget {
  const _QRCodeCard({
    super.key,
    required this.isShortcut,
  });

  final bool isShortcut;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigEditBloc, Setting18ConfigEditState>(
      builder: (context, state) {
        return !isShortcut
            ? Card(
                // elevation: 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 20.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'QR Code',
                          style: TextStyle(
                            fontSize: CustomStyle.sizeXL,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              iconSize: 30.0,
                              visualDensity: const VisualDensity(
                                  horizontal: -4.0, vertical: -4.0),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  QRCodeScanner.route(),
                                ).then((rawData) {
                                  if (rawData != null) {
                                    if (rawData.isNotEmpty) {
                                      context
                                          .read<Setting18ConfigEditBloc>()
                                          .add(QRCodeDataScanned(
                                              rawData: rawData));
                                    }
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.qr_code_scanner,
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            IconButton(
                              iconSize: 30.0,
                              visualDensity: const VisualDensity(
                                  horizontal: -4.0, vertical: -4.0),
                              onPressed: () {
                                context
                                    .read<Setting18ConfigEditBloc>()
                                    .add(const QRCodeDataGenerated());
                              },
                              icon: const Icon(
                                Icons.qr_code,
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
              )
            : Container();
      },
    );
  }
}

class _ActionTool extends StatelessWidget {
  const _ActionTool({
    super.key,
    required this.isShortcut,
  });

  final bool isShortcut;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        String partId = state.characteristicData[DataKey.partId] ?? '';
        if (state.loadingStatus.isRequestSuccess) {
          if (isShortcut) {
            return _ExecuteActionButton(
              partId: partId,
            );
          } else {
            return const _SavingActionButton();
          }
        } else {
          if (isShortcut) {
            return _ExecuteActionButton(
              partId: partId,
              isEnable: false,
            );
          } else {
            return const _SavingActionButton();
          }
        }
      },
    );
  }
}

class _ExecuteActionButton extends StatelessWidget {
  const _ExecuteActionButton({
    super.key,
    required this.partId,
    this.isEnable = true,
  });

  final String partId;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigEditBloc, Setting18ConfigEditState>(
      builder: (context, state) {
        bool isEnableExecete() {
          return isEnable &&
                  partId == state.selectedPartId &&
                  state.enableSubmission
              ? true
              : false;
        }

        return Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            alignment: WrapAlignment.end,
            children: [
              Padding(
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ElevatedButton(
                  onPressed: isEnableExecete()
                      ? () async {
                          if (kDebugMode) {
                            context
                                .read<Setting18ConfigEditBloc>()
                                .add(const ConfigSavedAndSubmitted());
                          } else {
                            bool? isMatch =
                                await showConfirmInputDialog(context: context);

                            if (context.mounted) {
                              if (isMatch != null) {
                                if (isMatch) {
                                  context
                                      .read<Setting18ConfigEditBloc>()
                                      .add(const ConfigSavedAndSubmitted());
                                }
                              }
                            }
                          }
                        }
                      : null,
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
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SavingActionButton extends StatelessWidget {
  const _SavingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigEditBloc, Setting18ConfigEditState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            alignment: WrapAlignment.end,
            children: [
              Padding(
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ElevatedButton(
                  onPressed: state.enableSubmission
                      ? () {
                          context
                              .read<Setting18ConfigEditBloc>()
                              .add(const ConfigSaved());
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 20.0,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.dialogMessageSave,
                  ),
                ),
              ),
            ],
          ),
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
  final int currentDetectedSplitOption;

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
            context
                .read<Setting18ConfigEditBloc>()
                .add(FirstChannelLoadingFrequencyChanged(
                  firstChannelLoadingFrequency: firstChannelLoadingFrequency,
                  currentDetectedSplitOption: currentDetectedSplitOption,
                ));
          },
          onChanged2: (firstChannelLoadingLevel) {
            context
                .read<Setting18ConfigEditBloc>()
                .add(FirstChannelLoadingLevelChanged(firstChannelLoadingLevel));
          },
          errorText1: !isValidFirstChannelLoadingFrequency(
            currentDetectedSplitOption: currentDetectedSplitOption,
            firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
          )
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          errorText2: state.firstChannelLoadingLevel.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
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
          errorText1: state.lastChannelLoadingFrequency.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
          errorText2: state.lastChannelLoadingLevel.isNotValid
              ? AppLocalizations.of(context)!.textFieldErrorMessage
              : null,
        );
      },
    );
  }
}

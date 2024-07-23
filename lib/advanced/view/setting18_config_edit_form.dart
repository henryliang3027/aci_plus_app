import 'package:aci_plus_app/advanced/bloc/setting18_config_edit/setting18_config_edit_bloc.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ConfigEditForm extends StatefulWidget {
  const Setting18ConfigEditForm({
    super.key,
    required this.isEdit,
  });

  final bool isEdit;

  @override
  State<Setting18ConfigEditForm> createState() =>
      _Setting18ConfigEditFormState();
}

class _Setting18ConfigEditFormState extends State<Setting18ConfigEditForm> {
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

    // Future<void> showGeneratedQRCodeDialog({
    //   required String encodedData,
    // }) async {
    //   return showDialog<void>(
    //     context: context,
    //     barrierDismissible: false, // user must tap button!

    //     builder: (BuildContext context) {
    //       var width = MediaQuery.of(context).size.width;
    //       // var height = MediaQuery.of(context).size.height;

    //       return Dialog(
    //         insetPadding: EdgeInsets.symmetric(
    //           horizontal: width * 0.01,
    //         ),
    //         child: QRCodeGeneratorPage(
    //           encodedData: encodedData,
    //         ),
    //       );
    //     },
    //   );
    // }

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
          Navigator.pop(context);
          showSuccessDialog(context);
        }
        // else if (state.encodeStaus.isRequestSuccess) {
        //   showGeneratedQRCodeDialog(
        //     encodedData: state.encodedData,
        //   );
        // }

        if (state.isInitialize) {
          nameTextEditingController.text = state.name.value;
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
                    _ActionButton(
                      partId: partId,
                      isEdit: widget.isEdit,
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
  const _PartName({
    required this.nameTextEditingController,
  });

  final TextEditingController nameTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigEditBloc, Setting18ConfigEditState>(
      builder: (context, state) {
        return Theme(
          data: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Theme.of(context).colorScheme.onPrimary,
              selectionColor: const Color(0x80ffffff),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                  right: 14.0,
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                TextField(
                  controller: nameTextEditingController,
                  key: const Key('setting18ConfigEditForm_nameInput_textField'),
                  style: TextStyle(
                    fontSize: CustomStyle.sizeXL,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: (name) {
                    context
                        .read<Setting18ConfigEditBloc>()
                        .add(NameChanged(name));
                  },
                  textAlign: TextAlign.center,
                  maxLength: 10,
                  decoration: InputDecoration(
                    // label: Text(AppLocalizations.of(context)!.name),
                    // suffixIcon: Icon(
                    //   Icons.edit,
                    //   color: Theme.of(context).colorScheme.onPrimary,
                    // ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: Theme.of(context).colorScheme.onPrimary),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                    ),

                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    contentPadding:
                        const EdgeInsets.fromLTRB(10.0, 8.0, 0.0, 8.0),
                    isDense: true,
                    // filled: true,
                    // fillColor: Theme.of(context).colorScheme.primary,
                    counterText: '',
                    errorMaxLines: 2,
                    errorStyle: const TextStyle(
                      fontSize: CustomStyle.sizeS,
                    ),
                    // errorText: editMode1 ? errorText1 : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class _QRCodeCard extends StatelessWidget {
//   const _QRCodeCard({
//     super.key,
//     required this.isShortcut,
//   });

//   final bool isShortcut;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18ConfigEditBloc, Setting18ConfigEditState>(
//       builder: (context, state) {
//         return !isShortcut
//             ? Card(
//                 // elevation: 0.0,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 14.0, horizontal: 20.0),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'QR Code',
//                           style: TextStyle(
//                             fontSize: CustomStyle.sizeXL,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               iconSize: 30.0,
//                               visualDensity: const VisualDensity(
//                                   horizontal: -4.0, vertical: -4.0),
//                               onPressed: () async {
//                                 Navigator.push(
//                                   context,
//                                   QRCodeScanner.route(),
//                                 ).then((rawData) {
//                                   if (rawData != null) {
//                                     if (rawData.isNotEmpty) {
//                                       context
//                                           .read<Setting18ConfigEditBloc>()
//                                           .add(QRCodeDataScanned(
//                                               rawData: rawData));
//                                     }
//                                   }
//                                 });
//                               },
//                               icon: const Icon(
//                                 Icons.qr_code_scanner,
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 10.0,
//                             ),
//                             IconButton(
//                               iconSize: 30.0,
//                               visualDensity: const VisualDensity(
//                                   horizontal: -4.0, vertical: -4.0),
//                               onPressed: () {
//                                 context
//                                     .read<Setting18ConfigEditBloc>()
//                                     .add(const QRCodeDataGenerated());
//                               },
//                               icon: const Icon(
//                                 Icons.qr_code,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ]),
//                 ),
//               )
//             : Container();
//       },
//     );
//   }
// }

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.partId,
    required this.isEdit,
  });

  final String partId;
  final bool isEdit;

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

    Widget getSavingButton({
      required bool enableSubmission,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: ElevatedButton(
          onPressed: enableSubmission
              ? () {
                  if (isEdit) {
                    context
                        .read<Setting18ConfigEditBloc>()
                        .add(const ConfigUpdated());
                  } else {
                    context
                        .read<Setting18ConfigEditBloc>()
                        .add(const ConfigAdded());
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
            AppLocalizations.of(context)!.dialogMessageSave,
          ),
        ),
      );
    }

    return BlocBuilder<Setting18ConfigEditBloc, Setting18ConfigEditState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            alignment: WrapAlignment.end,
            children: [
              getCancelButton(),
              getSavingButton(
                enableSubmission: state.enableSubmission,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SplitOption extends StatelessWidget {
  const _SplitOption();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigEditBloc, Setting18ConfigEditState>(
      buildWhen: (previous, current) =>
          previous.splitOption != current.splitOption,
      builder: (context, state) {
        return splitOptionGridViewButton(
          context: context,
          editMode: true,
          splitOption: state.splitOption,
          onGridPressed: (index) => context
              .read<Setting18ConfigEditBloc>()
              .add(SplitOptionChanged(splitOptionValues[index])),
        );
      },
    );
  }
}

class _FirstChannelLoading extends StatelessWidget {
  const _FirstChannelLoading({
    required this.firstChannelLoadingFrequencyTextEditingController,
    required this.firstChannelLoadingLevelTextEditingController,
    required this.currentDetectedSplitOption,
  });

  final TextEditingController firstChannelLoadingFrequencyTextEditingController;
  final TextEditingController firstChannelLoadingLevelTextEditingController;
  final String currentDetectedSplitOption;

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

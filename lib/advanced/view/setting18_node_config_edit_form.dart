import 'package:aci_plus_app/advanced/bloc/setting18_ccor_node_config_edit/setting18_ccor_node_config_edit_bloc.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18NodeConfigEditForm extends StatefulWidget {
  const Setting18NodeConfigEditForm({
    super.key,
    required this.isEdit,
  });

  final bool isEdit;

  @override
  State<Setting18NodeConfigEditForm> createState() =>
      _Setting18NodeConfigEditFormState();
}

class _Setting18NodeConfigEditFormState
    extends State<Setting18NodeConfigEditForm> {
  late final TextEditingController nameTextEditingController;

  @override
  void initState() {
    nameTextEditingController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context)!.dialogMessageSuccessful
          : AppLocalizations.of(context)!.dialogMessageFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.splitOption.name) {
        return AppLocalizations.of(context)!.dialogMessageSplitOptionSetting;
      } else if (item == DataKey.forwardMode.name) {
        return AppLocalizations.of(context)!.dialogMessageForwardModeSetting;
      } else if (item == DataKey.forwardConfig.name) {
        return AppLocalizations.of(context)!
            .dialogMessageForwardConfigModeSetting;
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

    return BlocListener<Setting18CCorNodeConfigEditBloc,
        Setting18CCorNodeConfigEditState>(
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
        if (state.isInitialize) {
          nameTextEditingController.text = state.name.value;
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
                    const _ForwardMode(),
                    const _ForwardConfig(),
                    const _SplitOption(),

                    const SizedBox(
                      height: 20,
                    ),
                    // const _ActionTool(),
                    _ActionButton(
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
    super.key,
    required this.nameTextEditingController,
  });

  final TextEditingController nameTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeConfigEditBloc,
        Setting18CCorNodeConfigEditState>(
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
                        .read<Setting18CCorNodeConfigEditBloc>()
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
    super.key,
    required this.isEdit,
  });

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
                        .read<Setting18CCorNodeConfigEditBloc>()
                        .add(const ConfigUpdated());
                  } else {
                    context
                        .read<Setting18CCorNodeConfigEditBloc>()
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

    return BlocBuilder<Setting18CCorNodeConfigEditBloc,
        Setting18CCorNodeConfigEditState>(
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

class _ForwardMode extends StatelessWidget {
  const _ForwardMode({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeConfigEditBloc,
        Setting18CCorNodeConfigEditState>(
      buildWhen: (previous, current) =>
          previous.forwardMode != current.forwardMode,
      builder: (context, state) {
        return configureGridViewButton(
          context: context,
          editMode: true,
          title: '${AppLocalizations.of(context)!.forwardMode}:',
          targetValue: state.forwardMode,
          texts: forwardModeTexts,
          values: forwardModeValues,
          onGridPressed: (index) => context
              .read<Setting18CCorNodeConfigEditBloc>()
              .add(ForwardModeChanged(forwardModeValues[index])),
        );
      },
    );
  }
}

class _ForwardConfig extends StatelessWidget {
  const _ForwardConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeConfigEditBloc,
        Setting18CCorNodeConfigEditState>(
      buildWhen: (previous, current) =>
          previous.forwardConfig != current.forwardConfig,
      builder: (context, state) {
        return configureGridViewButton(
          context: context,
          editMode: true,
          title: '${AppLocalizations.of(context)!.forwardConfigMode}:',
          targetValue: state.forwardConfig,
          texts: forwardConfigTexts,
          values: forwardConfigValues,
          onGridPressed: (index) => context
              .read<Setting18CCorNodeConfigEditBloc>()
              .add(ForwardConfigChanged(forwardConfigValues[index])),
        );
      },
    );
  }
}

class _SplitOption extends StatelessWidget {
  const _SplitOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18CCorNodeConfigEditBloc,
        Setting18CCorNodeConfigEditState>(
      buildWhen: (previous, current) =>
          previous.splitOption != current.splitOption,
      builder: (context, state) {
        return splitOptionGridViewButton(
          context: context,
          editMode: true,
          splitOption: state.splitOption,
          onGridPressed: (index) => context
              .read<Setting18CCorNodeConfigEditBloc>()
              .add(SplitOptionChanged(splitOptionValues[index])),
        );
      },
    );
  }
}

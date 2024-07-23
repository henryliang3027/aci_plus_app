import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/information/bloc/information18_ccor_node_preset/information18_ccor_node_preset_bloc.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Information18CCorNodePresetForm extends StatefulWidget {
  const Information18CCorNodePresetForm({
    super.key,
  });

  @override
  State<Information18CCorNodePresetForm> createState() =>
      _Information18CCorNodePresetFormState();
}

class _Information18CCorNodePresetFormState
    extends State<Information18CCorNodePresetForm> {
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

        if (state.isInitialize) {
          NodeConfig nodeConfig = state.nodeConfig;

          nameTextEditingController.text = nodeConfig.name;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: _PartName(
            nameTextEditingController: nameTextEditingController,
          ),
          centerTitle: true,
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              _ForwardMode(),
              _ForwardConfig(),
              _SplitOption(),
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
  const _PartName({
    required this.nameTextEditingController,
  });

  final TextEditingController nameTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18CCorNodePresetBloc,
        Information18CCorNodePresetState>(
      builder: (context, state) {
        return Text(
          state.nodeConfig.name,
        );
        // return Theme(
        //   data: ThemeData(
        //     textSelectionTheme: TextSelectionThemeData(
        //       cursorColor: Theme.of(context).colorScheme.onPrimary,
        //       selectionColor: const Color(0x80ffffff),
        //     ),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(
        //       horizontal: 0.0,
        //     ),
        //     child: Stack(
        //       alignment: AlignmentDirectional.center,
        //       children: [
        //         // Positioned(
        //         //   right: 14.0,
        //         //   child: Icon(
        //         //     Icons.edit,
        //         //     color: Theme.of(context).colorScheme.onPrimary,
        //         //   ),
        //         // ),
        //         TextField(
        //           controller: nameTextEditingController,
        //           key: const Key('Information18PresetForm_nameInput_textField'),
        //           style: TextStyle(
        //             fontSize: CustomStyle.sizeXL,
        //             color: Theme.of(context).colorScheme.onPrimary,
        //           ),
        //           textInputAction: TextInputAction.done,
        //           enabled: false,
        //           onChanged: null,
        //           textAlign: TextAlign.center,
        //           maxLength: 10,
        //           decoration: InputDecoration(
        //             focusedBorder: OutlineInputBorder(
        //               borderSide: BorderSide(
        //                 width: 2.0,
        //                 color: Theme.of(context).colorScheme.onPrimary,
        //               ),
        //               borderRadius:
        //                   const BorderRadius.all(Radius.circular(4.0)),
        //             ),
        //             enabledBorder: OutlineInputBorder(
        //               borderSide: BorderSide(
        //                 color: Theme.of(context).colorScheme.primary,
        //               ),
        //               borderRadius:
        //                   const BorderRadius.all(Radius.circular(4.0)),
        //             ),
        //             disabledBorder: const OutlineInputBorder(
        //               borderSide: BorderSide(
        //                 color: Colors.transparent,
        //               ),
        //               borderRadius: BorderRadius.all(Radius.circular(4.0)),
        //             ),

        //             border: const OutlineInputBorder(
        //               borderRadius: BorderRadius.all(Radius.circular(4.0)),
        //             ),
        //             // contentPadding:
        //             //     const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
        //             isDense: true,
        //             filled: true,
        //             fillColor: Theme.of(context).colorScheme.primary,
        //             counterText: '',
        //             errorMaxLines: 2,
        //             errorStyle: const TextStyle(
        //               fontSize: CustomStyle.sizeS,
        //             ),
        //             // errorText: editMode1 ? errorText1 : null,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton();

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
                if (kDebugMode) {
                  context
                      .read<Information18CCorNodePresetBloc>()
                      .add(const ConfigExecuted());
                } else {
                  bool? isMatch =
                      await showConfirmInputDialog(context: context);

                  if (context.mounted) {
                    if (isMatch != null) {
                      if (isMatch) {
                        context
                            .read<Information18CCorNodePresetBloc>()
                            .add(const ConfigExecuted());
                      }
                    }
                  }
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
    surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
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

class _SplitOption extends StatelessWidget {
  const _SplitOption();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18CCorNodePresetBloc,
        Information18CCorNodePresetState>(
      buildWhen: (previous, current) =>
          previous.nodeConfig.splitOption != current.nodeConfig.splitOption,
      builder: (context, state) {
        return buildCard(
          context: context,
          title: AppLocalizations.of(context)!.splitOption,
          content:
              '${splitBaseLine[state.nodeConfig.splitOption]!.$1}/${splitBaseLine[state.nodeConfig.splitOption]!.$2} ${CustomStyle.mHz}',
        );
      },
    );
  }
}

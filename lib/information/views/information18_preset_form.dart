import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/information/bloc/information18_preset_bloc/information18_preset_bloc.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/setting/model/confirm_input_dialog.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
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
      } else if (item == DataKey.agcMode.name) {
        return AppLocalizations.of(context)!.dialogMessageAGCModeSetting;
      } else if (item == DataKey.alcMode.name) {
        return AppLocalizations.of(context)!.dialogMessageALCModeSetting;
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
          ).then((_) {
            Navigator.of(context).pop();
          });
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
              _SplitOption(),
              _PilotFrequencyMode(),
              _StartFrequency(),
              _StartLevel(),
              _StopFrequency(),
              _StopLevel(),
              _FwdAGCMode(),
              _AutoLevelControl(),
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
    super.key,
    required this.nameTextEditingController,
  });

  final TextEditingController nameTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      builder: (context, state) {
        return Text(
          state.config.name,
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
                      .read<Information18PresetBloc>()
                      .add(const ConfigExecuted());
                } else {
                  bool? isMatch =
                      await showConfirmInputDialog(context: context);

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

class _SplitOption extends StatelessWidget {
  const _SplitOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      buildWhen: (previous, current) =>
          previous.config.splitOption != current.config.splitOption,
      builder: (context, state) {
        return buildCard(
          context: context,
          title: AppLocalizations.of(context)!.splitOption,
          content:
              '${splitBaseLine[state.config.splitOption]!.$1}/${splitBaseLine[state.config.splitOption]!.$2} ${CustomStyle.mHz}',
        );
      },
    );
  }
}

class _PilotFrequencyMode extends StatelessWidget {
  const _PilotFrequencyMode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      builder: (context, state) {
        return buildCard(
          context: context,
          title: AppLocalizations.of(context)!.pilotFrequencySelect,
          content:
              AppLocalizations.of(context)!.pilotFrequencyBandwidthSettings,
          contentFontSize: CustomStyle.size36,
        );
      },
    );
  }
}

class _StartFrequency extends StatelessWidget {
  const _StartFrequency({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      builder: (context, state) {
        return buildCard(
          context: context,
          title:
              '${AppLocalizations.of(context)!.startFrequency} (${CustomStyle.mHz})',
          content: state.config.firstChannelLoadingFrequency,
        );
      },
    );
  }
}

class _StartLevel extends StatelessWidget {
  const _StartLevel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      builder: (context, state) {
        return buildCard(
          context: context,
          title:
              '${AppLocalizations.of(context)!.startLevel} (${CustomStyle.dBmV})',
          content: state.config.firstChannelLoadingLevel,
        );
      },
    );
  }
}

class _StopFrequency extends StatelessWidget {
  const _StopFrequency({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      builder: (context, state) {
        return buildCard(
          context: context,
          title:
              '${AppLocalizations.of(context)!.stopFrequency} (${CustomStyle.mHz})',
          content: state.config.lastChannelLoadingFrequency,
        );
      },
    );
  }
}

class _StopLevel extends StatelessWidget {
  const _StopLevel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      builder: (context, state) {
        return buildCard(
          context: context,
          title:
              '${AppLocalizations.of(context)!.stopLevel} (${CustomStyle.dBmV})',
          content: state.config.lastChannelLoadingLevel,
        );
      },
    );
  }
}

class _FwdAGCMode extends StatelessWidget {
  const _FwdAGCMode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      builder: (context, state) {
        return buildCard(
          context: context,
          title: AppLocalizations.of(context)!.agcMode,
          content: AppLocalizations.of(context)!.on,
        );
      },
    );
  }
}

class _AutoLevelControl extends StatelessWidget {
  const _AutoLevelControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18PresetBloc, Information18PresetState>(
      builder: (context, state) {
        return buildCard(
          context: context,
          title: AppLocalizations.of(context)!.alcMode,
          content: AppLocalizations.of(context)!.on,
        );
      },
    );
  }
}

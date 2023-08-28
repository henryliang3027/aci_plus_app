import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_icons/custom_icons_icons.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/shared_preference_key.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_list_view_bloc/setting_list_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingListView extends StatelessWidget {
  SettingListView({super.key});

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
              Center(
                child: SizedBox(
                  width: CustomStyle.diameter,
                  height: CustomStyle.diameter,
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        },
      );
    }

    Future<void> showResultDialog(List<Widget> messageRows) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            titlePadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
            buttonPadding: const EdgeInsets.all(0.0),
            actionsPadding: const EdgeInsets.all(16.0),
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

    Future<void> showPilotSearchFailedDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).dialogTitleError,
              style: const TextStyle(
                color: CustomStyle.customRed,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    AppLocalizations.of(context).dialogMessagePilotSearchFailed,
                  ),
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

    String formatResultValue(String boolValue) {
      return boolValue == 'true'
          ? AppLocalizations.of(context).dialogMessageSettingSuccessful
          : AppLocalizations.of(context).dialogMessageSettingFailed;
    }

    String formatResultItem(String item) {
      if (item == DataKey.location.name) {
        return AppLocalizations.of(context).dialogMessageLocationSetting;
      } else if (item == DataKey.tgcCableLength.name) {
        return AppLocalizations.of(context).dialogMessageTGCCableLengthSetting;
      } else if (item == DataKey.logInterval.name) {
        return AppLocalizations.of(context).dialogMessageLogIntervalSetting;
      } else if (item == DataKey.workingMode.name) {
        return AppLocalizations.of(context).dialogMessageWorkingModeSetting;
      } else if (item == SharedPreferenceKey.pilotCode.name) {
        return AppLocalizations.of(context).dialogMessageSaveUserPilot;
      } else if (item == SharedPreferenceKey.pilot2Code.name) {
        return AppLocalizations.of(context).dialogMessageSaveUserPilot2;
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
            bottom: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatResultItem(item),
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                formatResultValue(value),
                style: TextStyle(
                  fontSize: 16,
                  color: valueColor,
                ),
              )
            ],
          ),
        ));
      }
      return rows;
    }

    return BlocListener<SettingListViewBloc, SettingListViewState>(
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionInProgress) {
          await showInProgressDialog();
        } else if (state.submissionStatus.isSubmissionSuccess) {
          Navigator.of(context).pop();
          List<Widget> rows = getMessageRows(state.settingResult);
          showResultDialog(rows);

          // 設定完成後不論成功或失敗都重新載入初始設定值
          // 這樣可以達到設定 tgc cable length 完成時, working mode 跟著更新為 tgc mode
          context.read<SettingListViewBloc>().add(const Initialized(true));
        } else if (state.isInitialize) {
          locationTextEditingController.text = state.location.value;
          userPilotTextEditingController.text = state.pilotCode.value;
          userPilot2TextEditingController.text = state.pilot2Code.value;
        } else if (state.pilotChannelStatus.isRequestFailure) {
          showPilotSearchFailedDialog();
        } else if (state.pilot2ChannelStatus.isRequestFailure) {
          showPilotSearchFailedDialog();
        }
      },
      child: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          SettingListViewState settingListViewState =
              context.read<SettingListViewBloc>().state;
          locationTextEditingController.text =
              settingListViewState.location.value;
          userPilotTextEditingController.text =
              settingListViewState.pilotCode.value;
          userPilot2TextEditingController.text =
              settingListViewState.pilot2Code.value;
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(
                    CustomStyle.sizeXL,
                  ),
                  child: Column(
                    children: [
                      _Location(
                        textEditingController: locationTextEditingController,
                      ),
                      const _TGCCabelLength(),
                      const _LogIntervalDropDownMenu(),
                      const _WorkingMode(),
                      _UserPilot(
                        textEditingController: userPilotTextEditingController,
                      ),
                      _UserPilot2(
                        textEditingController: userPilot2TextEditingController,
                      ),
                      const _AGCPrepAttenator(),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: const _SettingFloatingActionButton(),
          );
        },
      ),
    );
  }
}

class _SettingFloatingActionButton extends StatelessWidget {
  const _SettingFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    Widget getEditTools({
      required bool editMode,
      required bool enableSubmission,
    }) {
      return editMode
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
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
                    context
                        .read<SettingListViewBloc>()
                        .add(const EditModeDisabled());

                    // 重新載入初始設定值
                    context
                        .read<SettingListViewBloc>()
                        .add(const Initialized(true));
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                FloatingActionButton(
                  shape: const CircleBorder(
                    side: BorderSide.none,
                  ),
                  backgroundColor: enableSubmission
                      ? Theme.of(context).colorScheme.primary.withAlpha(200)
                      : Colors.grey.withAlpha(200),
                  onPressed: enableSubmission
                      ? () {
                          context
                              .read<SettingListViewBloc>()
                              .add(const SettingSubmitted());
                        }
                      : null,
                  child: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // FloatingActionButton(
                //   shape: const CircleBorder(
                //     side: BorderSide.none,
                //   ),
                //   backgroundColor: Colors.grey.withAlpha(200),
                //   child: Icon(
                //     Icons.grain_sharp,
                //     color: Theme.of(context).colorScheme.onPrimary,
                //   ),
                //   onPressed: () {
                //     context.read<SettingBloc>().add(const GraphViewToggled());
                //   },
                // ),
                // const SizedBox(
                //   height: 10.0,
                // ),
                FloatingActionButton(
                  shape: const CircleBorder(
                    side: BorderSide.none,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withAlpha(200),
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    context
                        .read<SettingListViewBloc>()
                        .add(const EditModeEnabled());
                  },
                ),
              ],
            );
    }

    bool getEditable(FormStatus loadingStatus) {
      if (loadingStatus.isRequestSuccess) {
        return true;
      } else if (loadingStatus.isRequestFailure) {
        return false;
      } else {
        return false;
      }
    }

    // 同時 watch homeState 和 settingListViewState的變化
    // homeState 失去藍芽連線時會變更為不可編輯
    // settingListViewState 管理編輯模式或是觀看模式
    return Builder(builder: (context) {
      final HomeState homeState = context.watch<HomeBloc>().state;
      final SettingListViewState settingListViewState =
          context.watch<SettingListViewBloc>().state;

      bool editable = getEditable(homeState.loadingStatus);
      return editable
          ? getEditTools(
              editMode: settingListViewState.editMode,
              enableSubmission: settingListViewState.enableSubmission,
            )
          : Container();
    });
  }
}

class _Location extends StatelessWidget {
  const _Location({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingListViewBloc, SettingListViewState>(
      builder: (context, state) {
        print('_Location: ${textEditingController.text}');
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: Text(
                  '${AppLocalizations.of(context).location}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextField(
                controller: textEditingController,
                key: const Key('settingForm_locationInput_textField'),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: state.editMode,
                textInputAction: TextInputAction.done,
                onChanged: (location) {
                  context
                      .read<SettingListViewBloc>()
                      .add(LocationChanged(location));
                },
                maxLength: 40,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TGCCabelLength extends StatelessWidget {
  const _TGCCabelLength({
    super.key,
  });

  final List<String> tgcCableLengthTexts = const [
    '9',
    '18',
    '27',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingListViewBloc, SettingListViewState>(
      buildWhen: (previous, current) =>
          previous.selectedTGCCableLength != current.selectedTGCCableLength ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: Text(
                  '${AppLocalizations.of(context).tgcCableLength}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    if (state.editMode) {
                      context.read<SettingListViewBloc>().add(
                          TGCCableLengthChanged(tgcCableLengthTexts[index]));
                    }
                  },
                  textStyle: const TextStyle(fontSize: 18.0),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),

                  selectedBorderColor: state.editMode
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .inversePrimary, // indigo border color
                  selectedColor: Theme.of(context)
                      .colorScheme
                      .onPrimary, // white text color

                  fillColor: state.editMode
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .inversePrimary, // selected
                  color:
                      Theme.of(context).colorScheme.secondary, // not selected
                  constraints: BoxConstraints.expand(
                      width: (constraints.maxWidth - 4) /
                          3), //number 2 is number of toggle buttons
                  isSelected: state.selectedTGCCableLength.values.toList(),
                  children: const <Widget>[
                    Text('9'),
                    Text('18'),
                    Text('27'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LogIntervalDropDownMenu extends StatelessWidget {
  const _LogIntervalDropDownMenu({super.key});

  final Map<String, int> types = const {
    '1 min.- 4 hours': 1,
    '2 min.- 8 hours': 2,
    '3 min.- 12 hours': 3,
    '5 min.- 21 hours': 5,
    '10 min.- 1 day': 10,
    '15 min.- 2 days': 15,
    '30 min.- 5 days': 30,
    '1 hr.- 10 days': 60,
    '2 hrs.- 20 days': 120,
    '3 hrs.- 30 days': 180,
    '4 hrs.- 40 days': 240,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingListViewBloc, SettingListViewState>(
        buildWhen: (previous, current) =>
            previous.logIntervalId != current.logIntervalId ||
            previous.editMode != current.editMode,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                  ),
                  child: Text(
                    '${AppLocalizations.of(context).logInterval}:',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<int?>(
                      buttonHeight: 40,
                      buttonDecoration: BoxDecoration(
                        border: Border.all(
                          color: state.editMode
                              ? Colors.grey.shade700
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.white,
                      ),
                      dropdownMaxHeight: 200,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value:
                          state.logIntervalId == 0 ? null : state.logIntervalId,
                      items: [
                        for (String k in types.keys)
                          DropdownMenuItem(
                            value: types[k],
                            child: Text(
                              k,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: CustomStyle.sizeXL,
                                fontWeight: FontWeight.normal,
                                color:
                                    state.editMode ? Colors.black : Colors.grey,
                              ),
                            ),
                          )
                      ],
                      onChanged: state.editMode
                          ? (int? value) {
                              if (value != null) {
                                context
                                    .read<SettingListViewBloc>()
                                    .add(LogIntervalChanged(value));
                              }
                            }
                          : null),
                ),
              ],
            ),
          );
        });
  }
}

class _WorkingMode extends StatelessWidget {
  const _WorkingMode({
    super.key,
  });

  final List<String> workingModeTexts = const [
    'MGC',
    'AGC',
    'TGC',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingListViewBloc, SettingListViewState>(
      buildWhen: (previous, current) =>
          previous.selectedWorkingMode != current.selectedWorkingMode ||
          previous.editMode != current.editMode,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: Text(
                  '${AppLocalizations.of(context).workingMode}:',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    if (state.editMode) {
                      context
                          .read<SettingListViewBloc>()
                          .add(WorkingModeChanged(workingModeTexts[index]));
                    }
                  },
                  textStyle: const TextStyle(fontSize: 18.0),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: state.editMode
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .inversePrimary, // indigo border color
                  selectedColor: Theme.of(context)
                      .colorScheme
                      .onPrimary, // white text color

                  fillColor: state.editMode
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .inversePrimary, // selected
                  color:
                      Theme.of(context).colorScheme.secondary, // not selected
                  constraints: BoxConstraints.expand(
                    width: (constraints.maxWidth - 4) / 3,
                  ),
                  isSelected: state.selectedWorkingMode.values.toList(),
                  children: const <Widget>[
                    Text('MGC'),
                    Text('AGC'),
                    Text('TGC'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UserPilot extends StatelessWidget {
  const _UserPilot({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingListViewBloc, SettingListViewState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: Row(
                  children: [
                    Text(
                      '${AppLocalizations.of(context).userPilot}: ',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${state.pilotChannel} ${state.pilotMode}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: textEditingController,
                key: const Key('settingForm_userPilotInput_textField'),
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
                enabled: state.editMode,
                textInputAction: TextInputAction.done,
                onChanged: (pilotCode) => context
                    .read<SettingListViewBloc>()
                    .add(PilotCodeChanged(pilotCode)),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: const EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: AppLocalizations.of(context).userPilot,
                  labelStyle: TextStyle(
                    fontSize: CustomStyle.sizeL,
                    color: Colors.grey.shade400,
                  ),
                  // suffixIconConstraints: const BoxConstraints(
                  //     maxHeight: 30, maxWidth: 30, minHeight: 30, minWidth: 30),
                  suffixIcon: IconButton(
                    iconSize: 26,
                    // padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
                    icon: const Icon(Icons.search_outlined),
                    onPressed: () {
                      context
                          .read<SettingListViewBloc>()
                          .add(const PilotChannelSearched());
                    },
                  ),
                  errorMaxLines: 2,
                  errorStyle: const TextStyle(fontSize: CustomStyle.sizeS),
                  errorText: state.pilotCode.isNotValid
                      ? AppLocalizations.of(context).pilotCodeFormatError
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UserPilot2 extends StatelessWidget {
  const _UserPilot2({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingListViewBloc, SettingListViewState>(
      builder: (context, state) {
        return state.hasDualPilot
            ? Padding(
                padding: const EdgeInsets.only(
                  bottom: 40.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${AppLocalizations.of(context).userPilot2}: ',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${state.pilot2Channel} ${state.pilot2Mode}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: textEditingController,
                      key: const Key('settingForm_userPilotInput_textField'),
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeXL,
                      ),
                      enabled: state.editMode,
                      textInputAction: TextInputAction.done,
                      onChanged: (pilotCode) => context
                          .read<SettingListViewBloc>()
                          .add(Pilot2CodeChanged(pilotCode)),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        contentPadding: const EdgeInsets.all(10.0),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: AppLocalizations.of(context).userPilot,
                        labelStyle: TextStyle(
                          fontSize: CustomStyle.sizeL,
                          color: Colors.grey.shade400,
                        ),
                        // suffixIconConstraints: const BoxConstraints(
                        //     maxHeight: 30,
                        //     maxWidth: 30,
                        //     minHeight: 30,
                        //     minWidth: 30),
                        suffixIcon: IconButton(
                          iconSize: 26,
                          // padding:
                          //     const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
                          icon: const Icon(Icons.search_outlined),
                          onPressed: () {
                            context
                                .read<SettingListViewBloc>()
                                .add(const Pilot2ChannelSearched());
                          },
                        ),
                        errorMaxLines: 2,
                        errorStyle:
                            const TextStyle(fontSize: CustomStyle.sizeS),
                        errorText: state.pilot2Code.isNotValid
                            ? AppLocalizations.of(context).pilotCodeFormatError
                            : null,
                      ),
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }
}

class _AGCPrepAttenator extends StatelessWidget {
  const _AGCPrepAttenator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingListViewBloc, SettingListViewState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 200.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: Row(
                  children: [
                    Text(
                      '${AppLocalizations.of(context).agcPrepAttenuator}: ',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      state.currentAttenuation.toString(),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SliderTheme(
                data: const SliderThemeData(
                  valueIndicatorColor: Colors.red,
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: Slider(
                  min: state.minAttenuation.toDouble(),
                  max: state.maxAttenuation.toDouble(),
                  divisions:
                      ((state.maxAttenuation - state.minAttenuation) ~/ 50)
                          .toInt(),
                  value: state.currentAttenuation.toDouble(),
                  onChanged: state.editMode
                      ? (attenuation) {
                          context.read<SettingListViewBloc>().add(
                              AGCPrepAttenuationChanged(attenuation.toInt()));
                        }
                      : null,
                  // onChangeEnd: state.editMode
                  //     ? (attenuation) {
                  //         print(attenuation);
                  //       }
                  //     : null,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filled(
                    icon: const Icon(
                      Icons.remove,
                    ),
                    onPressed: state.editMode
                        ? () {
                            context
                                .read<SettingListViewBloc>()
                                .add(const AGCPrepAttenuationDecreased());
                          }
                        : null,
                  ),
                  IconButton.filled(
                    icon: const Icon(
                      Icons.circle_outlined,
                    ),
                    onPressed: state.editMode
                        ? () {
                            context
                                .read<SettingListViewBloc>()
                                .add(const AGCPrepAttenuationCentered());
                          }
                        : null,
                  ),
                  IconButton.filled(
                    icon: const Icon(
                      Icons.add,
                    ),
                    onPressed: state.editMode
                        ? () {
                            context
                                .read<SettingListViewBloc>()
                                .add(const AGCPrepAttenuationIncreased());
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

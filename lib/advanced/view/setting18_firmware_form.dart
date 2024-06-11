import 'package:aci_plus_app/advanced/bloc/setting18_firmware/setting18_firmware_bloc.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/firmware_file_table.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18FirmwareForm extends StatelessWidget {
  const Setting18FirmwareForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    String currentFirmwareVersion = context
            .read<HomeBloc>()
            .state
            .characteristicData[DataKey.firmwareVersion] ??
        '';

    Future<void> showFailureDialog({
      required BuildContext buildContext,
      required String errorMessage,
    }) async {
      return showDialog<void>(
        context: buildContext,
        barrierDismissible: false, // user must tap button!
        builder: (_) {
          return BlocProvider.value(
            value: buildContext.read<Setting18FirmwareBloc>(),
            child: AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.dialogTitleError,
                style: const TextStyle(
                  color: CustomStyle.customRed,
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.firmwareUpdateError,
                    ),
                    Text(errorMessage),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    context
                        .read<Setting18FirmwareBloc>()
                        .add(const BootloaderExited());
                    Navigator.of(context).pop(); // pop dialog
                  },
                ),
                TextButton(
                  child: const Text('Try again'),
                  onPressed: () {
                    context
                        .read<Setting18FirmwareBloc>()
                        .add(const UpdateStarted());
                    Navigator.of(context).pop(); // pop dialog
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return BlocListener<Setting18FirmwareBloc, Setting18FirmwareState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus,
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionFailure) {
          await showFailureDialog(
            buildContext: context,
            errorMessage: state.errorMessage,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _UserCaution(),
            const _BinaryDropDownMenu(),
            const _ProgressBar(),
            _Progress(
              currentFirmwareVersion: currentFirmwareVersion,
              pageController: pageController,
            ),
          ],
        ),
      ),
    );
  }
}

class _UserCaution extends StatelessWidget {
  const _UserCaution({super.key});

  @override
  Widget build(BuildContext context) {
    Widget getInstructionRow({
      required String number,
      required String description,
    }) {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: CustomStyle.sizeXXL,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: CustomStyle.sizeXXL,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30.0,
          ),
          child: Row(
            children: [
              Text(
                '${AppLocalizations.of(context)!.instruction}: ',
                style: TextStyle(
                  fontSize: CustomStyle.size32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        getInstructionRow(
          number: '1. ',
          description: AppLocalizations.of(context)!.firmawreUpdateCaution1,
        ),
        getInstructionRow(
          number: '2. ',
          description: AppLocalizations.of(context)!.firmawreUpdateCaution2,
        ),
        getInstructionRow(
          number: '3. ',
          description: AppLocalizations.of(context)!.firmawreUpdateCaution3,
        ),
      ],
    );
  }
}

class _BinaryDropDownMenu extends StatelessWidget {
  const _BinaryDropDownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18FirmwareBloc, Setting18FirmwareState>(
      builder: (context, state) {
        return DropdownButton<String>(
          value: state.selectedBinary,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple, fontSize: 20),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            if (value != null) {
              context.read<Setting18FirmwareBloc>().add(BinarySelected(value));
            }
          },
          items: FirmwareFileTable.filePathMap.entries
              .map((entry) => DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  ))
              .toList(),
        );
      },
    );
  }
}

class _ProgressBar extends StatefulWidget {
  const _ProgressBar({super.key});

  @override
  State<_ProgressBar> createState() => __ProgressBarState();
}

class __ProgressBarState extends State<_ProgressBar>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);
    animationController.addStatusListener((status) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<Setting18FirmwareBloc, Setting18FirmwareState>(
      listenWhen: (previous, current) =>
          previous.updateMessage != current.updateMessage,
      listener: (context, state) async {
        animationController.animateTo(
          state.currentProgress,
          duration: const Duration(milliseconds: 200),
        );
      },
      child: BlocBuilder<Setting18FirmwareBloc, Setting18FirmwareState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: animationController.value,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    state.updateMessage,
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeL,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({
    super.key,
    required this.currentFirmwareVersion,
    required this.pageController,
  });

  final String currentFirmwareVersion;
  final String newFirmwareVersion = '128';
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    String localizedText = AppLocalizations.of(context)!
        .dialogMessageFirmwareUpdateVersion(
            currentFirmwareVersion, newFirmwareVersion);
    int currentFirmwareVersionIndex =
        localizedText.indexOf(currentFirmwareVersion);
    int newFirmwareVersionIndex = localizedText.indexOf(
      newFirmwareVersion,
      currentFirmwareVersionIndex + currentFirmwareVersion.length,
    );

    Future<bool?> showUpdateVersionDialog() async {
      return showDialog<bool?>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;

          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: width * 0.1,
            ),
            title: Text(
              AppLocalizations.of(context)!.dialogTitleNotice,
              style: const TextStyle(
                color: CustomStyle.customYellow,
              ),
            ),
            content: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        localizedText.substring(0, currentFirmwareVersionIndex),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: localizedText.substring(
                        currentFirmwareVersionIndex,
                        currentFirmwareVersionIndex +
                            currentFirmwareVersion.length),
                    style: const TextStyle(
                      color: CustomStyle.customRed,
                    ),
                  ),
                  TextSpan(
                    text: localizedText.substring(
                        currentFirmwareVersionIndex +
                            currentFirmwareVersion.length,
                        newFirmwareVersionIndex),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: localizedText.substring(newFirmwareVersionIndex,
                        newFirmwareVersionIndex + newFirmwareVersion.length),
                    style: const TextStyle(
                      color: CustomStyle.customRed,
                    ),
                  ),
                  TextSpan(
                    text: localizedText.substring(
                        newFirmwareVersionIndex + newFirmwareVersion.length,
                        localizedText.length),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: CustomStyle.sizeL,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageCancel,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false); // pop dialog
                },
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageOk,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    return BlocBuilder<Setting18FirmwareBloc, Setting18FirmwareState>(
        builder: (context, state) {
      return Column(
        children: [
          // // LinearProgressIndicator(
          // //   value: 0.5,
          // // ),

          Wrap(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size(80, 60),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
                    ),
                    textStyle: const TextStyle(
                      fontSize: CustomStyle.sizeXXL,
                    ),
                  ),
                  onPressed: () async {
                    showUpdateVersionDialog().then((bool? isConfirm) {
                      if (isConfirm != null) {
                        if (isConfirm) {
                          context
                              .read<Setting18FirmwareBloc>()
                              .add(const BootloaderStarted());
                        }
                      }
                    });
                  },
                  child: Text('Start'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size(80, 60),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
                    ),
                    textStyle: const TextStyle(
                      fontSize: CustomStyle.sizeXXL,
                    ),
                  ),
                  onPressed: () {
                    // pageController.animateToPage(
                    //   2,
                    //   duration: Duration(milliseconds: 500),
                    //   curve: Curves.easeInOut,
                    // );
                    context.read<HomeBloc>().add(const NeedsDataReloaded(true));
                    pageController.jumpToPage(2);
                  },
                  child: Text('Jump'),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 0),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Theme.of(context).colorScheme.primary,
              //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
              //       minimumSize: const Size(100, 60),
              //       shape: const RoundedRectangleBorder(
              //         borderRadius:
              //             BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
              //       ),
              //       textStyle: const TextStyle(
              //         fontSize: CustomStyle.sizeXXL,
              //       ),
              //     ),
              //     onPressed: () {
              //       context
              //           .read<Setting18FirmwareBloc>()
              //           .add(const UpdateStarted());
              //     },
              //     child: Text(
              //       AppLocalizations.of(context)!.startUpdate,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 0),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Theme.of(context).colorScheme.primary,
              //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
              //       minimumSize: const Size(80, 60),
              //       shape: const RoundedRectangleBorder(
              //         borderRadius:
              //             BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
              //       ),
              //       textStyle: const TextStyle(
              //         fontSize: CustomStyle.sizeXXL,
              //       ),
              //     ),
              //     onPressed: () {
              //       context
              //           .read<Setting18FirmwareBloc>()
              //           .add(const CommandWrited('N'));
              //     },
              //     child: Text("N"),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 0),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Theme.of(context).colorScheme.primary,
              //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
              //       minimumSize: const Size(80, 60),
              //       shape: const RoundedRectangleBorder(
              //         borderRadius:
              //             BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
              //       ),
              //       textStyle: const TextStyle(
              //         fontSize: CustomStyle.sizeXXL,
              //       ),
              //     ),
              //     onPressed: () {
              //       context
              //           .read<Setting18FirmwareBloc>()
              //           .add(const CommandWrited('Y'));
              //     },
              //     child: Text("Y"),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 0),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Theme.of(context).colorScheme.primary,
              //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
              //       minimumSize: const Size(100, 60),
              //       shape: const RoundedRectangleBorder(
              //         borderRadius:
              //             BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
              //       ),
              //       textStyle: const TextStyle(
              //         fontSize: CustomStyle.sizeXXL,
              //       ),
              //     ),
              //     onPressed: () {
              //       context
              //           .read<Setting18FirmwareBloc>()
              //           .add(const CommandWrited('N'));
              //     },
              //     child: Text("N"),
              //   ),
              // ),
            ],
          ),
        ],
      );
    });
  }
}

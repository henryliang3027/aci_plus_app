import 'package:aci_plus_app/advanced/bloc/setting18_advanced/setting18_advanced_bloc.dart';
import 'package:aci_plus_app/advanced/bloc/setting18_firmware/setting18_firmware_bloc.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:file_picker/file_picker.dart';

class Setting18FirmwareForm extends StatelessWidget {
  const Setting18FirmwareForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    Future<void> showRebootingDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.dialogTitleDeviceRebooting,
              ),
              actionsAlignment: MainAxisAlignment.center,
              content: const SingleChildScrollView(
                child: ListBody(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: SizedBox(
                          width: CustomStyle.diameter,
                          height: CustomStyle.diameter,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    Future<bool?> showFailureDialog({
      required BuildContext buildContext,
      required String errorMessage,
    }) async {
      return showDialog<bool>(
        context: buildContext,
        barrierDismissible: false, // 暫時打開
        builder: (_) {
          return BlocProvider.value(
            value: buildContext.read<Setting18FirmwareBloc>(),
            child: PopScope(
              canPop: false,
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
                        AppLocalizations.of(context)!
                            .dialogMessageFirmwareUpdateError,
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
                      Navigator.of(context).pop(false); // pop dialog
                    },
                  ),
                  TextButton(
                    child: const Text('Try again'),
                    onPressed: () {
                      context
                          .read<Setting18FirmwareBloc>()
                          .add(const UpdateStarted());
                      Navigator.of(context).pop(true); // pop dialog
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Future<void> showSuccessDialog({
      required BuildContext buildContext,
      required String timeElapsed,
    }) async {
      return showDialog<void>(
        context: buildContext,
        barrierDismissible: false, // user must tap button!
        builder: (_) {
          return BlocProvider.value(
            value: buildContext.read<Setting18FirmwareBloc>(),
            child: AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.dialogTitleSuccess,
                style: const TextStyle(
                  color: CustomStyle.customGreen,
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!
                          .dialogMessageFirmwareUpdateSuccess,
                    ),
                    Text(timeElapsed),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.dialogMessageOk,
                  ),
                  onPressed: () {
                    context
                        .read<Setting18FirmwareBloc>()
                        .add(const BootloaderExited());
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
          // 如果 failure dialog 沒有開啟才開啟
          if (ModalRoute.of(context)?.isCurrent == true) {
            showFailureDialog(
              buildContext: context,
              errorMessage: state.errorMessage,
            ).then((bool? retry) {
              if (retry != null) {
                if (!retry) {
                  showRebootingDialog(context);
                  Future.delayed(const Duration(seconds: 4)).then((_) {
                    Navigator.pop(context);

                    context.read<HomeBloc>().add(const Data18Requested());
                    pageController.jumpToPage(2);
                  });
                }
              }
            });
          }
        } else if (state.submissionStatus.isSubmissionSuccess) {
          showSuccessDialog(
            buildContext: context,
            timeElapsed: state.formattedTimeElapsed,
          ).then((_) {
            context.read<HomeBloc>().add(const Data18Requested());
            pageController.jumpToPage(2);
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _UserCaution(),
            const _ProgressBar(),
            _StartButton(
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
          mainAxisAlignment: MainAxisAlignment.start,
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

// class _FilePicker extends StatelessWidget {
//   const _FilePicker({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18FirmwareBloc, Setting18FirmwareState>(
//       builder: (context, state) {
//         return ElevatedButton(
//           onPressed: () async {
//             FilePickerResult? result = await FilePicker.platform.pickFiles(
//               type: FileType.custom,
//               allowedExtensions: ['bin'],
//               allowCompression: false,
//             );

//             if (result != null) {
//               context
//                   .read<Setting18FirmwareBloc>()
//                   .add(BinarySelected(result.files.single.path!));
//               // File file = File(result.files.single.path!);
//               // print(file.path);
//             } else {
//               // 使用者取消 file picker, 沒有選擇任何檔案
//             }
//           },
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.file_open_outlined),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 state.selectedBinaryName,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _BinaryDropDownMenu extends StatelessWidget {
//   const _BinaryDropDownMenu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18FirmwareBloc, Setting18FirmwareState>(
//       builder: (context, state) {
//         return DropdownButton<String>(
//           value: state.selectedBinary,
//           icon: const Icon(Icons.arrow_downward),
//           elevation: 16,
//           style: const TextStyle(color: Colors.deepPurple, fontSize: 20),
//           underline: Container(
//             height: 2,
//             color: Colors.deepPurpleAccent,
//           ),
//           onChanged: (String? value) {
//             if (value != null) {
//               context.read<Setting18FirmwareBloc>().add(BinarySelected(value));
//             }
//           },
//           items: FirmwareFileTable.filePathMap.entries
//               .map((entry) => DropdownMenuItem<String>(
//                     value: entry.key,
//                     child: Text(entry.value),
//                   ))
//               .toList(),
//         );
//       },
//     );
//   }
// }

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
                      minHeight: 10,
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

class _StartButton extends StatelessWidget {
  const _StartButton({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    Future<bool?> showUpdateVersionDialog({
      required String currentFirmwareVersion,
      required String newFirmwareVersion,
    }) async {
      String localizedText = AppLocalizations.of(context)!
          .dialogMessageFirmwareUpdateVersion(
              currentFirmwareVersion, newFirmwareVersion);
      int currentFirmwareVersionIndex =
          localizedText.indexOf(currentFirmwareVersion);
      int newFirmwareVersionIndex = localizedText.indexOf(
        newFirmwareVersion,
        currentFirmwareVersionIndex + currentFirmwareVersion.length,
      );

      return showDialog<bool?>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;

          return PopScope(
            canPop: false,
            child: AlertDialog(
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
                      text: localizedText.substring(
                          0, currentFirmwareVersionIndex),
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
            ),
          );
        },
      );
    }

    Widget buildStartButton({
      required bool isSubmissionInProgress,
      required String currentFirmwareVersion,
      required String newFirmwareVersion,
      required bool isEnabled,
    }) {
      return Wrap(
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
              onPressed: isEnabled && !isSubmissionInProgress
                  ? () async {
                      // FilePicker.platform
                      //     .pickFiles(
                      //   type: FileType.custom,
                      //   allowedExtensions: ['bin'],
                      //   allowCompression: false,
                      // )
                      //     .then((FilePickerResult? result) {
                      //   if (result != null) {
                      //     context.read<Setting18FirmwareBloc>().add(
                      //         BinarySelected(result.files.single.path!));
                      //     // File file = File(result.files.single.path!);
                      //     // print(file.path);
                      //   } else {
                      //     // 使用者取消 file picker, 沒有選擇任何檔案
                      //   }
                      // });

                      showUpdateVersionDialog(
                        currentFirmwareVersion: currentFirmwareVersion,
                        newFirmwareVersion: newFirmwareVersion,
                      ).then((bool? isConfirm) {
                        if (isConfirm != null) {
                          if (isConfirm) {
                            // disable 所有 button
                            context
                                .read<Setting18AdvancedBloc>()
                                .add(const AllButtonsDisabled());

                            context
                                .read<Setting18FirmwareBloc>()
                                .add(const BootloaderStarted());
                          }
                        }
                      });
                    }
                  : null,
              child: Text(
                AppLocalizations.of(context)!.startUpdate,
              ),
            ),
          ),
        ],
      );
    }

    return Builder(
      builder: (context) {
        final HomeState homeState = context.watch<HomeBloc>().state;
        final setting18FirmwareState =
            context.watch<Setting18FirmwareBloc>().state;

        if (homeState.loadingStatus.isRequestSuccess) {
          final String currentFirmwareVersion =
              homeState.characteristicData[DataKey.firmwareVersion]!;

          if (setting18FirmwareState.binaryLoadStatus.isNone) {
            String partId = homeState.characteristicData[DataKey.partId]!;

            context
                .read<Setting18FirmwareBloc>()
                .add(BinaryLoaded(partId: partId));
          }

          return buildStartButton(
            isSubmissionInProgress:
                setting18FirmwareState.submissionStatus.isSubmissionInProgress,
            currentFirmwareVersion: currentFirmwareVersion,
            newFirmwareVersion:
                setting18FirmwareState.selectedBinaryInfo.version,
            isEnabled: true,
          );
        } else {
          return buildStartButton(
            isSubmissionInProgress:
                setting18FirmwareState.submissionStatus.isSubmissionInProgress,
            currentFirmwareVersion: '',
            newFirmwareVersion: '',
            isEnabled: false,
          );
        }
      },
    );
  }
}

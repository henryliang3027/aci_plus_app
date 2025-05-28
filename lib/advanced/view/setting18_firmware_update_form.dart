import 'package:aci_plus_app/advanced/bloc/setting18_advanced/setting18_advanced_bloc.dart';
import 'package:aci_plus_app/advanced/bloc/setting18_firmware_update/setting18_firmware_update_bloc.dart';
import 'package:aci_plus_app/chart/shared/message_dialog.dart';
import 'package:aci_plus_app/chart/view/code_input_page.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18FirmwareUpdateForm extends StatelessWidget {
  const Setting18FirmwareUpdateForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.read<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    String strFirmwareVersion =
        homeState.characteristicData[DataKey.firmwareVersion] ?? '';
    int firmwareVersion = int.tryParse(strFirmwareVersion) ?? 0;

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

    Future<bool?> showSubmissionFailureDialog({
      required BuildContext buildContext,
      required String errorMessage,
    }) async {
      return showDialog<bool>(
        context: buildContext,
        barrierDismissible: false, // 暫時打開
        builder: (_) {
          return BlocProvider.value(
            value: buildContext.read<Setting18FirmwareUpdateBloc>(),
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
                  ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.dialogMessageCancel,
                    ),
                    onPressed: () {
                      context
                          .read<Setting18FirmwareUpdateBloc>()
                          .add(const BootloaderExited());
                      Navigator.of(context).pop(false); // pop dialog
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.dialogMessageTryAgain,
                    ),
                    onPressed: () {
                      context
                          .read<Setting18FirmwareUpdateBloc>()
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
            value: buildContext.read<Setting18FirmwareUpdateBloc>(),
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
                ElevatedButton(
                  child: Text(
                    AppLocalizations.of(context)!.dialogMessageOk,
                  ),
                  onPressed: () {
                    context
                        .read<Setting18FirmwareUpdateBloc>()
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

    void readDataAndJumpPage() {
      // 讀取 device 基本資訊
      if (partId == '4') {
        // C-Cor Node
        context
            .read<HomeBloc>()
            .add(const Data18CCorNodeRequested(isFirmwareUpdated: true));
      } else {
        // 其他機種的放大器
        context
            .read<HomeBloc>()
            .add(const Data18Requested(isFirmwareUpdated: true));
      }

      // 頁面跳轉到 information page
      pageController.jumpToPage(2);
    }

    return BlocListener<Setting18FirmwareUpdateBloc,
        Setting18FirmwareUpdateState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus,
      listener: (context, state) async {
        if (state.submissionStatus.isSubmissionFailure) {
          // 收到錯誤時 enable advanced page 的所有 button
          context.read<Setting18AdvancedBloc>().add(const AllButtonsEnabled());

          // 如果 failure dialog 沒有開啟才開啟
          if (ModalRoute.of(context)?.isCurrent == true) {
            showSubmissionFailureDialog(
              buildContext: context,
              errorMessage: state.errorMessage,
            ).then((bool? retry) {
              if (retry != null) {
                if (!retry) {
                  showRebootingDialog(context);
                  Future.delayed(const Duration(seconds: 4)).then((_) {
                    Navigator.pop(context);

                    readDataAndJumpPage();
                  });
                }
              }
            });
          }
        } else if (state.submissionStatus.isSubmissionSuccess) {
          // if (firmwareVersion >= 148) {
          //   context.read<Setting18FirmwareUpdateBloc>().add(UpdateLogAdded(
          //         previousFirmwareVersion: firmwareVersion,
          //       ));
          // }

          showSuccessDialog(
            buildContext: context,
            timeElapsed: state.formattedTimeElapsed,
          ).then((_) {
            readDataAndJumpPage();
          });
        }
      },
      child: PopScope(
        // 當更新正在進行時不允許點擊 android 的 system back button
        canPop: context
                .read<Setting18FirmwareUpdateBloc>()
                .state
                .submissionStatus
                .isSubmissionInProgress
            ? false
            : true,
        onPopInvokedWithResult: (didPop, result) {
          print('$didPop, $result');
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _UserCaution(),
                  const _ProgressBar(),
                  _FilePicker(partId: partId),
                  _StartButton(
                    pageController: pageController,
                    partId: partId,
                  ),
                  const SizedBox(
                    height: CustomStyle.formBottomSpacingS,
                  ),
                ],
              ),
            ),
          ),
          // floatingActionButton: const _Setting18FirmwareFloatingActionButton(),
        ),
      ),
    );
  }
}

class _UserCaution extends StatelessWidget {
  const _UserCaution();

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
          crossAxisAlignment:
              CrossAxisAlignment.baseline, // Align based on text baseline
          textBaseline: TextBaseline.alphabetic,
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
          description: AppLocalizations.of(context)!.firmwareUpdateCaution1,
        ),
        getInstructionRow(
          number: '2. ',
          description: AppLocalizations.of(context)!.firmwareUpdateCaution2,
        ),
        getInstructionRow(
          number: '3. ',
          description: AppLocalizations.of(context)!.firmwareUpdateCaution3,
        ),
        getInstructionRow(
          number: '4. ',
          description: AppLocalizations.of(context)!.firmwareUpdateCaution4,
        ),
      ],
    );
  }
}

// class _BinaryDropDownMenu extends StatelessWidget {
//   const _BinaryDropDownMenu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Setting18FirmwareUpdateBloc, Setting18FirmwareUpdateState>(
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
//               context.read<Setting18FirmwareUpdateBloc>().add(BinarySelected(value));
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
  const _ProgressBar();

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
    return BlocListener<Setting18FirmwareUpdateBloc,
        Setting18FirmwareUpdateState>(
      listenWhen: (previous, current) =>
          previous.updateMessage != current.updateMessage,
      listener: (context, state) async {
        animationController.animateTo(
          state.currentProgress,
          duration: const Duration(milliseconds: 200),
        );
      },
      child: BlocBuilder<Setting18FirmwareUpdateBloc,
          Setting18FirmwareUpdateState>(
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

class _FilePicker extends StatelessWidget {
  const _FilePicker({
    super.key,
    required this.partId,
  });

  final String partId;

  @override
  Widget build(BuildContext context) {
    Widget buildSelectButton({
      required bool isEnabled,
      required Setting18FirmwareUpdateState setting18FirmwareUpdateState,
    }) {
      BinaryInfo selectedBinaryInfo =
          setting18FirmwareUpdateState.selectedBinaryInfo;
      bool isValid = setting18FirmwareUpdateState.binaryCheckResult.isValid;

      return Column(
        children: [
          selectedBinaryInfo.isEmpty
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.insert_drive_file,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${selectedBinaryInfo.name}.${selectedBinaryInfo.extensionName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow:
                            TextOverflow.ellipsis, // Handles long file names
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: isValid
                          ? const Icon(
                              Icons.check,
                              color: CustomStyle.customGreen,
                            )
                          : const Icon(
                              Icons.close,
                              color: CustomStyle.customRed,
                            ),
                    ),
                  ],
                ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: const Size(140, 60),
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
              ),
              textStyle: const TextStyle(
                fontSize: CustomStyle.sizeXXL,
              ),
            ),
            onPressed: isEnabled
                ? () async {
                    context
                        .read<Setting18FirmwareUpdateBloc>()
                        .add(BinarySelected(
                          partId: partId,
                        ));
                  }
                : null,
            child: Text(
              AppLocalizations.of(context)!.selectFirmwareFile,
            ),
          ),
          const SizedBox(
            height: CustomStyle.size24,
          ),
        ],
      );
    }

    return BlocListener<Setting18FirmwareUpdateBloc,
        Setting18FirmwareUpdateState>(
      listenWhen: (previous, current) =>
          previous.binaryLoadStatus != current.binaryLoadStatus,
      listener: (context, state) {
        if (state.binaryLoadStatus.isRequestInProgress) {
          showInProgressDialog(context);
        } else if (state.binaryLoadStatus.isRequestSuccess) {
          if (ModalRoute.of(context)?.isCurrent == false) {
            Navigator.of(context).pop();
          }
        } else if (state.binaryLoadStatus.isRequestFailure) {
          if (ModalRoute.of(context)?.isCurrent == false) {
            Navigator.of(context).pop();
          }

          showFailureDialog(
            context: context,
            msg: state.fileErrorMessage,
          );
        } else {
          // 使用者點開 file picker 後沒有選擇任何檔案, 按下取消動作
          if (ModalRoute.of(context)?.isCurrent == false) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Builder(
        builder: (context) {
          final HomeState homeState = context.watch<HomeBloc>().state;
          final Setting18FirmwareUpdateState setting18FirmwareUpdateState =
              context.watch<Setting18FirmwareUpdateBloc>().state;

          if (homeState.loadingStatus.isRequestSuccess) {
            if (setting18FirmwareUpdateState
                .submissionStatus.isSubmissionInProgress) {
              return buildSelectButton(
                isEnabled: false,
                setting18FirmwareUpdateState: setting18FirmwareUpdateState,
              );
            } else {
              return buildSelectButton(
                isEnabled: true,
                setting18FirmwareUpdateState: setting18FirmwareUpdateState,
              );
            }
          } else {
            return buildSelectButton(
              isEnabled: false,
              setting18FirmwareUpdateState: setting18FirmwareUpdateState,
            );
          }
        },
      ),
    );
  }
}

Future<String?> showEnterCodeDialog({
  required BuildContext context,
}) async {
  return showDialog<String?>(
      context: context,
      builder: (context) {
        return const CodeInputPage();
      });
}

class _StartButton extends StatelessWidget {
  const _StartButton({
    required this.pageController,
    required this.partId,
  });

  final PageController pageController;
  final String partId;

  @override
  Widget build(BuildContext context) {
    // Future<bool?> showUpdateVersionDialog({
    //   required String currentFirmwareVersion,
    //   required String newFirmwareVersion,
    // }) async {
    //   String localizedText = AppLocalizations.of(context)!
    //       .dialogMessageFirmwareUpdateVersion(
    //           currentFirmwareVersion, newFirmwareVersion);
    //   int currentFirmwareVersionIndex =
    //       localizedText.indexOf(currentFirmwareVersion);
    //   int newFirmwareVersionIndex = localizedText.indexOf(
    //     newFirmwareVersion,
    //     currentFirmwareVersionIndex + currentFirmwareVersion.length,
    //   );

    //   return showDialog<bool?>(
    //     context: context,
    //     barrierDismissible: false, // user must tap button!
    //     builder: (BuildContext context) {
    //       var width = MediaQuery.of(context).size.width;
    //       // var height = MediaQuery.of(context).size.height;

    //       return PopScope(
    //         canPop: false,
    //         child: AlertDialog(
    //           insetPadding: EdgeInsets.symmetric(
    //             horizontal: width * 0.1,
    //           ),
    //           title: Text(
    //             AppLocalizations.of(context)!.dialogTitleNotice,
    //             style: const TextStyle(
    //               color: CustomStyle.customYellow,
    //             ),
    //           ),
    //           content: Text.rich(
    //             TextSpan(
    //               children: [
    //                 TextSpan(
    //                   text: localizedText.substring(
    //                       0, currentFirmwareVersionIndex),
    //                   style: const TextStyle(),
    //                 ),
    //                 TextSpan(
    //                   text: localizedText.substring(
    //                       currentFirmwareVersionIndex,
    //                       currentFirmwareVersionIndex +
    //                           currentFirmwareVersion.length),
    //                   style: const TextStyle(
    //                     color: CustomStyle.customRed,
    //                   ),
    //                 ),
    //                 TextSpan(
    //                   text: localizedText.substring(
    //                       currentFirmwareVersionIndex +
    //                           currentFirmwareVersion.length,
    //                       newFirmwareVersionIndex),
    //                   style: const TextStyle(),
    //                 ),
    //                 TextSpan(
    //                   text: localizedText.substring(newFirmwareVersionIndex,
    //                       newFirmwareVersionIndex + newFirmwareVersion.length),
    //                   style: const TextStyle(
    //                     color: CustomStyle.customRed,
    //                   ),
    //                 ),
    //                 TextSpan(
    //                   text: localizedText.substring(
    //                       newFirmwareVersionIndex + newFirmwareVersion.length,
    //                       localizedText.length),
    //                   style: const TextStyle(),
    //                 ),
    //               ],
    //             ),
    //             style: const TextStyle(
    //               fontSize: CustomStyle.sizeL,
    //             ),
    //           ),
    //           actions: <Widget>[
    //             ElevatedButton(
    //               child: Text(
    //                 AppLocalizations.of(context)!.dialogMessageCancel,
    //               ),
    //               onPressed: () {
    //                 Navigator.of(context).pop(false); // pop dialog
    //               },
    //             ),
    //             ElevatedButton(
    //               child: Text(
    //                 AppLocalizations.of(context)!.dialogMessageOk,
    //               ),
    //               onPressed: () {
    //                 Navigator.of(context).pop(true); // pop dialog
    //               },
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // }

    Widget buildStartButton({
      required bool isSubmissionInProgress,
      required String currentFirmwareVersion,
      // required String newFirmwareVersion,
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
                minimumSize: const Size(140, 60),
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
                      showEnterCodeDialog(context: context)
                          .then((String? code) {
                        if (code != null) {
                          if (code.isNotEmpty) {
                            context
                                .read<Setting18AdvancedBloc>()
                                .add(const AllButtonsDisabled());

                            handleUpdateAction(
                              context: context,
                              targetBloc:
                                  context.read<Setting18FirmwareUpdateBloc>(),
                              action: () {
                                context
                                    .read<Setting18FirmwareUpdateBloc>()
                                    .add(const BootloaderStarted());
                              },
                              waitForState: null,
                              isResumeUpdate: false,
                            );
                          }
                        }
                      });

                      // FilePicker.platform
                      //     .pickFiles(
                      //   type: FileType.custom,
                      //   allowedExtensions: ['bin'],
                      //   allowCompression: false,
                      // )
                      //     .then((FilePickerResult? result) {
                      //   if (result != null) {
                      //     context.read<Setting18FirmwareUpdateBloc>().add(
                      //         BinarySelected(result.files.single.path!));
                      //     // File file = File(result.files.single.path!);
                      //     // print(file.path);
                      //   } else {
                      //     // 使用者取消 file picker, 沒有選擇任何檔案
                      //   }
                      // });

                      // showUpdateVersionDialog(
                      //   currentFirmwareVersion: currentFirmwareVersion,
                      //   newFirmwareVersion: newFirmwareVersion,
                      // ).then((bool? isConfirm) {
                      //   if (isConfirm != null) {
                      //     if (isConfirm) {
                      //       // disable 所有 button
                      //       context
                      //           .read<Setting18AdvancedBloc>()
                      //           .add(const AllButtonsDisabled());

                      //       context
                      //           .read<Setting18FirmwareUpdateBloc>()
                      //           .add(const BootloaderStarted());
                      //     }
                      //   }
                      // });
                    }
                  : null,
              child: Text(
                AppLocalizations.of(context)!.startUpdate,
              ),
            ),
          ),
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
          //           .read<Setting18FirmwareUpdateBloc>()
          //           .add(const CommandWrited('N'));
          //     },
          //     child: Text(
          //       'N',
          //     ),
          //   ),
          // ),
        ],
      );
    }

    return Builder(
      builder: (context) {
        final HomeState homeState = context.watch<HomeBloc>().state;
        final setting18FirmwareUpdateState =
            context.watch<Setting18FirmwareUpdateBloc>().state;

        if (homeState.loadingStatus.isRequestSuccess) {
          final String currentFirmwareVersion =
              homeState.characteristicData[DataKey.firmwareVersion]!;

          // if (setting18FirmwareUpdateState.binaryLoadStatus.isNone) {
          //   context.read<Setting18FirmwareUpdateBloc>().add(BinaryLoaded(
          //         partId: partId,
          //         currentFirmwareVersion: currentFirmwareVersion,
          //       ));
          // }

          return buildStartButton(
            isSubmissionInProgress: setting18FirmwareUpdateState
                .submissionStatus.isSubmissionInProgress,
            currentFirmwareVersion: currentFirmwareVersion,
            // newFirmwareVersion:
            //     setting18FirmwareUpdateState.selectedBinaryInfo.version,
            isEnabled:
                setting18FirmwareUpdateState.binaryLoadStatus.isRequestSuccess,
          );
        } else {
          if (homeState.connectionStatus.isRequestFailure) {
            if (setting18FirmwareUpdateState
                .submissionStatus.isSubmissionInProgress) {
              // 如果 firmware update 過程中斷線時, isDisconnectOnFirmwareUpdate 設為 true
              CrossPageFlag.isDisconnectOnFirmwareUpdate = true;
            }

            // 斷線時 enable advanced page 的所有 button
            context
                .read<Setting18AdvancedBloc>()
                .add(const AllButtonsEnabled());
          }

          return buildStartButton(
            isSubmissionInProgress: setting18FirmwareUpdateState
                .submissionStatus.isSubmissionInProgress,
            currentFirmwareVersion: '',
            // newFirmwareVersion: '',
            isEnabled: false,
          );
        }
      },
    );
  }
}

// class _Setting18FirmwareFloatingActionButton extends StatelessWidget {
//   const _Setting18FirmwareFloatingActionButton();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       buildWhen: (previous, current) =>
//           previous.loadingStatus != current.loadingStatus,
//       builder: (context, state) {
//         return FloatingActionButton(
//           heroTag: null,
//           shape: const CircleBorder(
//             side: BorderSide.none,
//           ),
//           backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
//           onPressed: () {
//             showSetupWizardDialog(
//               context: context,
//               functionDescriptionType: FunctionDescriptionType.firmwareUpdate,
//               aciDeviceType: ACIDeviceType.amp1P8G,
//             );
//           },
//           child: Icon(
//             CustomIcons.information,
//             color: Theme.of(context).colorScheme.onPrimary,
//           ),
//         );
//       },
//     );
//   }
// }

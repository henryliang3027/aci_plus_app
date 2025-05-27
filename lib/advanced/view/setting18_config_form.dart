import 'dart:io';

import 'package:aci_plus_app/advanced/bloc/setting18_config/setting18_config_bloc.dart';
import 'package:aci_plus_app/advanced/shared/utils.dart';
import 'package:aci_plus_app/advanced/view/description_input_page.dart';
import 'package:aci_plus_app/advanced/view/qr_code_image_viewer.dart';
import 'package:aci_plus_app/advanced/view/qr_code_scanner_win.dart';
import 'package:aci_plus_app/advanced/view/qr_code_generator_page.dart';
import 'package:aci_plus_app/advanced/view/qr_code_scanner.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_tab_bar.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ConfigForm extends StatelessWidget {
  const Setting18ConfigForm({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> showGeneratedQRCodeDialog({
      required String encodedData,
      required String description,
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
            child: SizedBox(
              child: QRCodeGeneratorPage(
                encodedData: encodedData,
                description: description,
              ),
            ),
          );
        },
      );
    }

    Future<bool?> showAllConfigUpdatedDialog({
      Config? config,
    }) async {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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
                        .dialogMessageAllConfigsUpdated,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageOk,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> showDecodeFailureDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
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
                    AppLocalizations.of(context)!.dialogMessageInvalidQRCode,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
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

    Future<String?> showQRCodeDescriptionDialog() async {
      return showDialog<String?>(
          context: context,
          builder: (context) {
            return const DescriptionInputPage();
          });
    }

    Future<bool?> showQRCodePreviewDialog(String imageFilePath) {
      return showDialog<bool?>(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;

          return Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: width * 0.01,
            ),
            child: SizedBox(
              child: QRCodeImageViewer(
                imageFilePath: imageFilePath,
              ),
            ),
          );
        },
      );
    }

    return BlocListener<Setting18ConfigBloc, Setting18ConfigState>(
      listener: (context, state) {
        if (state.encodeStaus.isRequestSuccess) {
          showQRCodeDescriptionDialog().then((String? description) {
            if (description != null) {
              showGeneratedQRCodeDialog(
                encodedData: state.encodedData,
                description: description,
              );
            }
          });
        } else if (state.decodeStatus.isRequestSuccess) {
          showAllConfigUpdatedDialog();
        } else if (state.decodeStatus.isRequestFailure) {
          showDecodeFailureDialog();
        } else if (state.pickImageStatus.isRequestInProgress) {
          showProgressingDialog(context);
        } else if (state.pickImageStatus.isRequestSuccess) {
          Navigator.of(context).pop();
          if (state.imageFilePath.isNotEmpty) {
            showQRCodePreviewDialog(state.imageFilePath)
                .then((bool? isConfirm) {
              if (isConfirm != null) {
                if (isConfirm) {
                  context.read<Setting18ConfigBloc>().add(const QRImageRead());
                }
              }
            });
          }
        }
      },
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigBloc, Setting18ConfigState>(
      buildWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      builder: (context, state) {
        if (state.formStatus.isNone || state.formStatus.isRequestInProgress) {
          return Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        } else {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _QRToolbar(),
              Expanded(
                child: Setting18ConfigTabBar(),
              ),
              // _DeviceListView(),
            ],
          );
        }
      },
    );
  }
}

class _QRToolbar extends StatelessWidget {
  const _QRToolbar();

  @override
  Widget build(BuildContext context) {
    Future showWindowsQRCodeScannerDialog() {
      return showDialog(
        context: context,

        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;

          return Dialog(
            clipBehavior: Clip.hardEdge,
            insetPadding: EdgeInsets.symmetric(
              horizontal: width * 0.01,
            ),
            child: WindowsQRCodeScanner(
              onScanned: (res) {
                Navigator.pop(context, res);
              },
            ),
          );
        },
      );
    }

    return BlocBuilder<Setting18ConfigBloc, Setting18ConfigState>(
      buildWhen: (previous, current) =>
          previous.trunkConfigs != current.trunkConfigs ||
          previous.distributionConfigs != current.distributionConfigs ||
          previous.nodeConfigs != current.nodeConfigs,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            // borderRadius: BorderRadius.circular(10),
          ),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 20.0,
              ),
              Text(
                AppLocalizations.of(context)!.scanQRCode,
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                ),
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: ModeProperty.isExpertMode
                        ? [
                            ...state.trunkConfigs,
                            ...state.distributionConfigs,
                            ...state.nodeConfigs
                          ].isNotEmpty
                            ? () {
                                context
                                    .read<Setting18ConfigBloc>()
                                    .add(const QRDataGenerated());
                              }
                            : null
                        : null,
                    icon: Icon(
                      Icons.qr_code_2,
                      size: 26,
                      color: ModeProperty.isExpertMode
                          ? [
                              ...state.trunkConfigs,
                              ...state.distributionConfigs,
                              ...state.nodeConfigs
                            ].isNotEmpty
                              ? Theme.of(context).iconTheme.color
                              : Colors.grey
                          : Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: Platform.isWindows
                        ? winBeta >= 5
                            ? state.isCameraAvailable
                                ? () {
                                    showWindowsQRCodeScannerDialog()
                                        .then((rawData) {
                                      if (rawData != null) {
                                        context
                                            .read<Setting18ConfigBloc>()
                                            .add(QRDataScanned(rawData));
                                      }
                                    });
                                  }
                                : null
                            : null
                        : () {
                            Navigator.push(
                              context,
                              QRCodeScanner.route(),
                            ).then((rawData) {
                              if (rawData != null) {
                                if (rawData.isNotEmpty) {
                                  context
                                      .read<Setting18ConfigBloc>()
                                      .add(QRDataScanned(rawData));
                                }
                              }
                            });
                          },
                    icon: Icon(Icons.qr_code_scanner_sharp,
                        size: 26, color: Theme.of(context).iconTheme.color),
                  ),
                  Platform.isWindows
                      ? ModeProperty.isExpertMode
                          ? winBeta >= 6
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        context
                                            .read<Setting18ConfigBloc>()
                                            .add(const QRImagePicked());
                                      },
                                      icon: Icon(CustomIcons.picture,
                                          size: 26,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                    ),
                                  ],
                                )
                              : Container()
                          : Container()
                      : Container(),
                  const SizedBox(
                    width: 6.0,
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

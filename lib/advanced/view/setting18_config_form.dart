import 'dart:io';

import 'package:aci_plus_app/advanced/bloc/setting18_config/setting18_config_bloc.dart';
import 'package:aci_plus_app/advanced/view/qr_code_generator_page.dart';
import 'package:aci_plus_app/advanced/view/qr_code_scanner.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_tab_bar.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class Setting18ConfigForm extends StatelessWidget {
  const Setting18ConfigForm({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: SizedBox(
              child: QRCodeGeneratorPage(
                encodedData: encodedData,
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
              TextButton(
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

    return BlocListener<Setting18ConfigBloc, Setting18ConfigState>(
      listener: (context, state) {
        if (state.encodeStaus.isRequestSuccess) {
          showGeneratedQRCodeDialog(encodedData: state.encodedData);
        } else if (state.decodeStatus.isRequestSuccess) {
          showAllConfigUpdatedDialog();
        } else if (state.decodeStatus.isRequestFailure) {
          showDecodeFailureDialog();
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
    return BlocBuilder<Setting18ConfigBloc, Setting18ConfigState>(
      buildWhen: (previous, current) =>
          previous.trunkConfigs != current.trunkConfigs ||
          previous.distributionConfigs != current.distributionConfigs,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26.0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.scanQRCode,
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeXL,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: [
                              ...state.trunkConfigs,
                              ...state.distributionConfigs
                            ].isNotEmpty
                                ? () {
                                    context
                                        .read<Setting18ConfigBloc>()
                                        .add(const QRDataGenerated());
                                  }
                                : null,
                            icon: const Icon(
                              Icons.qr_code_2,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (Platform.isWindows) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SimpleBarcodeScannerPage(
                                        scanType: ScanType.qr,
                                      ),
                                    )).then((rawData) {
                                  if (rawData != null) {
                                    if (rawData.isNotEmpty) {
                                      context
                                          .read<Setting18ConfigBloc>()
                                          .add(QRDataScanned(rawData));
                                    }
                                  }
                                });
                              } else {
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
                              }
                            },
                            icon: const Icon(
                              Icons.qr_code_scanner_sharp,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
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

import 'package:aci_plus_app/advanced/bloc/setting18_config/setting18_config_bloc.dart';
import 'package:aci_plus_app/advanced/view/qr_code_generator_page.dart';
import 'package:aci_plus_app/advanced/view/qr_code_scanner.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_edit_page.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/distribution_config.dart';
import 'package:aci_plus_app/repositories/trunk_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            child: QRCodeGeneratorPage(
              encodedData: encodedData,
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
      child: const _ViewLayout(),
    );
  }
}

class _ViewLayout extends StatelessWidget {
  const _ViewLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadingStatus.isRequestInProgress) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              const _Content(),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(70, 158, 158, 158),
                ),
                child: const Center(
                  child: SizedBox(
                    width: CustomStyle.diameter,
                    height: CustomStyle.diameter,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const _Content();
        }
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({super.key});

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
          return const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Version(),
                // _QRToolbar(),
                _DeviceListView(),
              ],
            ),
          );
        }
      },
    );
  }
}

class _Version extends StatelessWidget {
  const _Version({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigBloc, Setting18ConfigState>(
      buildWhen: (previous, current) =>
          previous.buildVersion != current.buildVersion,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                state.buildVersion,
              )
            ],
          ),
        );
      },
    );
  }
}

class _QRToolbar extends StatelessWidget {
  const _QRToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigBloc, Setting18ConfigState>(
      buildWhen: (previous, current) =>
          previous.trunkConfigs != current.trunkConfigs ||
          previous.distributionConfigs != current.distributionConfigs,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Card(
            color: Theme.of(context).colorScheme.onPrimary,
            surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
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
            ),
          ),
        );
      },
    );
  }
}

class _DeviceListView extends StatelessWidget {
  const _DeviceListView({super.key});

  @override
  Widget build(BuildContext context) {
    Future<bool?> showAddConfigDialog({
      required String groupId,
    }) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;

          return Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: width * 0.01,
            ),
            child: Setting18ConfigEditPage(
              groupId: groupId,
            ),
          );
        },
      );
    }

    Future<bool?> showEditConfigDialog({
      required Config config,
      required String groupId,
    }) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;

          return Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: width * 0.01,
            ),
            child: Setting18ConfigEditPage(
              config: config,
              groupId: groupId,
              isEdit: true,
            ),
          );
        },
      );
    }

    Future<bool?> showConfirmDeleteDialog({required String configName}) {
      String localizedText =
          AppLocalizations.of(context)!.dialogMessageDeleteConfig(configName);
      int configNameIndex = localizedText.indexOf(configName);

      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitleDeleteConfig,
            ),
            content: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: localizedText.substring(0, configNameIndex),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: localizedText.substring(
                        configNameIndex, configNameIndex + configName.length),
                    style: const TextStyle(
                      color: CustomStyle.customRed,
                    ),
                  ),
                  TextSpan(
                    text: localizedText.substring(
                        configNameIndex + configName.length,
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
                  style: const TextStyle(color: CustomStyle.customRed),
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

    Future<bool?> showSetAsDefaultDialog({
      required String configName,
    }) {
      String localizedText = AppLocalizations.of(context)!
          .dialogMessageSetAsDefaultConfig(configName);
      int configNameIndex = localizedText.indexOf(configName);

      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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
                    text: localizedText.substring(0, configNameIndex),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: localizedText.substring(
                        configNameIndex, configNameIndex + configName.length),
                    style: const TextStyle(
                      color: CustomStyle.customRed,
                    ),
                  ),
                  TextSpan(
                    text: localizedText.substring(
                        configNameIndex + configName.length,
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
                  style: const TextStyle(color: CustomStyle.customRed),
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

    Widget configCard({
      required Config config,
      required String groupId,
    }) {
      return Card(
        // margin: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.onPrimary,

            // config.isDefault == '1'
            //     ? CustomStyle.customBlue
            //     : Theme.of(context).colorScheme.onPrimary,
          ),
          // height: 80,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0),
              onLongPress: () {
                showSetAsDefaultDialog(configName: config.name).then((result) {
                  if (result != null) {
                    if (result) {
                      context
                          .read<Setting18ConfigBloc>()
                          .add(DefaultConfigChanged(
                            groupId: groupId,
                            id: config.id,
                          ));
                    }
                  }
                });
              },

              // config.isDefault == '0'
              //     ? () {
              //         showSetAsDefaultDialog(configName: config.name)
              //             .then((result) {
              //           if (result != null) {
              //             if (result) {
              //               context
              //                   .read<Setting18ConfigBloc>()
              //                   .add(DefaultConfigChanged(
              //                     groupId: groupId,
              //                     id: config.id,
              //                   ));
              //             }
              //           }
              //         });
              //       }
              //     : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26.0,
                        vertical: 24.0,
                      ),
                      child: Text(
                        config.name,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                showConfirmDeleteDialog(
                                  configName: config.name,
                                ).then((result) {
                                  if (result != null) {
                                    if (result) {
                                      context
                                          .read<Setting18ConfigBloc>()
                                          .add(ConfigDeleted(
                                            id: config.id,
                                            groupId: groupId,
                                          ));
                                    }
                                  }
                                });
                              },

                              // config.isDefault == '0' || true
                              //     ? () {
                              //         showConfirmDeleteDialog(
                              //           configName: config.name,
                              //         ).then((result) {
                              //           if (result != null) {
                              //             if (result) {
                              //               context
                              //                   .read<Setting18ConfigBloc>()
                              //                   .add(ConfigDeleted(
                              //                     id: config.id,
                              //                     groupId: groupId,
                              //                   ));
                              //             }
                              //           }
                              //         });
                              //       }
                              //     : null,
                              icon: const Icon(
                                Icons.delete,
                                size: 26,
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () async {
                                showEditConfigDialog(
                                  config: config,
                                  groupId: groupId,
                                ).then((result) {
                                  context
                                      .read<Setting18ConfigBloc>()
                                      .add(const ConfigsRequested());
                                });
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget addButton({
      required List<Config> configs,
      required String groupId,
    }) {
      return Material(
        color: Colors.transparent,
        child: Ink(
          decoration: ShapeDecoration(
            color: configs.length < 5
                ? Theme.of(context).colorScheme.primary.withAlpha(200)
                : Colors.grey.withAlpha(200),
            shape: const CircleBorder(),
          ),
          child: IconButton(
            onPressed: configs.length < 5
                ? () async {
                    showAddConfigDialog(groupId: groupId).then(
                      (result) async {
                        // await Future.delayed(Duration(seconds: 1));
                        context
                            .read<Setting18ConfigBloc>()
                            .add(const ConfigsRequested());
                      },
                    );
                  }
                : null,
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      );
    }

    List<Widget> buildTrunkConfigListView({
      required List<TrunkConfig> trunkConfigs,
    }) {
      String groupId = '0';
      return [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.trunkAmplifier,
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                  fontWeight: FontWeight.w500,
                ),
              ),
              addButton(
                configs: trunkConfigs,
                groupId: groupId,
              ),
            ],
          ),
        ),
        for (Config trunkConfig in trunkConfigs) ...[
          configCard(
            config: trunkConfig,
            groupId: groupId,
          ),
        ],
      ];
    }

    List<Widget> buildDistributionConfigListView({
      required List<DistributionConfig> distributionConfigs,
    }) {
      String groupId = '1';
      return [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.distributionAmplifier,
                style: const TextStyle(
                  fontSize: CustomStyle.sizeXL,
                  fontWeight: FontWeight.w500,
                ),
              ),
              addButton(
                configs: distributionConfigs,
                groupId: groupId,
              ),
            ],
          ),
        ),
        for (Config distributionConfig in distributionConfigs) ...[
          configCard(
            config: distributionConfig,
            groupId: groupId,
          ),
        ],
      ];
    }

    return BlocBuilder<Setting18ConfigBloc, Setting18ConfigState>(
      buildWhen: (previous, current) =>
          previous.trunkConfigs != current.trunkConfigs ||
          previous.distributionConfigs != current.distributionConfigs,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...buildTrunkConfigListView(trunkConfigs: state.trunkConfigs),
            const SizedBox(
              height: 20,
            ),
            ...buildDistributionConfigListView(
                distributionConfigs: state.distributionConfigs),
          ],
        );
      },
    );
  }
}

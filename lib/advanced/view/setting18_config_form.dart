import 'package:aci_plus_app/advanced/bloc/setting18_config/setting18_config_bloc.dart';
import 'package:aci_plus_app/advanced/view/qr_code_generator_page.dart';
import 'package:aci_plus_app/advanced/view/qr_code_scanner.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_edit_page.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
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

    return BlocListener<Setting18ConfigBloc, Setting18ConfigState>(
      listener: (context, state) {
        if (state.encodeStaus == FormStatus.requestSuccess) {
          showGeneratedQRCodeDialog(encodedData: state.encodedData);
        }
      },
      child: const SingleChildScrollView(
        child: Column(
          children: [
            // _QRToolbar(),
            _BuildVersion(),
            _DeviceListView(),
          ],
        ),
      ),
    );
  }
}

class _BuildVersion extends StatelessWidget {
  const _BuildVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigBloc, Setting18ConfigState>(
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
                                onPressed: () {
                                  context
                                      .read<Setting18ConfigBloc>()
                                      .add(QRDataGenerated('3'));
                                },
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
                                      if (rawData.isNotEmpty) {}
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
      Config? config,
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
              isEdit: true,
            ),
          );
        },
      );
    }

    Future<bool?> showConfirmDeleteDialog({required String configName}) {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitleDeleteConfig,
            ),
            content: Row(
              children: [
                Text(AppLocalizations.of(context)!.dialogMessageDeleteConfig),
                Text(
                  '$configName ',
                  style: const TextStyle(color: CustomStyle.customRed),
                ),
                const Text(
                  '?',
                ),
              ],
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
            color: config.isDefault == '1'
                ? Colors.green.shade400
                : Theme.of(context).colorScheme.onPrimary,
          ),
          height: 100,
          child: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            onLongPress: () {
              showSetAsDefaultDialog(configName: config.name).then((result) {
                if (result != null) {
                  if (result) {
                    context
                        .read<Setting18ConfigBloc>()
                        .add(DefaultConfigChanged(
                          groupId: config.groupId,
                          id: config.id,
                        ));
                  }
                }
              });
            },
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
                      config.name,
                      style: const TextStyle(
                        fontSize: CustomStyle.size36,
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
                        IconButton(
                          onPressed: () {
                            showConfirmDeleteDialog(
                              configName: config.name,
                            ).then((result) {
                              if (result != null) {
                                if (result) {
                                  context
                                      .read<Setting18ConfigBloc>()
                                      .add(ConfigDeleted(config.id));
                                }
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 26,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            showEditConfigDialog(config: config).then((result) {
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget addButton({
      required List<Config> filteredConfigs,
      required String groupId,
    }) {
      return Material(
        color: Colors.transparent,
        child: Ink(
          decoration: ShapeDecoration(
            color: filteredConfigs.length < 5
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.inversePrimary,
            shape: const CircleBorder(),
          ),
          child: IconButton(
            onPressed: filteredConfigs.length < 5
                ? () async {
                    showAddConfigDialog(groupId: groupId).then(
                      (result) {
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
      required List<Config> configs,
    }) {
      List<Config> trunkConfigs =
          configs.where((config) => config.groupId == '0').toList();

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
                filteredConfigs: trunkConfigs,
                groupId: '0',
              ),
            ],
          ),
        ),
        for (Config trunkConfig in trunkConfigs) ...[
          configCard(config: trunkConfig),
        ],
      ];
    }

    List<Widget> buildDistributionConfigListView({
      required List<Config> configs,
    }) {
      List<Config> distributionConfigs =
          configs.where((config) => config.groupId == '1').toList();

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
                filteredConfigs: distributionConfigs,
                groupId: '1',
              ),
            ],
          ),
        ),
        for (Config distributionConfig in distributionConfigs) ...[
          configCard(config: distributionConfig),
        ],
      ];
    }

    return BlocBuilder<Setting18ConfigBloc, Setting18ConfigState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...buildTrunkConfigListView(configs: state.configs),
            const SizedBox(
              height: 20,
            ),
            ...buildDistributionConfigListView(configs: state.configs),
          ],
        );
      },
    );
  }
}

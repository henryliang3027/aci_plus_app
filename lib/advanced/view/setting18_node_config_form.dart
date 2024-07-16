import 'package:aci_plus_app/advanced/bloc/setting18_config/setting18_config_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_node_config_edit_page.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_edit_page.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18NodeConfigForm extends StatelessWidget {
  const Setting18NodeConfigForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _DeviceListView(),
      floatingActionButton: _ConfigFloatActionButton(),
    );
  }
}

class _ConfigFloatActionButton extends StatelessWidget {
  const _ConfigFloatActionButton({super.key});

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
            child: const Setting18NodeConfigEditPage(),
          );
        },
      );
    }

    return BlocBuilder<Setting18ConfigBloc, Setting18ConfigState>(
      builder: (context, state) {
        return FloatingActionButton(
          shape: const CircleBorder(
            side: BorderSide.none,
          ),
          backgroundColor: state.nodeConfigs.length < 5
              ? Theme.of(context).colorScheme.primary.withAlpha(200)
              : Colors.grey.withAlpha(200),
          onPressed: state.nodeConfigs.length < 5
              ? () async {
                  showAddConfigDialog(groupId: '2').then(
                    (result) async {
                      // await Future.delayed(Duration(seconds: 1));
                      context
                          .read<Setting18ConfigBloc>()
                          .add(const ConfigsRequested());
                    },
                  );
                }
              : null,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
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
    Future<bool?> showEditConfigDialog({
      required NodeConfig nodeConfig,
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
            child: Setting18NodeConfigEditPage(
              nodeConfig: nodeConfig,
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
      required NodeConfig nodeConfig,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26.0,
                        vertical: 24.0,
                      ),
                      child: Text(
                        nodeConfig.name,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 136,
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
                                  configName: nodeConfig.name,
                                ).then((result) {
                                  if (result != null) {
                                    if (result) {
                                      context
                                          .read<Setting18ConfigBloc>()
                                          .add(ConfigDeleted(
                                            id: nodeConfig.id,
                                            groupId: groupId,
                                          ));
                                    }
                                  }
                                });
                              },
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
                                  nodeConfig: nodeConfig,
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

    List<Widget> buildNodeConfigListView({
      required List<NodeConfig> nodeConfigs,
    }) {
      String groupId = '2';
      return [
        for (NodeConfig nodeConfig in nodeConfigs) ...[
          configCard(
            nodeConfig: nodeConfig,
            groupId: groupId,
          ),
        ],
        const SizedBox(
          height: 100,
        ),
      ];
    }

    return BlocBuilder<Setting18ConfigBloc, Setting18ConfigState>(
      buildWhen: (previous, current) =>
          previous.trunkConfigs != current.trunkConfigs,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...buildNodeConfigListView(nodeConfigs: state.nodeConfigs),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}

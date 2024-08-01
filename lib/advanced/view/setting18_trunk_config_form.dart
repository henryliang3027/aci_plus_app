import 'package:aci_plus_app/advanced/bloc/setting18_config/setting18_config_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_edit_page.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18TrunkConfigForm extends StatelessWidget {
  const Setting18TrunkConfigForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _DeviceListView(),
      floatingActionButton: _ConfigFloatActionButton(),
    );
  }
}

class _ConfigFloatActionButton extends StatelessWidget {
  const _ConfigFloatActionButton();

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

    return BlocBuilder<Setting18ConfigBloc, Setting18ConfigState>(
      builder: (context, state) {
        return FloatingActionButton(
          shape: const CircleBorder(
            side: BorderSide.none,
          ),
          backgroundColor: state.trunkConfigs.length < 3
              ? Theme.of(context).colorScheme.primary.withAlpha(200)
              : Colors.grey.withAlpha(200),
          onPressed: state.trunkConfigs.length < 3
              ? () async {
                  showAddConfigDialog(groupId: '0').then(
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
  const _DeviceListView();

  @override
  Widget build(BuildContext context) {
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
                    style: const TextStyle(),
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
                    style: const TextStyle(),
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
                    style: const TextStyle(),
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
                    style: const TextStyle(),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
                  config.name,
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
      );
    }

    List<Widget> buildTrunkConfigListView({
      required List<Config> trunkConfigs,
    }) {
      String groupId = '0';
      return [
        for (Config trunkConfig in trunkConfigs) ...[
          configCard(
            config: trunkConfig,
            groupId: groupId,
          ),
        ],
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
              ...buildTrunkConfigListView(trunkConfigs: state.trunkConfigs),
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

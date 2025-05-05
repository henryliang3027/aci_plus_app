import 'package:aci_plus_app/about/about18_page.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_buttom_navigation_bar18.dart';
import 'package:aci_plus_app/information/bloc/information18_ccor_node/information18_ccor_node_bloc.dart';
import 'package:aci_plus_app/information/shared/mode_widget.dart';
import 'package:aci_plus_app/information/shared/theme_option_widget.dart';
import 'package:aci_plus_app/information/shared/utils.dart';
import 'package:aci_plus_app/information/shared/warm_reset_widget.dart';
import 'package:aci_plus_app/information/views/information18_ccor_node_config_list_view.dart';
import 'package:aci_plus_app/information/views/name_plate_view.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Information18CCorNodeForm extends StatelessWidget {
  const Information18CCorNodeForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    // 此參數用來設定 SetupWizard 該顯示的說明
    SetupWizardProperty.functionDescriptionType =
        FunctionDescriptionType.information;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
        centerTitle: true,
        leading: const _DeviceStatus(),
        actions: const [_PopupMenu()],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // _VersionCard(),
            _ConnectionCard(),
            _ShortcutCard(),
            // _BlockDiagramCard(),
            _BasicCard(),
            // _AlarmCard(),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar18(
        pageController: pageController,
        selectedIndex: 2,
        onTap: (int index) {
          // if (index != 2) {
          //   context
          //       .read<Information18CCorNodeBloc>()
          //       .add(const AlarmPeriodicUpdateCanceled());
          // }

          pageController.jumpToPage(
            index,
          );
        },
      ),
      // floatingActionButton: const Information18SetupWizard(),
    );
  }
}

enum HomeMenu {
  refresh,
  mode,
  theme,
  warmReset,
  about,
}

class _PopupMenu extends StatefulWidget {
  const _PopupMenu();

  @override
  State<_PopupMenu> createState() => __PopupMenuState();
}

class __PopupMenuState extends State<_PopupMenu> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (!state.loadingStatus.isRequestInProgress &&
            !state.connectionStatus.isRequestInProgress) {
          return PopupMenuButton<HomeMenu>(
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
            ),
            tooltip: '',
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<HomeMenu>>[
                menuItem(
                  value: HomeMenu.refresh,
                  iconData: Icons.refresh,
                  title: AppLocalizations.of(context)!.reconnect,
                  onTap: () {
                    // 暫停定期更新, 避免設定過程中同時要求資訊
                    context
                        .read<HomeBloc>()
                        .add(const DevicePeriodicUpdateCanceled());
                    context.read<HomeBloc>().add(const DeviceRefreshed());
                  },
                ),
                menuItem(
                  value: HomeMenu.mode,
                  iconData: Icons.safety_divider,
                  title: state.mode == Mode.basic
                      ? AppLocalizations.of(context)!.expertMode
                      : AppLocalizations.of(context)!.basicMode,
                  onTap: () {
                    if (state.mode == Mode.basic) {
                      showEnterExpertModeDialog(context: context)
                          .then((bool? isMatch) {
                        if (isMatch != null) {
                          if (isMatch) {
                            context
                                .read<HomeBloc>()
                                .add(const ModeChanged(Mode.expert));
                          }
                        }
                      });
                    } else {
                      showToggleBasicModeDialog(context: context)
                          .then((bool? isConfirm) {
                        if (isConfirm != null) {
                          if (isConfirm) {
                            context
                                .read<HomeBloc>()
                                .add(const ModeChanged(Mode.basic));
                          }
                        }
                      });
                    }
                  },
                ),
                menuItem(
                  value: HomeMenu.theme,
                  iconData: Icons.colorize_rounded,
                  title: AppLocalizations.of(context)!.theme,
                  onTap: () {
                    showThemeOptionDialog(context: context).then(
                      (String? theme) {
                        if (theme != null) {
                          changeThemeByThemeString(
                            context: context,
                            theme: theme,
                          );
                        }
                      },
                    );
                  },
                ),
                menuItem(
                  value: HomeMenu.warmReset,
                  iconData: Icons.restart_alt_outlined,
                  title: AppLocalizations.of(context)!.warmReset,
                  enabled: state.connectionStatus.isNone ||
                          state.connectionStatus.isRequestFailure ||
                          state.loadingStatus.isNone ||
                          state.loadingStatus.isRequestFailure
                      ? false
                      : true,
                  onTap: () {
                    // 暫停定期更新, 避免設定過程中同時要求資訊
                    context
                        .read<HomeBloc>()
                        .add(const DevicePeriodicUpdateCanceled());

                    showWarmResetNoticeDialog(context: context).then(
                      (isConfirm) {
                        if (isConfirm != null && isConfirm) {
                          showWarmResetDialog(context: context).then((_) {
                            showWarmResetSuccessDialog(context: context)
                                .then((_) {
                              context
                                  .read<HomeBloc>()
                                  .add(const Data18CCorNodeRequested());
                            });
                          });
                        } else {
                          context
                              .read<HomeBloc>()
                              .add(const DevicePeriodicUpdateRequested());
                        }
                      },
                    );
                  },
                ),
                menuItem(
                  value: HomeMenu.about,
                  iconData: CustomIcons.about,
                  title: AppLocalizations.of(context)!.aboutUs,
                  onTap: () {
                    Navigator.push(
                      context,
                      About18Page.route(
                        appVersion: context
                            .read<Information18CCorNodeBloc>()
                            .state
                            .appVersion,
                      ),
                    );
                  },
                ),
              ];
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _DeviceStatus extends StatelessWidget {
  const _DeviceStatus();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.scanStatus.isRequestSuccess) {
          if (state.connectionStatus.isRequestSuccess) {
            return const Icon(
              Icons.bluetooth_connected_outlined,
            );
          } else if (state.connectionStatus.isRequestFailure) {
            return const Icon(
              Icons.nearby_error,
              color: Colors.amber,
            );
          } else {
            return const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              ),
            );
          }
        } else if (state.scanStatus.isRequestFailure) {
          return const Icon(
            Icons.nearby_error_outlined,
          );
        } else if (state.scanStatus.isRequestInProgress) {
          return const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        } else {
          return const Center();
        }
      },
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard();

  Widget getBluetoothName({
    required FormStatus scanStatus,
    required String title,
    required String name,
  }) {
    if (scanStatus == FormStatus.requestInProgress) {
      return const SizedBox(
        width: CustomStyle.diameter,
        height: CustomStyle.diameter,
        child: CircularProgressIndicator(),
      );
    } else if (scanStatus == FormStatus.requestFailure) {
      return const Text(
        'N/A',
        style: TextStyle(
          fontSize: CustomStyle.sizeL,
        ),
      );
    } else {
      return Text(
        name,
        style: const TextStyle(
          fontSize: CustomStyle.sizeL,
        ),
      );
    }
  }

  Widget bluetoothText({
    required FormStatus scanStatus,
    required String title,
    required String name,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
          ),
          getBluetoothName(
            scanStatus: scanStatus,
            title: title,
            name: name,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.connection,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              // itemLinkText(
              //   title: '',
              //   content: AppLocalizations.of(context)!.visitWebsite,
              // ),
              bluetoothText(
                scanStatus: state.scanStatus,
                title: AppLocalizations.of(context)!.bluetooth,
                name: state.device.name.isNotEmpty ? state.device.name : '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard();

  @override
  Widget build(BuildContext context) {
    // Future<void> showModuleSettingDialog({
    //   required String selectedPartId,
    // }) async {
    //   return showDialog<void>(
    //     context: context,
    //     barrierDismissible: false, // user must tap button!

    //     builder: (BuildContext context) {
    //       var width = MediaQuery.of(context).size.width;
    //       // var height = MediaQuery.of(context).size.height;

    //       return Dialog(
    //         insetPadding: EdgeInsets.symmetric(
    //           horizontal: width * 0.01,
    //         ),
    //         child:
    //         const Setting18ConfigEditPage(
    //           isShortcut: true,
    //         ),
    //       );
    //     },
    //   );
    // }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadingStatus.isRequestSuccess) {
          context.read<Information18CCorNodeBloc>().add(const ConfigLoaded());
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.shortcut,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.loadPreset,
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeL,
                        ),
                      ),
                      _LoadPresetButton(
                        loadingStatus: state.loadingStatus,
                      ),
                      // ElevatedButton(
                      //   onPressed: ,
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor:
                      //         Theme.of(context).colorScheme.primary,
                      //     foregroundColor: Colors.white,
                      //   ),
                      //   child: Text(
                      //     AppLocalizations.of(context)!.load,
                      //     style: const TextStyle(
                      //       fontSize: CustomStyle.sizeL,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoadPresetButton extends StatelessWidget {
  const _LoadPresetButton({
    required this.loadingStatus,
  });

  final FormStatus loadingStatus;

  @override
  Widget build(BuildContext context) {
    Future<void> showSelectConfigDialog({
      required List<NodeConfig> nodeConfigs,
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
            child: Informtion18CCorNodeConfigListView(
              nodeConfigs: nodeConfigs,
            ),
          );
        },
      );
    }

    return BlocBuilder<Information18CCorNodeBloc, Information18CCorNodeState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed:
              loadingStatus.isRequestSuccess && state.nodeConfigs.isNotEmpty
                  ? () async {
                      // 要進行設定前先暫停定期更新, 避免設定過程中同時要求資訊
                      context
                          .read<HomeBloc>()
                          .add(const DevicePeriodicUpdateCanceled());

                      showSelectConfigDialog(
                        nodeConfigs: state.nodeConfigs,
                      ).then((value) {
                        // 設定結束後, 恢復定期更新
                        context
                            .read<HomeBloc>()
                            .add(const DevicePeriodicUpdateCanceled());
                      });
                    }
                  : null,
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Text(
            AppLocalizations.of(context)!.align,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
          ),
        );
      },
    );
  }
}

class _BasicCard extends StatelessWidget {
  const _BasicCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.basicInformation,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              kDebugMode
                  ? itemText(
                      loadingStatus: state.loadingStatus,
                      title: 'Now DateTime',
                      content: state.characteristicData[DataKey.nowDateTime],
                    )
                  : Container(),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.typeNo,
                content: state.characteristicData[DataKey.partName],
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.partNo,
                content: state.characteristicData[DataKey.partNo],
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.serialNumber,
                content: state.characteristicData[DataKey.serialNumber],
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.firmwareVersion,
                content: state.characteristicData[DataKey.firmwareVersion],
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.hardwareVersion,
                content: state.characteristicData[DataKey.hardwareVersion],
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.logInterval,
                content: getCurrentLogInterval(
                  context: context,
                  logInterval: state.characteristicData[DataKey.logInterval],
                ),
              ),
              itemMultipleLineText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.location,
                content: state.characteristicData[DataKey.location],
              ),
              itemMultipleLineText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.coordinates,
                content: state.characteristicData[DataKey.coordinates],
              ),
              itemText(
                loadingStatus: state.loadingStatus,
                title: AppLocalizations.of(context)!.mfgDate,
                content: state.characteristicData[DataKey.mfgDate],
              ),
            ],
          ),
        ),
      );
    });
  }
}

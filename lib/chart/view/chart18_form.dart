import 'package:aci_plus_app/chart/chart/chart18_bloc/chart18_bloc.dart';
import 'package:aci_plus_app/chart/view/chart18_tab_bar.dart';
import 'package:aci_plus_app/chart/view/code_input_page.dart';
import 'package:aci_plus_app/chart/view/downloader18_page.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:aci_plus_app/setting/model/setting_wisgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

class Chart18Form extends StatefulWidget {
  const Chart18Form({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  State<Chart18Form> createState() => _Chart18FormState();
}

class _Chart18FormState extends State<Chart18Form>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> showFailureDialog(String msg) async {
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
                    getMessageLocalization(
                      msg: msg,
                      context: context,
                    ),
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

    return BlocListener<Chart18Bloc, Chart18State>(
      listener: (context, state) async {
        if (state.dataExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)!
                      .dialogMessageDataExportSuccessful,
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.open,
                  onPressed: () async {
                    OpenFilex.open(
                      state.dataExportPath,
                      type: 'application/vnd.ms-excel',
                      uti: 'com.microsoft.excel.xls',
                    ).then((OpenResult result) {
                      if (result.type == ResultType.noAppToOpen) {
                        showFailureDialog(AppLocalizations.of(context)!
                            .dialogMessageFileOpenFailed);
                      }
                    });
                  },
                ),
              ),
            );
        } else if (state.dataShareStatus.isRequestSuccess) {
          String partName = context
              .read<HomeBloc>()
              .state
              .characteristicData[DataKey.partName]!;
          String location = context
              .read<HomeBloc>()
              .state
              .characteristicData[DataKey.location]!;

          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          Share.shareXFiles(
            [XFile(state.dataExportPath)],
            subject: state.exportFileName,
            text: '$partName / $location',
            sharePositionOrigin:
                Rect.fromLTWH(0.0, height / 2, width, height / 2),
          );
        } else if (state.allDataExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)!
                      .dialogMessageDataExportSuccessful,
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.open,
                  onPressed: () async {
                    OpenFilex.open(
                      state.dataExportPath,
                      type: 'application/vnd.ms-excel',
                      uti: 'com.microsoft.excel.xls',
                    ).then((OpenResult result) {
                      if (result.type == ResultType.noAppToOpen) {
                        showFailureDialog(AppLocalizations.of(context)!
                            .dialogMessageFileOpenFailed);
                      }
                    });
                  },
                ),
              ),
            );
        } else if (state.allDataExportStatus.isRequestFailure) {
          showFailureDialog(state.errorMessage);
        } else if (state.rfLevelExportStatus == FormStatus.requestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)!
                      .dialogMessageDataExportSuccessful,
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.open,
                  onPressed: () async {
                    OpenFilex.open(
                      state.dataExportPath,
                      type: 'application/vnd.ms-excel',
                      uti: 'com.microsoft.excel.xls',
                    ).then((OpenResult result) {
                      if (result.type == ResultType.noAppToOpen) {
                        showFailureDialog(AppLocalizations.of(context)!
                            .dialogMessageFileOpenFailed);
                      }
                    });
                  },
                ),
              ),
            );
        } else if (state.rfLevelShareStatus == FormStatus.requestSuccess) {
          String partNo = context
              .read<HomeBloc>()
              .state
              .characteristicData[DataKey.partNo]!;
          String location = context
              .read<HomeBloc>()
              .state
              .characteristicData[DataKey.location]!;

          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          Share.shareXFiles(
            [XFile(state.dataExportPath)],
            subject: state.exportFileName,
            text: '$partNo / $location',
            sharePositionOrigin:
                Rect.fromLTWH(0.0, height / 2, width, height / 2),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.monitoringChart,
          ),
          centerTitle: true,
          leading: const _DeviceStatus(),
          actions: [
            _PopupMenu(
              tabController: _tabController,
            ),
          ],
        ),
        body: Chart18TabBar(
          pageController: widget.pageController,
          tabController: _tabController,
        ),
      ),
    );
  }
}

class _DeviceStatus extends StatelessWidget {
  const _DeviceStatus({super.key});

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
        } else {
          return const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}

enum DataLogMenu {
  refresh,
  share,
  export,
  downloadAll,
}

enum RFLevelMenu {
  refresh,
  share,
  export,
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

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final TabController tabController;

  Widget buildDataLogPageMenu(BuildContext context) {
    Map<DataKey, String> characteristicData =
        context.read<HomeBloc>().state.characteristicData;

    return BlocBuilder<Chart18Bloc, Chart18State>(
      builder: (context, state) {
        Future<List<dynamic>?> showDownloadDialog() async {
          return showDialog<List<dynamic>>(
            context: context,
            barrierDismissible: false, // user must tap button!

            builder: (BuildContext context) {
              return const Dialog(
                child: Downloader18Page(),
              );
            },
          );
        }

        return state.enableTabChange
            ? PopupMenuButton<DataLogMenu>(
                icon: const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.white,
                ),
                tooltip: '',
                onSelected: (DataLogMenu item) async {
                  switch (item) {
                    case DataLogMenu.refresh:
                      context.read<HomeBloc>().add(const DeviceRefreshed());
                      break;
                    case DataLogMenu.share:
                      String? code =
                          await showEnterCodeDialog(context: context);
                      if (context.mounted) {
                        if (code != null) {
                          if (code.isNotEmpty) {
                            Map<String, String> configurationData =
                                getConfigurationData(
                              context: context,
                              characteristicData: characteristicData,
                            );

                            Map<String, String> controlData = getControlData(
                              context: context,
                              characteristicData: characteristicData,
                            );

                            context.read<Chart18Bloc>().add(DataShared(
                                  code: code,
                                  configurationData: configurationData,
                                  controlData: controlData,
                                ));
                          }
                        }
                      }
                      break;
                    case DataLogMenu.export:
                      String? code =
                          await showEnterCodeDialog(context: context);
                      if (context.mounted) {
                        if (code != null) {
                          if (code.isNotEmpty) {
                            Map<String, String> configurationData =
                                getConfigurationData(
                              context: context,
                              characteristicData: characteristicData,
                            );

                            Map<String, String> controlData = getControlData(
                              context: context,
                              characteristicData: characteristicData,
                            );

                            context.read<Chart18Bloc>().add(DataExported(
                                  code: code,
                                  configurationData: configurationData,
                                  controlData: controlData,
                                ));
                          }
                        }
                      }

                      break;
                    case DataLogMenu.downloadAll:
                      String? code =
                          await showEnterCodeDialog(context: context);

                      if (code != null) {
                        if (code.isNotEmpty) {
                          List<dynamic>? resultOfDownload =
                              await showDownloadDialog();

                          if (resultOfDownload != null) {
                            bool isSuccessful = resultOfDownload[0];
                            List<Log1p8G> log1p8Gs = resultOfDownload[1];
                            String errorMessage = resultOfDownload[2];
                            if (context.mounted) {
                              Map<String, String> configurationData =
                                  getConfigurationData(
                                context: context,
                                characteristicData: characteristicData,
                              );

                              Map<String, String> controlData = getControlData(
                                context: context,
                                characteristicData: characteristicData,
                              );

                              context.read<Chart18Bloc>().add(AllDataExported(
                                    isSuccessful: isSuccessful,
                                    log1p8Gs: log1p8Gs,
                                    errorMessage: errorMessage,
                                    code: code,
                                    configurationData: configurationData,
                                    controlData: controlData,
                                  ));
                            }
                          }
                        }
                      }

                      break;
                    default:
                      break;
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<DataLogMenu>>[
                  PopupMenuItem<DataLogMenu>(
                    value: DataLogMenu.refresh,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.refresh,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(AppLocalizations.of(context)!.reconnect),
                      ],
                    ),
                  ),
                  PopupMenuItem<DataLogMenu>(
                    value: DataLogMenu.share,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.share,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(AppLocalizations.of(context)!.share),
                      ],
                    ),
                  ),
                  PopupMenuItem<DataLogMenu>(
                    value: DataLogMenu.export,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.download,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(AppLocalizations.of(context)!.export),
                      ],
                    ),
                  ),
                  PopupMenuItem<DataLogMenu>(
                    value: DataLogMenu.downloadAll,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.cloud_download_outlined,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(AppLocalizations.of(context)!.downloadAll),
                      ],
                    ),
                  ),
                ],
              )
            : Container();
      },
    );
  }

  Widget buildRFLevelPageMenu(BuildContext context) {
    return BlocBuilder<Chart18Bloc, Chart18State>(
      builder: (context, state) {
        return state.enableTabChange
            ? PopupMenuButton<RFLevelMenu>(
                icon: const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.white,
                ),
                tooltip: '',
                onSelected: (RFLevelMenu item) async {
                  switch (item) {
                    case RFLevelMenu.refresh:
                      context.read<HomeBloc>().add(const DeviceRefreshed());
                      break;
                    case RFLevelMenu.share:
                      String? code =
                          await showEnterCodeDialog(context: context);
                      if (context.mounted) {
                        if (code != null) {
                          if (code.isNotEmpty) {
                            context
                                .read<Chart18Bloc>()
                                .add(RFLevelShared(code: code));
                          }
                        }
                      }
                      break;
                    case RFLevelMenu.export:
                      String? code =
                          await showEnterCodeDialog(context: context);
                      if (context.mounted) {
                        if (code != null) {
                          if (code.isNotEmpty) {
                            context
                                .read<Chart18Bloc>()
                                .add(RFLevelExported(code: code));
                          }
                        }
                      }

                    default:
                      break;
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<RFLevelMenu>>[
                  PopupMenuItem<RFLevelMenu>(
                    value: RFLevelMenu.refresh,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.refresh,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(AppLocalizations.of(context)!.reconnect),
                      ],
                    ),
                  ),
                  PopupMenuItem<RFLevelMenu>(
                    value: RFLevelMenu.share,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.share,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(AppLocalizations.of(context)!.share),
                      ],
                    ),
                  ),
                  PopupMenuItem<RFLevelMenu>(
                    value: RFLevelMenu.export,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.download,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(AppLocalizations.of(context)!.export),
                      ],
                    ),
                  ),
                ],
              )
            : Container();
      },
    );
  }

  Map<String, String> getConfigurationData({
    required BuildContext context,
    required Map<DataKey, String> characteristicData,
  }) {
    Map<String, String> pilotFrequencyModeTexts = {
      '0': AppLocalizations.of(context)!.pilotFrequencyBandwidthSettings,
      '1': AppLocalizations.of(context)!.pilotFrequencyUserSettings,
      //  AppLocalizations.of(context)!.pilotFrequencySmartSettings,
    };

    Map<String, String> onOffTexts = {
      '0': AppLocalizations.of(context)!.on,
      '1': AppLocalizations.of(context)!.off,
    };

    String location = characteristicData[DataKey.location] ?? '';
    String coordinates = characteristicData[DataKey.coordinates] ?? '';
    String splitOption = characteristicData[DataKey.splitOption] ?? '';

    String splitOptionText = splitOption != ''
        ? '${splitBaseLine[splitOption]!.$1}/${splitBaseLine[splitOption]!.$2} ${CustomStyle.mHz}'
        : '';

    String pilotFrequencyMode =
        characteristicData[DataKey.pilotFrequencyMode] ?? '';

    String pilotFrequencyModeText = pilotFrequencyMode != ''
        ? pilotFrequencyModeTexts[pilotFrequencyMode]!
        : '';

    String firstChannelLoadingFrequency =
        characteristicData[DataKey.firstChannelLoadingFrequency] ?? '';
    String lastChannelLoadingFrequency =
        characteristicData[DataKey.lastChannelLoadingFrequency] ?? '';
    String firstChannelLoadingLevel =
        characteristicData[DataKey.firstChannelLoadingLevel] ?? '';
    String lastChannelLoadingLevel =
        characteristicData[DataKey.lastChannelLoadingLevel] ?? '';

    String pilotFrequency1 = characteristicData[DataKey.pilotFrequency1] ?? '';
    String pilotFrequency2 = characteristicData[DataKey.pilotFrequency2] ?? '';

    String manualModePilot1RFOutputPower =
        characteristicData[DataKey.manualModePilot1RFOutputPower] ?? '';
    String manualModePilot2RFOutputPower =
        characteristicData[DataKey.manualModePilot2RFOutputPower] ?? '';

    String agcMode = characteristicData[DataKey.agcMode] ?? '';
    String agcModeText = agcMode != '' ? onOffTexts[agcMode]! : '';
    String alcMode = characteristicData[DataKey.alcMode] ?? '';
    String alcModeText = alcMode != '' ? onOffTexts[alcMode]! : '';
    String logInterval = characteristicData[DataKey.logInterval] ?? '';

    Map<String, String> configurationValues = {
      AppLocalizations.of(context)!.device: '',
      AppLocalizations.of(context)!.location: location,
      AppLocalizations.of(context)!.coordinates: coordinates,
      AppLocalizations.of(context)!.splitOption: splitOptionText,
      AppLocalizations.of(context)!.pilotFrequencySelect:
          pilotFrequencyModeText,
      AppLocalizations.of(context)!.startFrequency:
          '$firstChannelLoadingFrequency ${CustomStyle.mHz}',
      AppLocalizations.of(context)!.startLevel:
          '$firstChannelLoadingLevel ${CustomStyle.dBmV}',
      AppLocalizations.of(context)!.stopFrequency:
          '$lastChannelLoadingFrequency ${CustomStyle.mHz}',
      AppLocalizations.of(context)!.stopLevel:
          '$lastChannelLoadingLevel ${CustomStyle.dBmV}',
      AppLocalizations.of(context)!.pilotFrequency1:
          '$pilotFrequency1 ${CustomStyle.mHz}',
      AppLocalizations.of(context)!.pilotLevel1:
          '$manualModePilot1RFOutputPower ${CustomStyle.dBmV}',
      AppLocalizations.of(context)!.pilotFrequency2:
          '$pilotFrequency2 ${CustomStyle.mHz}',
      AppLocalizations.of(context)!.pilotLevel2:
          '$manualModePilot2RFOutputPower ${CustomStyle.dBmV}',
      AppLocalizations.of(context)!.agcMode: agcModeText,
      AppLocalizations.of(context)!.alcMode: alcModeText,
      AppLocalizations.of(context)!.logInterval:
          '$logInterval ${AppLocalizations.of(context)!.minute}',
    };

    return configurationValues;
  }

  Map<String, String> getControlData({
    required BuildContext context,
    required Map<DataKey, String> characteristicData,
  }) {
    Map<Enum, String> controlItemTexts = {
      SettingControl.forwardInputAttenuation1:
          AppLocalizations.of(context)!.forwardInputAttenuation1,
      SettingControl.forwardInputEqualizer1:
          AppLocalizations.of(context)!.forwardInputEqualizer1,
      SettingControl.forwardOutputAttenuation2And3:
          AppLocalizations.of(context)!.forwardOutputAttenuation2And3,
      SettingControl.forwardOutputAttenuation3And4:
          AppLocalizations.of(context)!.forwardOutputAttenuation3And4,
      SettingControl.forwardOutputAttenuation5And6:
          AppLocalizations.of(context)!.forwardOutputAttenuation5And6,
      SettingControl.forwardOutputEqualizer2And3:
          AppLocalizations.of(context)!.forwardOutputEqualizer2And3,
      SettingControl.forwardOutputEqualizer5And6:
          AppLocalizations.of(context)!.forwardOutputEqualizer5And6,
      SettingControl.returnOutputAttenuation1:
          AppLocalizations.of(context)!.returnOutputAttenuation1,
      SettingControl.returnOutputEqualizer1:
          AppLocalizations.of(context)!.returnOutputEqualizer1,
      SettingControl.returnInputAttenuation2:
          AppLocalizations.of(context)!.returnInputAttenuation2,
      SettingControl.returnInputAttenuation3:
          AppLocalizations.of(context)!.returnInputAttenuation3,
      SettingControl.returnInputAttenuation4:
          AppLocalizations.of(context)!.returnInputAttenuation4,
      SettingControl.returnInputAttenuation2And3:
          AppLocalizations.of(context)!.returnInputAttenuation2And3,
      SettingControl.returnInputAttenuation5And6:
          AppLocalizations.of(context)!.returnInputAttenuation5And6,
      SettingControl.returnIngressSetting2:
          AppLocalizations.of(context)!.returnIngressSetting2,
      SettingControl.returnIngressSetting3:
          AppLocalizations.of(context)!.returnIngressSetting3,
      SettingControl.returnIngressSetting4:
          AppLocalizations.of(context)!.returnIngressSetting4,
      SettingControl.returnIngressSetting2And3:
          AppLocalizations.of(context)!.returnIngressSetting2And3,
      SettingControl.returnIngressSetting5And6:
          AppLocalizations.of(context)!.returnIngressSetting5And6,
    };

    String partId = characteristicData[DataKey.partId]!;

    Map<String, String> controlValues = {
      AppLocalizations.of(context)!.balance: '',
    };

    Map<Enum, DataKey> controlItemMap =
        SettingItemTable.controlItemDataMapCollection[partId]!;

    for (MapEntry entry in controlItemMap.entries) {
      Enum key = entry.key;
      DataKey value = entry.value;

      String controlName = controlItemTexts[key] ?? '';
      String controlValue = characteristicData[value] ?? '';
      controlValues[controlName] = controlValue;
    }

    return controlValues;
  }

  Widget getLoadingSuccessMenu(BuildContext context) {
    if (tabController.index == 0) {
      return buildDataLogPageMenu(context);
    } else if (tabController.index == 1) {
      return buildRFLevelPageMenu(context);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state.loadingStatus.isRequestSuccess) {
        return getLoadingSuccessMenu(context);
      } else {
        if (!state.loadingStatus.isRequestInProgress &&
            !state.connectionStatus.isRequestInProgress) {
          return IconButton(
              onPressed: () {
                context.read<HomeBloc>().add(const DeviceRefreshed());
              },
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onPrimary,
              ));
        } else {
          return Container();
        }
      }
    });
  }
}

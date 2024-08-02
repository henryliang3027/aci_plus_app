import 'package:aci_plus_app/chart/bloc/chart18/chart18_bloc.dart';
import 'package:aci_plus_app/chart/view/chart18_tab_bar.dart';
import 'package:aci_plus_app/chart/view/code_input_page.dart';
import 'package:aci_plus_app/chart/view/downloader18_page.dart';
import 'package:aci_plus_app/chart/view/downloader18_rf_out_page.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
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
                backgroundColor: Theme.of(context).dialogBackgroundColor,
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)!
                      .dialogMessageDataExportSuccessful,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                action: SnackBarAction(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
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
                backgroundColor: Theme.of(context).dialogBackgroundColor,
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)!
                      .dialogMessageDataExportSuccessful,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                action: SnackBarAction(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
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
                backgroundColor: Theme.of(context).dialogBackgroundColor,
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)!
                      .dialogMessageDataExportSuccessful,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                action: SnackBarAction(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
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
        body: _ViewLayout(
          pageController: widget.pageController,
          tabController: _tabController,
        ),
      ),
    );
  }
}

class _ViewLayout extends StatelessWidget {
  const _ViewLayout({
    required this.pageController,
    required this.tabController,
  });

  final PageController pageController;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadingStatus.isRequestInProgress) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Chart18TabBar(
                pageController: pageController,
                tabController: tabController,
              ),
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
          return Chart18TabBar(
            pageController: pageController,
            tabController: tabController,
          );
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
  downloadAll,
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

Future<List<dynamic>?> showDownloadDialog({
  required BuildContext context,
}) async {
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

Future<List<dynamic>?> showRFOutDownloadDialog({
  required BuildContext context,
}) async {
  return showDialog<List<dynamic>>(
    context: context,
    barrierDismissible: false, // user must tap button!

    builder: (BuildContext context) {
      return const Dialog(
        child: Downloader18RFOutPage(),
      );
    },
  );
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
        return state.enableTabChange
            ? PopupMenuButton<DataLogMenu>(
                icon: const Icon(
                  Icons.more_vert_outlined,
                ),
                tooltip: '',
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<DataLogMenu>>[
                    menuItem(
                      value: DataLogMenu.refresh,
                      iconData: Icons.refresh,
                      title: AppLocalizations.of(context)!.reconnect,
                      onTap: () {
                        context.read<HomeBloc>().add(const DeviceRefreshed());
                      },
                    ),
                    menuItem(
                      value: DataLogMenu.share,
                      iconData: Icons.share,
                      title: AppLocalizations.of(context)!.share,
                      onTap: () {
                        showEnterCodeDialog(context: context)
                            .then((String? code) {
                          if (code != null) {
                            if (code.isNotEmpty) {
                              Map<String, String> configurationData =
                                  getConfigurationData(
                                context: context,
                                characteristicData: characteristicData,
                              );

                              List<Map<String, String>> controlData =
                                  getControlData(
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
                        });
                      },
                    ),
                    menuItem(
                      value: DataLogMenu.export,
                      iconData: Icons.download,
                      title: AppLocalizations.of(context)!.export,
                      onTap: () {
                        showEnterCodeDialog(context: context)
                            .then((String? code) {
                          if (code != null) {
                            if (code.isNotEmpty) {
                              Map<String, String> configurationData =
                                  getConfigurationData(
                                context: context,
                                characteristicData: characteristicData,
                              );

                              List<Map<String, String>> controlData =
                                  getControlData(
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
                        });
                      },
                    ),
                    menuItem(
                      value: DataLogMenu.downloadAll,
                      iconData: Icons.cloud_download_outlined,
                      title: AppLocalizations.of(context)!.downloadAll,
                      onTap: () {
                        showEnterCodeDialog(context: context)
                            .then((String? code) {
                          if (code != null) {
                            if (code.isNotEmpty) {
                              showDownloadDialog(context: context)
                                  .then((List<dynamic>? resultOfDownload) {
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

                                    List<Map<String, String>> controlData =
                                        getControlData(
                                      context: context,
                                      characteristicData: characteristicData,
                                    );

                                    context
                                        .read<Chart18Bloc>()
                                        .add(AllDataExported(
                                          isSuccessful: isSuccessful,
                                          log1p8Gs: log1p8Gs,
                                          errorMessage: errorMessage,
                                          code: code,
                                          configurationData: configurationData,
                                          controlData: controlData,
                                        ));
                                  }
                                }
                              });
                            }
                          }
                        });
                      },
                    ),
                  ];
                },
              )
            : Container();
      },
    );
  }

  Widget buildRFLevelPageMenu(BuildContext context) {
    Map<DataKey, String> characteristicData =
        context.read<HomeBloc>().state.characteristicData;

    return BlocBuilder<Chart18Bloc, Chart18State>(
      builder: (context, state) {
        return state.enableTabChange
            ? PopupMenuButton<RFLevelMenu>(
                icon: const Icon(
                  Icons.more_vert_outlined,
                ),
                tooltip: '',
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<RFLevelMenu>>[
                    menuItem(
                      value: RFLevelMenu.refresh,
                      iconData: Icons.refresh,
                      title: AppLocalizations.of(context)!.reconnect,
                      onTap: () {
                        context.read<HomeBloc>().add(const DeviceRefreshed());
                      },
                    ),
                    menuItem(
                      value: RFLevelMenu.share,
                      iconData: Icons.share,
                      title: AppLocalizations.of(context)!.share,
                      onTap: () {
                        showEnterCodeDialog(context: context)
                            .then((String? code) {
                          if (code != null) {
                            if (code.isNotEmpty) {
                              Map<String, String> configurationData =
                                  getConfigurationData(
                                context: context,
                                characteristicData: characteristicData,
                              );

                              List<Map<String, String>> controlData =
                                  getControlData(
                                context: context,
                                characteristicData: characteristicData,
                              );

                              context.read<Chart18Bloc>().add(RFLevelShared(
                                    code: code,
                                    configurationData: configurationData,
                                    controlData: controlData,
                                  ));
                            }
                          }
                        });
                      },
                    ),
                    menuItem(
                      value: RFLevelMenu.export,
                      iconData: Icons.download,
                      title: AppLocalizations.of(context)!.export,
                      onTap: () {
                        showEnterCodeDialog(context: context)
                            .then((String? code) {
                          if (code != null) {
                            if (code.isNotEmpty) {
                              Map<String, String> configurationData =
                                  getConfigurationData(
                                context: context,
                                characteristicData: characteristicData,
                              );

                              List<Map<String, String>> controlData =
                                  getControlData(
                                context: context,
                                characteristicData: characteristicData,
                              );

                              context.read<Chart18Bloc>().add(RFLevelExported(
                                    code: code,
                                    configurationData: configurationData,
                                    controlData: controlData,
                                  ));
                            }
                          }
                        });
                      },
                    ),
                    menuItem(
                      value: RFLevelMenu.downloadAll,
                      iconData: Icons.cloud_download_outlined,
                      title: AppLocalizations.of(context)!.downloadAll,
                      onTap: () {
                        showEnterCodeDialog(context: context)
                            .then((String? code) {
                          if (code != null) {
                            if (code.isNotEmpty) {
                              showRFOutDownloadDialog(context: context)
                                  .then((List<dynamic>? resultOfDownload) {
                                if (resultOfDownload != null) {
                                  bool isSuccessful = resultOfDownload[0];
                                  List<RFOutputLog> rfOutputLog1p8Gs =
                                      resultOfDownload[1];
                                  String errorMessage = resultOfDownload[2];
                                  if (context.mounted) {
                                    Map<String, String> configurationData =
                                        getConfigurationData(
                                      context: context,
                                      characteristicData: characteristicData,
                                    );

                                    List<Map<String, String>> controlData =
                                        getControlData(
                                      context: context,
                                      characteristicData: characteristicData,
                                    );

                                    context
                                        .read<Chart18Bloc>()
                                        .add(AllRFOutputLogExported(
                                          isSuccessful: isSuccessful,
                                          rfOutputLog1p8Gs: rfOutputLog1p8Gs,
                                          errorMessage: errorMessage,
                                          code: code,
                                          configurationData: configurationData,
                                          controlData: controlData,
                                        ));
                                  }
                                }
                              });
                            }
                          }
                        });
                      },
                    ),
                  ];
                },
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
      '0': AppLocalizations.of(context)!.off,
      '1': AppLocalizations.of(context)!.on,
    };

    String location = characteristicData[DataKey.location] ?? '';
    String coordinates = characteristicData[DataKey.coordinates] ?? '';
    String splitOption = characteristicData[DataKey.splitOption] ?? '';

    String splitValue1 = splitBaseLine[splitOption]?.$1 != null
        ? splitBaseLine[splitOption]!.$1.toString()
        : 'N/A';
    String splitValue2 = splitBaseLine[splitOption]?.$2 != null
        ? splitBaseLine[splitOption]!.$2.toString()
        : 'N/A';

    String splitOptionText =
        splitOption != '' ? '$splitValue1/$splitValue2 ${CustomStyle.mHz}' : '';

    String pilotFrequencyMode =
        characteristicData[DataKey.pilotFrequencyMode] ?? '';

    String pilotFrequencyModeText = pilotFrequencyMode != ''
        ? pilotFrequencyModeTexts[pilotFrequencyMode] ?? 'N/A'
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
    // String alcMode = characteristicData[DataKey.alcMode] ?? '';
    // String alcModeText = alcMode != '' ? onOffTexts[alcMode]! : '';
    String logInterval = characteristicData[DataKey.logInterval] ?? '';
    String rfOutputLogInterval =
        characteristicData[DataKey.rfOutputLogInterval] ?? '';

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
      // AppLocalizations.of(context)!.alcMode: alcModeText,
      AppLocalizations.of(context)!.logInterval:
          '$logInterval ${AppLocalizations.of(context)!.minute}',
      AppLocalizations.of(context)!.rfOutputLogInterval:
          '$rfOutputLogInterval ${AppLocalizations.of(context)!.minute}',
    };

    return configurationValues;
  }

  String getInputAttenuation({
    required String alcMode,
    required String inputAttenuation,
    required String currentInputAttenuation,
  }) {
    return alcMode == '0' ? inputAttenuation : currentInputAttenuation;
  }

  String getInputEqualizer({
    required String alcMode,
    required String agcMode,
    required String inputEqualizer,
    required String currentInputEqualizer,
  }) {
    return alcMode == '0' && agcMode == '0'
        ? inputEqualizer
        : currentInputEqualizer;
  }

  List<Map<String, String>> getControlData({
    required BuildContext context,
    required Map<DataKey, String> characteristicData,
  }) {
    Map<String, String> ingressSettingTexts = {
      '0': '0${CustomStyle.dB}',
      '1': '-3${CustomStyle.dB}',
      '2': '-6${CustomStyle.dB}',
      '4': AppLocalizations.of(context)!.ingressOpen,
    };

    Map<Enum, String> controlItemTexts = {
      SettingControl.forwardInputAttenuation1:
          AppLocalizations.of(context)!.forwardInputAttenuation1,
      SettingControl.forwardInputEqualizer1:
          AppLocalizations.of(context)!.forwardInputEqualizer1,
      SettingControl.forwardOutputAttenuation3:
          AppLocalizations.of(context)!.forwardOutputAttenuation3,
      SettingControl.forwardOutputAttenuation4:
          AppLocalizations.of(context)!.forwardOutputAttenuation4,
      SettingControl.forwardOutputAttenuation2And3:
          AppLocalizations.of(context)!.forwardOutputAttenuation2And3,
      SettingControl.forwardOutputAttenuation3And4:
          AppLocalizations.of(context)!.forwardOutputAttenuation3And4,
      SettingControl.forwardOutputAttenuation5And6:
          AppLocalizations.of(context)!.forwardOutputAttenuation5And6,
      SettingControl.forwardOutputEqualizer3:
          AppLocalizations.of(context)!.forwardOutputEqualizer3,
      SettingControl.forwardOutputEqualizer4:
          AppLocalizations.of(context)!.forwardOutputEqualizer4,
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

    List<Map<String, String>> controlValues = [
      {
        AppLocalizations.of(context)!.balance: '',
      }
    ];

    Map<Enum, DataKey> forwardControlItemMap =
        SettingItemTable.controlItemDataMapCollection[partId]![0];

    Map<Enum, DataKey> returnControlItemMap =
        SettingItemTable.controlItemDataMapCollection[partId]![1];

    controlValues
        .add({AppLocalizations.of(context)!.forwardControlParameters: ''});

    for (MapEntry entry in forwardControlItemMap.entries) {
      Enum key = entry.key;
      DataKey value = entry.value;

      String controlName = controlItemTexts[key] ?? '';
      String controlValue = characteristicData[value] ?? '';

      String alcMode = characteristicData[DataKey.alcMode]!;
      String agcMode = characteristicData[DataKey.agcMode]!;

      if (key.name == SettingControl.forwardInputAttenuation1.name) {
        controlValue = getInputAttenuation(
          alcMode: alcMode,
          inputAttenuation: controlValue,
          currentInputAttenuation:
              characteristicData[DataKey.currentDSVVA1] ?? '',
        );
      }

      if (key.name == SettingControl.forwardInputEqualizer1.name) {
        controlValue = getInputEqualizer(
          alcMode: alcMode,
          agcMode: agcMode,
          inputEqualizer: controlValue,
          currentInputEqualizer:
              characteristicData[DataKey.currentDSSlope1] ?? '',
        );
      }

      controlValue = '$controlValue ${CustomStyle.dB}';

      controlValues.add({controlName: controlValue});
    }

    controlValues
        .add({AppLocalizations.of(context)!.returnControlParameters: ''});

    for (MapEntry entry in returnControlItemMap.entries) {
      Enum key = entry.key;
      DataKey value = entry.value;

      String controlName = controlItemTexts[key] ?? '';
      String controlValue = characteristicData[value] ?? '';

      if (value.name.startsWith('ingressSetting')) {
        controlValue = ingressSettingTexts[controlValue] ?? '';
      } else {
        controlValue = '$controlValue ${CustomStyle.dB}';
      }

      controlValues.add({controlName: controlValue});
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

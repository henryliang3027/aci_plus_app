import 'package:aci_plus_app/chart/bloc/chart18/chart18_bloc.dart';
import 'package:aci_plus_app/chart/shared/share_file_widget.dart';
import 'package:aci_plus_app/chart/view/chart18_tab_bar.dart';
import 'package:aci_plus_app/chart/view/code_input_page.dart';
import 'package:aci_plus_app/chart/view/downloader18_page.dart';
import 'package:aci_plus_app/chart/view/downloader18_rf_out_page.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/core/notice_dialog.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_filex/open_filex.dart';

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
    HomeState homeState = context.read<HomeBloc>().state;
    if (homeState.loadingStatus.isRequestSuccess) {
      checkUnfilledItem(
        context: context,
        characteristicData: homeState.characteristicData,
      );
    }

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

          openShareFileWidget(
            context: context,
            subject: state.exportFileName,
            body: '$partName / $location',
            attachmentPath: state.dataExportPath,
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
          context.read<HomeBloc>().add(const DevicePeriodicUpdateRequested());
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

          openShareFileWidget(
            context: context,
            subject: state.exportFileName,
            body: '$partName / $location',
            attachmentPath: state.dataExportPath,
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
                              context.read<Chart18Bloc>().add(DataShared(
                                    code: code,
                                  ));
                            }
                          }
                        });
                      },
                      enabled: winBeta >= 3 ? true : false,
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
                              context.read<Chart18Bloc>().add(DataExported(
                                    code: code,
                                  ));
                            }
                          }
                        });
                      },
                      enabled: winBeta >= 2 ? true : false,
                    ),
                    menuItem(
                      value: DataLogMenu.downloadAll,
                      iconData: Icons.cloud_download_outlined,
                      title: AppLocalizations.of(context)!.downloadAll,
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .add(const DevicePeriodicUpdateCanceled());

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
                                    context
                                        .read<Chart18Bloc>()
                                        .add(AllDataExported(
                                          isSuccessful: isSuccessful,
                                          log1p8Gs: log1p8Gs,
                                          errorMessage: errorMessage,
                                          code: code,
                                        ));
                                  }
                                }
                              });
                            }
                          } else {
                            context
                                .read<HomeBloc>()
                                .add(const DevicePeriodicUpdateRequested());
                          }
                        });
                      },
                      enabled: winBeta >= 2 ? true : false,
                    ),
                  ];
                },
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
                              context.read<Chart18Bloc>().add(RFLevelShared(
                                    code: code,
                                  ));
                            }
                          }
                        });
                      },
                      enabled: winBeta >= 3 ? true : false,
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
                              context.read<Chart18Bloc>().add(RFLevelExported(
                                    code: code,
                                  ));
                            }
                          }
                        });
                      },
                      enabled: winBeta >= 2 ? true : false,
                    ),
                    menuItem(
                      value: RFLevelMenu.downloadAll,
                      iconData: Icons.cloud_download_outlined,
                      title: AppLocalizations.of(context)!.downloadAll,
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .add(const DevicePeriodicUpdateCanceled());
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
                                    context
                                        .read<Chart18Bloc>()
                                        .add(AllRFOutputLogExported(
                                          isSuccessful: isSuccessful,
                                          rfOutputLog1p8Gs: rfOutputLog1p8Gs,
                                          errorMessage: errorMessage,
                                          code: code,
                                        ));
                                  }
                                }
                              });
                            }
                          } else {
                            context
                                .read<HomeBloc>()
                                .add(const DevicePeriodicUpdateRequested());
                          }
                        });
                      },
                      enabled: winBeta >= 2 ? true : false,
                    ),
                  ];
                },
              )
            : Container();
      },
    );
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

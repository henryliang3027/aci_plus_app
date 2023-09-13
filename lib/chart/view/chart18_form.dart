import 'package:dsim_app/chart/chart/chart18_bloc/chart18_bloc.dart';
import 'package:dsim_app/chart/view/chart18_tab_bar.dart';
import 'package:dsim_app/chart/view/linear_progress_bar.dart';
import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

class Chart18Form extends StatelessWidget {
  const Chart18Form({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<Chart18Bloc, Chart18State>(
      listener: (context, state) {
        if (state.dataExportStatus.isRequestSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 30),
                content: Text(
                  AppLocalizations.of(context)
                      .dialogMessageDataExportSuccessful,
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context).open,
                  onPressed: () async {
                    OpenResult result = await OpenFilex.open(
                      state.dataExportPath,
                      type: 'application/vnd.ms-excel',
                      uti: 'com.microsoft.excel.xls',
                    );
                    print(result.message);
                  },
                ),
              ),
            );
        } else if (state.dataShareStatus.isRequestSuccess) {
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
            AppLocalizations.of(context).monitoringChart,
          ),
          centerTitle: true,
          leading: const _DeviceStatus(),
          actions: const [
            _PopupMenu(),
          ],
        ),
        body: const Chart18TabBar(),
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

enum Menu {
  refresh,
  share,
  export,
  downloadAll,
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> showInProgressDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).dialogTitleProcessing,
            ),
            actionsAlignment: MainAxisAlignment.center,
            content: const CustomLinearProgressIndicator(),
            // actions: const <Widget>[
            //   CustomLinearProgressIndicator(),
            // ],
          );
        },
      );
    }

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state.loadingStatus.isRequestSuccess) {
        return PopupMenuButton<Menu>(
          icon: const Icon(
            Icons.more_vert_outlined,
            color: Colors.white,
          ),
          tooltip: '',
          onSelected: (Menu item) async {
            switch (item) {
              case Menu.refresh:
                context.read<HomeBloc>().add(const DeviceRefreshed());
              case Menu.share:
                context.read<Chart18Bloc>().add(const DataShared());
                break;
              case Menu.export:
                context.read<Chart18Bloc>().add(const DataExported());
                break;
              case Menu.downloadAll:
                showInProgressDialog();
              // context.read<Chart18Bloc>().add(const DataExported());
              default:
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
            PopupMenuItem<Menu>(
              value: Menu.refresh,
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
                  Text(AppLocalizations.of(context).reconnect),
                ],
              ),
            ),
            PopupMenuItem<Menu>(
              value: Menu.share,
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
                  Text(AppLocalizations.of(context).share),
                ],
              ),
            ),
            PopupMenuItem<Menu>(
              value: Menu.export,
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
                  Text(AppLocalizations.of(context).export),
                ],
              ),
            ),
            PopupMenuItem<Menu>(
              value: Menu.downloadAll,
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
                  Text(AppLocalizations.of(context).downloadAll),
                ],
              ),
            ),
          ],
        );
      } else {
        if (!state.connectionStatus.isRequestInProgress) {
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

import 'package:aci_plus_app/advanced/bloc/setting18_firmware_log/setting18_firmware_log_bloc.dart';
import 'package:aci_plus_app/chart/shared/message_dialog.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_filex/open_filex.dart';

class Setting18FirmwareLogForm extends StatelessWidget {
  const Setting18FirmwareLogForm({super.key});

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.read<HomeBloc>().state;

    String partId = homeState.characteristicData[DataKey.partId] ?? '';

    int firmwareVersion = convertFirmwareVersionStringToInt(
        homeState.characteristicData[DataKey.firmwareVersion] ?? '0');

    // CCor Node 的 firmware version 148 開始有屬性設定功能, 但是暫時不 release
    if (partId != '4') {
      if (firmwareVersion >= 148) {
        handleUpdateAction(
          context: context,
          targetBloc: context.read<Setting18FirmwareLogBloc>(),
          action: () {
            context
                .read<Setting18FirmwareLogBloc>()
                .add(const UpdateLogRequested());
          },
          waitForState: (state) {
            Setting18FirmwareLogState setting18firmwareLogState =
                state as Setting18FirmwareLogState;

            return setting18firmwareLogState.updateLogStatus.isRequestSuccess ||
                setting18firmwareLogState.updateLogStatus.isRequestFailure;
          },
        );
      }
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

    return BlocListener<Setting18FirmwareLogBloc, Setting18FirmwareLogState>(
      listener: (context, state) {
        if (state.updateLogExportStatus.isRequestSuccess) {
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
                      state.updateLogExportPath,
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
        } else if (state.updateLogStatus.isRequestFailure) {
          showFailureDialog(state.errorMessage);
        }
      },
      child: Scaffold(
        body: const _UpdateLogsSliverList(),
        floatingActionButton:
            _UpdateLogFloatingActionButton(firmwareVersion: firmwareVersion),
      ),
    );
  }
}

SliverChildBuilderDelegate _alarmSliverChildBuilderDelegate(
  List<UpdateLog> updateLogs,
) {
  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      UpdateLog updateLog = updateLogs[index];

      return Container(
        decoration: BoxDecoration(
          color: index.isEven
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).brightness == Brightness.light
                  ? CustomStyle.customSecondaryTileColor
                  : CustomStyle.customDeepSecondaryLileColor,
          border: const Border(
              bottom: BorderSide(
            color: Colors.grey,
          )),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                      child: Text(
                        updateLog.type == UpdateType.upgrade
                            ? AppLocalizations.of(context)!.upgrade
                            : AppLocalizations.of(context)!.downgrade,
                        //maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeXL,
                          // color: Theme.of(context).colorScheme.primary,
                          //fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                      child: Text(
                        '${AppLocalizations.of(context)!.firmwareVersion}: ${updateLog.firmwareVersion}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            // fontSize: CustomStyle.sizeS,
                            //fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 6.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.technicianID}: ${updateLog.technicianID}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                // fontSize: CustomStyle.sizeS,
                                //fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            updateLog.formatDateTime(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                // fontSize: CustomStyle.sizeS,
                                //fontWeight: FontWeight.w500,
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
      );
    },
    childCount: updateLogs.length,
  );
}

class _UpdateLogsSliverList extends StatelessWidget {
  const _UpdateLogsSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Setting18FirmwareLogBloc, Setting18FirmwareLogState>(
      listener: (context, state) {
        if (state.updateLogStatus.isRequestFailure) {
          showFailureDialog(
            context: context,
            msg: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        if (state.updateLogStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.updateLogStatus.isRequestSuccess) {
          return state.updateLogs.isNotEmpty
              ? Scrollbar(
                  thickness: 8.0,
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: _alarmSliverChildBuilderDelegate(
                          state.updateLogs,
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(AppLocalizations.of(context)!.noMoreRecordToShow),
                );
        } else {
          return Center(
            child: Text(AppLocalizations.of(context)!.noMoreRecordToShow),
          );
        }
      },
    );
  }
}

class _UpdateLogFloatingActionButton extends StatelessWidget {
  const _UpdateLogFloatingActionButton({
    required this.firmwareVersion,
  });

  final int firmwareVersion;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final HomeState homeState = context.watch<HomeBloc>().state;
        final Setting18FirmwareLogState setting18FirmwareLogState =
            context.watch<Setting18FirmwareLogBloc>().state;

        bool enabled = homeState.loadingStatus.isRequestSuccess &&
            setting18FirmwareLogState.updateLogStatus.isRequestSuccess;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (firmwareVersion >= 148) ...[
              if (kDebugMode) ...[
                FloatingActionButton(
                  heroTag: null,
                  shape: const CircleBorder(
                    side: BorderSide.none,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withAlpha(200),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    context
                        .read<Setting18FirmwareLogBloc>()
                        .add(const TestUpdateLogRequested());
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  heroTag: null,
                  shape: const CircleBorder(
                    side: BorderSide.none,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withAlpha(200),
                  child: Icon(
                    Icons.delete_forever_outlined,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    context
                        .read<Setting18FirmwareLogBloc>()
                        .add(const TestAllUpdateLogDeleted());
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
              FloatingActionButton(
                heroTag: null,
                shape: const CircleBorder(
                  side: BorderSide.none,
                ),
                backgroundColor: enabled
                    ? Theme.of(context).colorScheme.primary.withAlpha(200)
                    : Colors.grey.withAlpha(200),
                onPressed: enabled
                    ? () {
                        context
                            .read<Setting18FirmwareLogBloc>()
                            .add(const UpdateLogExported());
                      }
                    : null,
                child: Icon(
                  Icons.download,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

// class _TestLogFloatingActionButton extends StatelessWidget {
//   const _TestLogFloatingActionButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         FloatingActionButton(
//           heroTag: null,
//           shape: const CircleBorder(
//             side: BorderSide.none,
//           ),
//           backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
//           child: Icon(
//             Icons.add,
//             color: Theme.of(context).colorScheme.onPrimary,
//           ),
//           onPressed: () {
//             context
//                 .read<Setting18FirmwareLogBloc>()
//                 .add(const TestUpdateLogRequested());
//           },
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         FloatingActionButton(
//           heroTag: null,
//           shape: const CircleBorder(
//             side: BorderSide.none,
//           ),
//           backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
//           child: Icon(
//             Icons.delete_forever_outlined,
//             color: Theme.of(context).colorScheme.onPrimary,
//           ),
//           onPressed: () {
//             context
//                 .read<Setting18FirmwareLogBloc>()
//                 .add(const TestAllUpdateLogDeleted());
//           },
//         ),
//       ],
//     );
//   }
// }

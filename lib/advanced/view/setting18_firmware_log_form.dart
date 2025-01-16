import 'package:aci_plus_app/advanced/bloc/setting18_firmware_log/setting18_firmware_log_bloc.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18FirmwareLogForm extends StatelessWidget {
  const Setting18FirmwareLogForm({super.key});

  @override
  Widget build(BuildContext context) {
    HomeState homeState = context.read<HomeBloc>().state;

    int firmwareVersion = convertFirmwareVersionStringToInt(
        homeState.characteristicData[DataKey.firmwareVersion] ?? '0');

    if (firmwareVersion >= 148) {
      context.read<Setting18FirmwareLogBloc>().add(const UpdateLogRequested());
    }
    return Scaffold(
      body: const _UpdateLogsSliverList(),
      floatingActionButton: kDebugMode && firmwareVersion >= 148
          ? const _TestLogFloatingActionButton()
          : null,
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
    return BlocBuilder<Setting18FirmwareLogBloc, Setting18FirmwareLogState>(
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

class _TestLogFloatingActionButton extends StatelessWidget {
  const _TestLogFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: null,
          shape: const CircleBorder(
            side: BorderSide.none,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
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
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
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
      ],
    );
  }
}

import 'package:aci_plus_app/advanced/bloc/setting18_firmware_log/setting18_firmware_log_bloc.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:flutter/material.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18FirmwareLogForm extends StatelessWidget {
  const Setting18FirmwareLogForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _UpdateLogsSliverList(),
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
                        '${AppLocalizations.of(context)!.firmwareVersion}: ${updateLog.version}',
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
                            updateLog.datetime,
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_rounded,
                size: 200,
                color: Color(0xffffc107),
              ),
              Text(
                getMessageLocalization(
                  msg: state.message,
                  context: context,
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          );
        }
      },
    );
  }
}

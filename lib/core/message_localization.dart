import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getMessageLocalization({
  required String msg,
  required BuildContext context,
}) {
  if (msg == 'Device not found.') {
    return AppLocalizations.of(context)!.dialogMessageDeviceNotFound;
  } else if (msg == 'Bluetooth is disabled.') {
    return AppLocalizations.of(context)!.dialogMessageBluetoothDisabled;
  } else if (msg == 'Device connection failed') {
    return AppLocalizations.of(context)!.dialogMessageConnectionFailure;
  } else if (msg == 'Failed to load data') {
    return AppLocalizations.of(context)!.dialogMessageLoadDataFailure;
  } else if (msg == 'Failed to load logs') {
    return AppLocalizations.of(context)!.dialogMessageLoadLogFailure;
  } else if (msg == 'Failed to download logs') {
    return AppLocalizations.of(context)!.dialogMessageDownloadLogFailure;
  } else if (msg == 'Failed to load events') {
    return AppLocalizations.of(context)!.dialogMessageLoadEventFailure;
  } else if (msg == 'Failed to initialize the log interval.') {
    return AppLocalizations.of(context)!
        .dialogMessageAutoSettingLogIntervalFailed;
  } else if (msg ==
      'Location services are disabled. Please enable location services.') {
    return AppLocalizations.of(context)!.dialogMessageGPSServiceDisabled;
  } else if (msg ==
      'Location permissions are denied. Please provide permission.') {
    return AppLocalizations.of(context)!.dialogMessageGPSPermissionDenied;
  } else if (msg == 'Preset data not found, please add new preset profiles.') {
    return AppLocalizations.of(context)!.dialogMessageDefaultConfigNotFound;
  } else if (msg == 'The file you selected is invalid') {
    return AppLocalizations.of(context)!.dialogMessageSelectedFirmwareInvalid;
  } else {
    return msg;
  }
}

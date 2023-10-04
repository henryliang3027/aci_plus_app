import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getMessageLocalization({
  required String msg,
  required BuildContext context,
}) {
  if (msg == 'Device not found.') {
    return AppLocalizations.of(context).dialogMessageDeviceNotFound;
  } else if (msg == 'Bluetooth is disabled.') {
    return AppLocalizations.of(context).dialogMessageBluetoothDisabled;
  } else if (msg == 'Device connection failed') {
    return AppLocalizations.of(context).dialogMessageConnectionFailure;
  } else if (msg == 'Data loading failed') {
    return AppLocalizations.of(context).dialogMessageLoadingDataFailure;
  } else if (msg ==
      'Location services are disabled. Please enable location services.') {
    return AppLocalizations.of(context).dialogMessageGPSServiceDisabled;
  } else if (msg ==
      'Location permissions are denied. Please provide permission.') {
    return AppLocalizations.of(context).dialogMessageGPSPermissionDenied;
  } else {
    return msg;
  }
}

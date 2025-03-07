import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/setup_wizard_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showProgressingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by clicking outside
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Widget getDeviceSettingSetupWizard({
  required BuildContext context,
}) {
  return FloatingActionButton(
    heroTag: null,
    shape: const CircleBorder(
      side: BorderSide.none,
    ),
    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
    onPressed: () {
      showSetupWizardDialog(
        context: context,
        functionDescriptionType: FunctionDescriptionType.deviceSetting,
        aciDeviceType: ACIDeviceType.amp1P8G,
      );
    },
    child: Icon(
      CustomIcons.information,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}

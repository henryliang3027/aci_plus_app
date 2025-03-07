import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/setup_wizard_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget getConfigureSetupWizard({
  required BuildContext context,
  required ACIDeviceType aciDeviceType,
}) {
  return FloatingActionButton(
    // heroTag is used to solve exception: There are multiple heroes that share the same tag within a subtree.
    heroTag: null,
    shape: const CircleBorder(
      side: BorderSide.none,
    ),
    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
    onPressed: () {
      showSetupWizardDialog(
        context: context,
        functionDescriptionType: FunctionDescriptionType.device,
        aciDeviceType: aciDeviceType,
      );
    },
    child: Icon(
      CustomIcons.information,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}

Widget getThresholdSetupWizard({
  required BuildContext context,
  required ACIDeviceType aciDeviceType,
}) {
  return FloatingActionButton(
    // heroTag is used to solve exception: There are multiple heroes that share the same tag within a subtree.
    heroTag: null,
    shape: const CircleBorder(
      side: BorderSide.none,
    ),
    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
    onPressed: () {
      showSetupWizardDialog(
        context: context,
        functionDescriptionType: FunctionDescriptionType.threshold,
        aciDeviceType: aciDeviceType,
      );
    },
    child: Icon(
      CustomIcons.information,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}

Widget getControlSetupWizard({
  required BuildContext context,
  required ACIDeviceType aciDeviceType,
}) {
  return FloatingActionButton(
    // heroTag is used to solve exception: There are multiple heroes that share the same tag within a subtree.
    heroTag: null,
    shape: const CircleBorder(
      side: BorderSide.none,
    ),
    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
    onPressed: () {
      showSetupWizardDialog(
        context: context,
        functionDescriptionType: FunctionDescriptionType.balance,
        aciDeviceType: aciDeviceType,
      );
    },
    child: Icon(
      CustomIcons.information,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}

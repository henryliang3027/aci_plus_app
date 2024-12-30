import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/setup_wizard_dialog.dart';
import 'package:flutter/material.dart';

Widget getDataLogChartSetupWizard({
  required BuildContext context,
}) {
  return FloatingActionButton(
    heroTag: null,
    shape: const CircleBorder(
      side: BorderSide.none,
    ),
    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
    onPressed: () {
      showSetupWizardDialog(context, FunctionDescriptionType.dataLog);
    },
    child: Icon(
      CustomIcons.information,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}

Widget getRFLevelChartSetupWizard({
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
        context,
        FunctionDescriptionType.rfLevel,
      );
    },
    child: Icon(
      CustomIcons.information,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}

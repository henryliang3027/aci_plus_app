import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<String> getUnFilledItemNameAndDescriptions({
  required BuildContext context,
  required List<DataKey> unFilledItems,
}) {
  List<String> unFilledItemNames = [];
  for (DataKey dataKey in unFilledItems) {
    if (dataKey == DataKey.agcMode) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.agcMode},${AppLocalizations.of(context)!.dialogMessageItemAGCDisabled}');
    } else if (dataKey == DataKey.location) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.location},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.coordinates) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.coordinates},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.technicianID) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.technicianID},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.inputSignalLevel) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.inputSignalLevel},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.inputAttenuation) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.inputAttenuation},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.inputEqualizer) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.inputEqualizer},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.cascadePosition) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.cascadePosition},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else if (dataKey == DataKey.deviceName) {
      unFilledItemNames.add(
          '${AppLocalizations.of(context)!.deviceName},${AppLocalizations.of(context)!.dialogMessageItemUnFilled}');
    } else {}
  }

  return unFilledItemNames;
}

List<DataKey> getUnFilledItem({
  required BuildContext context,
  required Map<DataKey, String> characteristicData,
}) {
  String agcMode = characteristicData[DataKey.agcMode] ?? '';
  String location = characteristicData[DataKey.location] ?? '';
  String coordinate = characteristicData[DataKey.coordinates] ?? '';
  String technicianID = characteristicData[DataKey.technicianID] ?? '';
  String inputSignalLevel = characteristicData[DataKey.inputSignalLevel] ?? '';
  String inputAttenuation = characteristicData[DataKey.inputAttenuation] ?? '';
  String inputEqualizer = characteristicData[DataKey.inputEqualizer] ?? '';
  String cascadePosition = characteristicData[DataKey.cascadePosition] ?? '';
  String deviceName = characteristicData[DataKey.deviceName] ?? '';

  List<DataKey> unFilledItems = [];

  if (agcMode.isEmpty || agcMode == '0') {
    unFilledItems.add(DataKey.agcMode);
  }
  if (location.isEmpty) {
    unFilledItems.add(DataKey.location);
  }
  if (coordinate.isEmpty) {
    unFilledItems.add(DataKey.coordinates);
  }
  if (technicianID.isEmpty) {
    unFilledItems.add(DataKey.technicianID);
  }
  if (inputSignalLevel.isEmpty) {
    unFilledItems.add(DataKey.inputSignalLevel);
  }
  if (inputAttenuation.isEmpty) {
    unFilledItems.add(DataKey.inputAttenuation);
  }
  if (inputEqualizer.isEmpty) {
    unFilledItems.add(DataKey.inputEqualizer);
  }
  if (cascadePosition.isEmpty) {
    unFilledItems.add(DataKey.cascadePosition);
  }
  if (deviceName.isEmpty) {
    unFilledItems.add(DataKey.deviceName);
  }

  return unFilledItems;
}

List<Widget> getMessageRows({
  required BuildContext context,
  required List<DataKey> unFilledItems,
}) {
  List<String> unFilledItemNameAndDescriptions =
      getUnFilledItemNameAndDescriptions(
    context: context,
    unFilledItems: unFilledItems,
  );
  List<Widget> rows = [];
  for (String unFilledItemName in unFilledItemNameAndDescriptions) {
    String itemName = unFilledItemName.split(',')[0];
    String itemDescription = unFilledItemName.split(',')[1];

    rows.add(Padding(
      padding: const EdgeInsets.only(
        bottom: 14.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              itemName,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            itemDescription,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
              color: Colors.red,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    ));
  }
  return rows;
}

Future<void> showUnfilledItemDialog({
  required BuildContext context,
  required List<DataKey> unFilledItems,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      var width = MediaQuery.of(context).size.width;
      // var height = MediaQuery.of(context).size.height;

      List<Widget> messageRows = getMessageRows(
        context: context,
        unFilledItems: unFilledItems,
      );

      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: width * 0.08,
        ),
        title: Text(
          AppLocalizations.of(context)!.dialogTitleNotice,
        ),
        content: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: ListBody(
              children: messageRows,
            ),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              AppLocalizations.of(context)!.dialogMessageOk,
            ),
            onPressed: () {
              Navigator.of(context).pop(true); // pop dialog
            },
          ),
        ],
      );
    },
  );
}

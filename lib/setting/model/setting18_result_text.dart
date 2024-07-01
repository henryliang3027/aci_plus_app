import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String formatResultValue({
  required BuildContext context,
  required String boolValue,
}) {
  return boolValue == 'true'
      ? AppLocalizations.of(context)!.dialogMessageSuccessful
      : AppLocalizations.of(context)!.dialogMessageFailed;
}

String format1P8GSettingResultItem({
  required BuildContext context,
  required String partId,
  required String item,
}) {
  if (item == DataKey.dsVVA1.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardInputAttenuation1Setting;
  } else if (item == DataKey.dsVVA4.name) {
    if (partId == '5' || partId == '6') {
      return AppLocalizations.of(context)!
          .dialogMessageForwardOutputAttenuation2And3Setting;
    } else if (partId == '8') {
      return AppLocalizations.of(context)!
          .dialogMessageForwardOutputAttenuation3Setting;
    } else {
      return AppLocalizations.of(context)!
          .dialogMessageForwardOutputEqualizer3And4Setting;
    }
  } else if (item == DataKey.dsVVA5.name) {
    if (partId == '5') {
      return AppLocalizations.of(context)!
          .dialogMessageForwardOutputAttenuation5And6Setting;
    } else {
      // SDAT
      return AppLocalizations.of(context)!
          .dialogMessageForwardOutputAttenuation4Setting;
    }
  } else if (item == DataKey.dsSlope1.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardInputEqualizer1Setting;
  } else if (item == DataKey.dsSlope3.name) {
    if (partId == '8') {
      return AppLocalizations.of(context)!
          .dialogMessageForwardOutputEqualizer3Setting;
    } else {
      // C-Cor TR, C-Cor BR
      return AppLocalizations.of(context)!
          .dialogMessageForwardOutputEqualizer2And3Setting;
    }
  } else if (item == DataKey.dsSlope4.name) {
    if (partId == '8') {
      return AppLocalizations.of(context)!
          .dialogMessageForwardOutputEqualizer4Setting;
    } else {
      // C-Cor TR, C-Cor BR
      return AppLocalizations.of(context)!
          .dialogMessageForwardOutputEqualizer5And6Setting;
    }
  } else if (item == DataKey.tgcCableLength.name) {
    return AppLocalizations.of(context)!.dialogMessageTGCCableLengthSetting;
  } else if (item == DataKey.usVCA1.name) {
    return AppLocalizations.of(context)!
        .dialogMessageReturnInputAttenuation2Setting;
  } else if (item == DataKey.usVCA2.name) {
    return AppLocalizations.of(context)!
        .dialogMessageReturnOutputAttenuation1Setting;
  } else if (item == DataKey.usVCA3.name) {
    if (partId == '5' || partId == '6') {
      return AppLocalizations.of(context)!
          .dialogMessageReturnInputAttenuation2And3Setting;
    } else {
      return AppLocalizations.of(context)!
          .dialogMessageReturnInputAttenuation3Setting;
    }
  } else if (item == DataKey.usVCA4.name) {
    if (partId == '5' || partId == '6') {
      return AppLocalizations.of(context)!
          .dialogMessageReturnInputAttenuation5And6Setting;
    } else {
      return AppLocalizations.of(context)!
          .dialogMessageReturnInputAttenuation4Setting;
    }
  } else if (item == DataKey.eREQ.name) {
    return AppLocalizations.of(context)!
        .dialogMessageReturnOutputEqualizer1Setting;
  } else if (item == DataKey.ingressSetting2.name) {
    if (partId == '5' || partId == '6') {
      return AppLocalizations.of(context)!.dialogMessageReturnIngress4Setting;
    } else {
      return AppLocalizations.of(context)!.dialogMessageReturnIngress2Setting;
    }
  } else if (item == DataKey.ingressSetting3.name) {
    if (partId == '5' || partId == '6') {
      return AppLocalizations.of(context)!
          .dialogMessageReturnIngress2And3Setting;
    } else {
      return AppLocalizations.of(context)!.dialogMessageReturnIngress3Setting;
    }
  } else if (item == DataKey.ingressSetting4.name) {
    if (partId == '5' || partId == '6') {
      return AppLocalizations.of(context)!
          .dialogMessageReturnIngress5And6Setting;
    } else {
      return AppLocalizations.of(context)!.dialogMessageReturnIngress4Setting;
    }
  } else {
    return '';
  }
}

String formatCCorNode1P8GSettingResultItem({
  required BuildContext context,
  required String item,
}) {
  if (item == DataKey.dsVVA1.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardInputAttenuation1Setting;
  } else if (item == DataKey.dsVVA3.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardInputAttenuation3Setting;
  } else if (item == DataKey.dsVVA4.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardInputAttenuation4Setting;
  } else if (item == DataKey.dsVVA6.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardInputAttenuation6Setting;
  } else if (item == DataKey.dsInSlope1.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardInputEqualizer1Setting;
  } else if (item == DataKey.dsInSlope3.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardInputEqualizer3Setting;
  } else if (item == DataKey.dsInSlope4.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardInputEqualizer4Setting;
  } else if (item == DataKey.dsInSlope6.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardInputEqualizer6Setting;
  } else if (item == DataKey.dsOutSlope1.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardOutputEqualizer1Setting;
  } else if (item == DataKey.dsOutSlope3.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardOutputEqualizer3Setting;
  } else if (item == DataKey.dsOutSlope4.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardOutputEqualizer4Setting;
  } else if (item == DataKey.dsOutSlope6.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardOutputEqualizer6Setting;
  } else if (item == DataKey.biasCurrent1.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardBiasCurrent1Setting;
  } else if (item == DataKey.biasCurrent3.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardBiasCurrent3Setting;
  } else if (item == DataKey.biasCurrent4.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardBiasCurrent4Setting;
  } else if (item == DataKey.biasCurrent6.name) {
    return AppLocalizations.of(context)!
        .dialogMessageForwardBiasCurrent6Setting;
  } else if (item == DataKey.usVCA1.name) {
    return AppLocalizations.of(context)!
        .dialogMessageReturnInputAttenuation1Setting;
  } else if (item == DataKey.usVCA3.name) {
    return AppLocalizations.of(context)!
        .dialogMessageReturnInputAttenuation3Setting;
  } else if (item == DataKey.usVCA4.name) {
    return AppLocalizations.of(context)!
        .dialogMessageReturnInputAttenuation4Setting;
  } else if (item == DataKey.usVCA6.name) {
    return AppLocalizations.of(context)!
        .dialogMessageReturnInputAttenuation6Setting;
  } else if (item == DataKey.ingressSetting1.name) {
    return AppLocalizations.of(context)!.dialogMessageReturnIngress1Setting;
  } else if (item == DataKey.ingressSetting3.name) {
    return AppLocalizations.of(context)!.dialogMessageReturnIngress3Setting;
  } else if (item == DataKey.ingressSetting4.name) {
    return AppLocalizations.of(context)!.dialogMessageReturnIngress4Setting;
  } else if (item == DataKey.ingressSetting6.name) {
    return AppLocalizations.of(context)!.dialogMessageReturnIngress6Setting;
  } else {
    return '';
  }
}

Color getResultValueColor(String resultValue) {
  return resultValue == 'true' ? Colors.green : Colors.red;
}

List<Widget> get1P8GSettingMessageRows({
  required BuildContext context,
  required String partId,
  required List<String> settingResultList,
}) {
  List<Widget> rows = [];
  for (String settingResult in settingResultList) {
    String item = settingResult.split(',')[0];
    String boolValue = settingResult.split(',')[1];
    Color valueColor = getResultValueColor(boolValue);

    rows.add(Padding(
      padding: const EdgeInsets.only(
        bottom: 14.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              format1P8GSettingResultItem(
                context: context,
                partId: partId,
                item: item,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            formatResultValue(context: context, boolValue: boolValue),
            style: TextStyle(
              fontSize: CustomStyle.sizeL,
              color: valueColor,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    ));
  }
  return rows;
}

List<Widget> get1P8GCCorNodeSettingMessageRows({
  required BuildContext context,
  required List<String> settingResultList,
}) {
  List<Widget> rows = [];
  for (String settingResult in settingResultList) {
    String item = settingResult.split(',')[0];
    String boolValue = settingResult.split(',')[1];
    Color valueColor = getResultValueColor(boolValue);

    rows.add(Padding(
      padding: const EdgeInsets.only(
        bottom: 14.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              formatCCorNode1P8GSettingResultItem(
                context: context,
                item: item,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            formatResultValue(context: context, boolValue: boolValue),
            style: TextStyle(
              fontSize: CustomStyle.sizeL,
              color: valueColor,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    ));
  }
  return rows;
}

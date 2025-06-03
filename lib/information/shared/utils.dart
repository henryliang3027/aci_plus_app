import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

Widget getContent({
  required FormStatus loadingStatus,
  required String? content,
  double fontSize = 16,
}) {
  if (loadingStatus == FormStatus.requestInProgress) {
    return content == null
        ? const SizedBox(
            width: CustomStyle.diameter,
            height: CustomStyle.diameter,
            child: CircularProgressIndicator(),
          )
        : Text(
            content,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: fontSize,
            ),
          );
  } else if (loadingStatus == FormStatus.requestSuccess) {
    return content == null
        ? Text(
            '',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: fontSize,
            ),
          )
        : Text(
            content,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: fontSize,
            ),
          );
    ;
  } else {
    return Text(
      content == null || content.isEmpty ? 'N/A' : content,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}

Widget itemText({
  required FormStatus loadingStatus,
  required String title,
  required String? content,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: CustomStyle.sizeL,
          ),
        ),
        const SizedBox(
          width: 30.0,
        ),
        Flexible(
          child: getContent(
            loadingStatus: loadingStatus,
            content: content,
          ),
        ),
      ],
    ),
  );
}

Widget itemMultipleLineText({
  required FormStatus loadingStatus,
  required String title,
  required String? content,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: CustomStyle.sizeL,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: RichText(
                text: WidgetSpan(
                  child: getContent(
                    loadingStatus: loadingStatus,
                    content: content,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    ),
  );
}

Widget itemLinkText({
  required String title,
  required String content,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: CustomStyle.sizeL,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            visualDensity:
                const VisualDensity(vertical: -4.0, horizontal: -4.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.all(1.0),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: CustomStyle.sizeL,
            ),
            textAlign: TextAlign.end,
          ),
          onPressed: () async {
            Uri uri = Uri.parse('http://acicomms.com/products/line-amplifier');
            launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    ),
  );
}

String getCurrentLogInterval({
  required BuildContext context,
  required String? logInterval,
}) {
  if (logInterval == null || logInterval.isEmpty) {
    return '';
  } else {
    return '$logInterval ${AppLocalizations.of(context)!.minute}';
  }
}

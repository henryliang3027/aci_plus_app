import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRCodeImageViewer extends StatelessWidget {
  const QRCodeImageViewer({
    super.key,
    required this.imageFilePath,
  });

  final String imageFilePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370,
      height: 450,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Image.file(
                File(imageFilePath),
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.dialogMessageCancel,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false); // pop dialog
                    },
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.dialogMessageOk,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true); // pop dialog
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:win_outlook/win_outlook.dart';

void openShareFileWidget({
  required BuildContext context,
  required String subject,
  required String body,
  required String attachmentPath,
  String recipient = '',
}) {
  if (Platform.isWindows) {
    WinOutlook winOutlook = WinOutlook();
    winOutlook.openEmail(
      recipient: recipient,
      subject: subject,
      body: body,
      attachmentPath: attachmentPath,
    );
  } else {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Share.shareXFiles(
      [XFile(attachmentPath)],
      subject: subject,
      text: body,
      sharePositionOrigin: Rect.fromLTWH(0.0, height / 2, width, height / 2),
    );
  }
}

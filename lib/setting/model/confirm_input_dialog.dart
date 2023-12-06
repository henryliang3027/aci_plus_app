import 'package:aci_plus_app/setting/views/confirm_input_page.dart';
import 'package:flutter/material.dart';

Future<bool?> showConfirmInputDialog({
  required BuildContext context,
}) async {
  return showDialog<bool?>(
      context: context,
      builder: (context) {
        return const ConfirmInputPage();
      });
}

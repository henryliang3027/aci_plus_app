import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.titleAlignment = Alignment.center,
    this.titleColor,
    this.titleBackgroundColor,
  });

  final String title;
  final Widget? content; // Content of the dialog
  final List<Widget> actions; // List of action buttons for the dialog

  final Alignment titleAlignment;
  final Color? titleColor;
  final Color? titleBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 360,
        child: Dialog(
          insetPadding: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                width: double.maxFinite,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                  color: titleBackgroundColor ??
                      Theme.of(context).colorScheme.primary,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: CustomStyle.sizeXL,
                      color:
                          titleColor ?? Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
                    child: content ?? const SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool?> showCustomDialog({
  required BuildContext context,
  required String title,
  required Widget? content,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return CustomDialog(
        title: title,
        content: content,
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CodeInputDialog extends StatefulWidget {
  const CodeInputDialog({super.key});

  @override
  State<CodeInputDialog> createState() => _CodeInputDialogState();
}

class _CodeInputDialogState extends State<CodeInputDialog> {
  late TextEditingController _codeTextEditingController;
  late String code;

  @override
  void initState() {
    _codeTextEditingController = TextEditingController();
    code = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.dialogTitleEnterYourCode),
      content: TextField(
        onChanged: (text) {
          setState(() {
            code = text;
          });
        },
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
        controller: _codeTextEditingController,
        maxLength: 8,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.dialogMessageEnterYourCode,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          contentPadding: const EdgeInsets.all(8.0),
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          counterText: '',
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            AppLocalizations.of(context)!.dialogMessageCancel,
          ),
        ),
        ElevatedButton(
          onPressed: code.isNotEmpty
              ? () {
                  Navigator.pop(context, code);
                }
              : null,
          child: Text(
            AppLocalizations.of(context)!.dialogMessageOk,
          ),
        ),
      ],
    );
  }
}

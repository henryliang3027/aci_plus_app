import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      title: const Text('TextField in Dialog'),
      content: TextField(
        onChanged: (text) {
          setState(() {
            code = text;
          });
        },
        controller: _codeTextEditingController,
        decoration: const InputDecoration(hintText: "Text Field in Dialog"),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: code.isNotEmpty
              ? () {
                  Navigator.pop(context, code);
                }
              : null,
        ),
      ],
    );
  }
}

import 'package:aci_plus_app/chart/bloc/code_input/code_input_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CodeInputForm extends StatelessWidget {
  CodeInputForm({super.key});

  final TextEditingController _codeTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CodeInputBloc, CodeInputState>(
      listener: (context, state) {
        if (state.isInitialize) {
          _codeTextEditingController.text = state.code;
        }
      },
      child: _CodeInputDialog(
        codeTextEditingController: _codeTextEditingController,
      ),
    );
  }
}

class _CodeInputDialog extends StatelessWidget {
  const _CodeInputDialog({
    super.key,
    required this.codeTextEditingController,
  });

  final TextEditingController codeTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CodeInputBloc, CodeInputState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.dialogTitleEnterYourCode),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.dialogMessageEnterYourCode,
              ),
              const SizedBox(
                height: 6.0,
              ),
              TextField(
                onChanged: (code) {
                  context.read<CodeInputBloc>().add(CodeChanged(code: code));
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                ],
                controller: codeTextEditingController,
                maxLength: 8,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.dialogMessageCodeHint,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: const EdgeInsets.all(8.0),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                ),
              ),
            ],
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
              onPressed: state.code.isNotEmpty
                  ? () {
                      context.read<CodeInputBloc>().add(const CodeConfirmed());
                      Navigator.pop(context, state.code);
                    }
                  : null,
              child: Text(
                AppLocalizations.of(context)!.dialogMessageOk,
              ),
            ),
          ],
        );
      },
    );
  }
}

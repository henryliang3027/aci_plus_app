import 'package:aci_plus_app/advanced/bloc/description_input/description_input_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DescriptionInputForm extends StatelessWidget {
  DescriptionInputForm({super.key});

  final TextEditingController _descriptionTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DescriptionInputBloc, DescriptionInputState>(
      listener: (context, state) {
        if (state.isInitialize) {
          _descriptionTextEditingController.text = state.description;
        }
      },
      child: _DescriptionInputDialog(
        descriptionTextEditingController: _descriptionTextEditingController,
      ),
    );
  }
}

class NoEmptyStringFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Prevent empty string
    if (newValue.text.isEmpty) {
      return oldValue;
    }
    return newValue;
  }
}

class _DescriptionInputDialog extends StatelessWidget {
  const _DescriptionInputDialog({
    required this.descriptionTextEditingController,
  });

  final TextEditingController descriptionTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DescriptionInputBloc, DescriptionInputState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.dialogTitleEnterQRCodeDescription,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .dialogMessageEnterQRCodeDescription,
                  ),
                ],
              ),
              const SizedBox(
                height: 6.0,
              ),
              TextField(
                onChanged: (description) {
                  context
                      .read<DescriptionInputBloc>()
                      .add(DescriptionChanged(description: description));
                },
                onTapOutside: (event) {
                  // 點擊其他區域關閉螢幕鍵盤
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: descriptionTextEditingController,
                maxLength: 22,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: const EdgeInsets.all(8.0),
                  isDense: true,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondaryContainer,
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
              onPressed: state.description.isNotEmpty
                  ? () {
                      // context.read<DescriptionInputBloc>().add(const CodeConfirmed());
                      Navigator.pop(context, state.description);
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

import 'package:aci_plus_app/setting/bloc/confirm_input/confirm_input_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmInputForm extends StatelessWidget {
  ConfirmInputForm({super.key});

  final TextEditingController _confirmTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _CofirmInputDialog(
      confirmTextEditingController: _confirmTextEditingController,
    );
  }
}

class _CofirmInputDialog extends StatelessWidget {
  const _CofirmInputDialog({
    required this.confirmTextEditingController,
  });

  final TextEditingController confirmTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfirmInputBloc, ConfirmInputState>(
      builder: (context, state) {
        // SingleChildScrollView: 避免鍵盤開啟時 dialog 過小兒無法正常顯示內容
        // Center: 因為加了 SingleChildScrollView 會導致 dialog 位置偏上, 再包一層 Center 來置中
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title:
                  Text(AppLocalizations.of(context)!.dialogTitleEnterConfirm),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.dialogMessageEnterConfirm,
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  TextField(
                    onChanged: (text) {
                      context
                          .read<ConfirmInputBloc>()
                          .add(TextChanged(text: text));
                    },
                    controller: confirmTextEditingController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      contentPadding: EdgeInsets.all(8.0),
                      isDense: true,
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      counterText: '',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.dialogMessageCancel,
                  ),
                ),
                ElevatedButton(
                  onPressed: state.isMatch
                      ? () {
                          Navigator.pop(context, true);
                        }
                      : null,
                  child: Text(
                    AppLocalizations.of(context)!.dialogMessageOk,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

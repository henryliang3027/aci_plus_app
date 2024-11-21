import 'package:aci_plus_app/core/custom_style.dart';
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
                  ListBody(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .dialogMessageConfirmExecution,
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeL,
                        ),
                      ),
                    ],
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
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
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

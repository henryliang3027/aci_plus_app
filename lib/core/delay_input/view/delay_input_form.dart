import 'package:aci_plus_app/core/delay_input/bloc/delay_input_bloc.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DelayInputForm extends StatelessWidget {
  DelayInputForm({super.key});

  final TextEditingController _delayTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DelayInputBloc, DelayInputState>(
      listener: (context, state) {
        if (state.isInitialize) {
          _delayTextEditingController.text = state.delay;
        }
      },
      child: _DelayInputDialog(
        delayTextEditingController: _delayTextEditingController,
      ),
    );
  }
}

class _DelayInputDialog extends StatelessWidget {
  const _DelayInputDialog({
    required this.delayTextEditingController,
  });

  final TextEditingController delayTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DelayInputBloc, DelayInputState>(
      builder: (context, state) {
        return AlertDialog(
          title: const Text(
            "Delay",
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Set Delay (ms)",
              ),
              const SizedBox(
                height: 6.0,
              ),
              TextField(
                onChanged: (delay) {
                  context
                      .read<DelayInputBloc>()
                      .add(DelayChanged(delay: delay));
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                ],
                controller: delayTextEditingController,
                maxLength: 8,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.dialogMessageCodeHint,
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
              onPressed: state.delay.isNotEmpty
                  ? () {
                      handleUpdateAction(
                        context: context,
                        targetBloc: context.read<DelayInputBloc>(),
                        action: () {
                          context
                              .read<DelayInputBloc>()
                              .add(const DelayConfirmed());
                        },
                        waitForState: (state) {
                          DelayInputState delayInputState =
                              state as DelayInputState;

                          return delayInputState
                              .submissionStatus.isSubmissionSuccess;
                        },
                      );

                      Navigator.pop(context, state.delay);
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

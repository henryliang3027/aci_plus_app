import 'package:aci_plus_app/advanced/view/setting18_dongle_page.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18InstructionPage extends StatelessWidget {
  const Setting18InstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: const ContentView(),
    );
  }
}

class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    Widget getInstructionRow({
      required String number,
      required String description,
    }) {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: CustomStyle.sizeXXL,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: CustomStyle.sizeXXL,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 30.0,
            ),
            child: Row(
              children: [
                Text(
                  '${AppLocalizations.of(context)!.instruction}: ',
                  style: TextStyle(
                    fontSize: CustomStyle.size32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          getInstructionRow(
            number: '1. ',
            description: AppLocalizations.of(context)!.instructionStep1,
          ),
          getInstructionRow(
            number: '2. ',
            description: AppLocalizations.of(context)!.instructionStep2,
          ),
          getInstructionRow(
            number: '3. ',
            description: AppLocalizations.of(context)!.instructionStep3,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: CustomStyle.size36),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                minimumSize: const Size(100, 60),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
                ),
                textStyle: const TextStyle(
                  fontSize: CustomStyle.sizeXXL,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  Setting18DonglePage.route(),
                );
                Setting18DonglePage.route();
              },
              child: Text(
                AppLocalizations.of(context)!.bluetoothSetting,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

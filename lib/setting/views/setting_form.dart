import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingForm extends StatelessWidget {
  const SettingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
      ),
      body: Column(
        children: const [
          _Location(),
        ],
      ),
    );
  }
}

class _Location extends StatelessWidget {
  const _Location({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text('SSSSSSS'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChartForm extends StatelessWidget {
  const ChartForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).monitoringChart,
        ),
        centerTitle: true,
      ),
      body: const Center(
          child: Icon(
        Icons.chat_rounded,
      )),
    );
  }
}

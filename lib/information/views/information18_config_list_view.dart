import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/information/views/information18_preset_page.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Informtion18ConfigListView extends StatelessWidget {
  const Informtion18ConfigListView({
    super.key,
    required this.configs,
  });

  final List<Config> configs;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          width: double.maxFinite,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            AppLocalizations.of(context)!.dialogTitleSelectConfig,
            style: TextStyle(
              fontSize: CustomStyle.sizeXL,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                children: [
                  for (Config config in configs) ...[
                    Card(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            config.name,
                            style: const TextStyle(
                              fontSize: CustomStyle.sizeXL,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              Information18PresetPage.route(
                                config: config,
                              ));
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

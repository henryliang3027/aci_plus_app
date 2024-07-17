import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/information/views/information18_ccor_node_preset_page.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Informtion18CCorNodeConfigListView extends StatelessWidget {
  const Informtion18CCorNodeConfigListView({
    super.key,
    required this.nodeConfigs,
  });

  final List<NodeConfig> nodeConfigs;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SizedBox(
        width: 370,
        height: 390,
        child: Column(
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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  child: Column(
                    children: [
                      for (NodeConfig nodeConfig in nodeConfigs) ...[
                        Card(
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                nodeConfig.name,
                                style: const TextStyle(
                                  fontSize: CustomStyle.sizeXL,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  Information18CCorNodePresetPage.route(
                                    nodeConfig: nodeConfig,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 20.0,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.dialogMessageOk,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

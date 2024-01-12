import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_configure_page.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_control_page.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_threshold_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18CCorNodeTabBar extends StatelessWidget {
  const Setting18CCorNodeTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            color: Theme.of(context).colorScheme.primary,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                unselectedLabelColor: Colors.white,
                labelColor: Theme.of(context).colorScheme.primary,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white,
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                tabs: [
                  Tab(
                    child: SizedBox(
                      width: 110,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.device,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: 110,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.alarm,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: 110,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.balance,
                        ),
                      ),
                    ),
                  ),
                  // Tab(
                  //   child: SizedBox(
                  //     width: 110,
                  //     child: Center(
                  //       child: Text(
                  //         AppLocalizations.of(context)!.advanced,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          const Expanded(
            child: TabBarView(
              // physics: NeverScrollableScrollPhysics(),
              children: [
                Setting18CCorNodeConfigurePage(),
                Setting18CCorNodeThresholdPage(),
                Setting18CCorNodeControlPage(),
                // Setting18ConfigPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

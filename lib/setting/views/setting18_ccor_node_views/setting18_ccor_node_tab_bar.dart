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
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              unselectedLabelColor:
                  Theme.of(context).tabBarTheme.unselectedLabelColor,
              labelColor: Theme.of(context).tabBarTheme.labelColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: Theme.of(context).tabBarTheme.indicator,
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
          const Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
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

import 'package:aci_plus_app/core/secondary_tab_bar_theme.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_attribute_page.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_regulation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18CCorNodeConfigurationTabBar extends StatelessWidget {
  const Setting18CCorNodeConfigurationTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            color: getSecondaryTabBarBackGroundColor(context),
            child: Theme(
              data: getSecondaryTabBarTheme(context),
              child: TabBar(
                // controller: tabController,
                padding: const EdgeInsets.only(left: 6.0),
                isScrollable: true,
                tabs: [
                  Tab(
                    child: SizedBox(
                      // width: 110,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.attribute,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      // width: 110,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.configuration,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            child: TabBarView(
              // physics: NeverScrollableScrollPhysics(),
              // controller: tabController,
              children: [
                Setting18CCorNodeAttributePage(),
                Setting18CCorNodeRegulationPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

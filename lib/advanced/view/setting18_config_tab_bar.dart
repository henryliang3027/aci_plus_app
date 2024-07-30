import 'package:aci_plus_app/advanced/view/setting18_distribution_config_form.dart';
import 'package:aci_plus_app/advanced/view/setting18_node_config_form.dart';
import 'package:aci_plus_app/advanced/view/setting18_trunk_config_form.dart';
import 'package:aci_plus_app/core/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ConfigTabBar extends StatelessWidget {
  const Setting18ConfigTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            color: getSecondaryTabBarPaddingColor(context),
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
                          AppLocalizations.of(context)!.trunkAmplifier,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      // width: 110,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.distributionAmplifier,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      // width: 110,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.opticalNode,
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
                Setting18TrunkConfigForm(),
                Setting18DistributionConfigForm(),
                Setting18NodeConfigForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

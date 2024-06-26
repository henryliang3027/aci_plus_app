import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_forward_control_page.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_reverse_control_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18CCroNodeControlTabBar extends StatelessWidget {
  const Setting18CCroNodeControlTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            color: Theme.of(context).colorScheme.primary,
            child: TabBar(
              // controller: tabController,
              tabAlignment: TabAlignment.fill,
              // isScrollable: true,
              unselectedLabelColor: Colors.white,
              labelColor: Theme.of(context).colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              labelPadding: const EdgeInsets.symmetric(horizontal: 24.0),
              tabs: [
                Tab(
                  child: SizedBox(
                    width: 110,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.forwardControl,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: SizedBox(
                    width: 110,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.returnControl,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              // controller: tabController,
              children: [
                Setting18CCorNodeForwardControlPage(),
                Setting18CCorNodeReverseControlPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

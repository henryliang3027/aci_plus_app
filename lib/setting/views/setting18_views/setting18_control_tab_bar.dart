import 'package:aci_plus_app/setting/views/setting18_views/setting18_forward_control_page.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_reverse_control_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ControlTabBar extends StatelessWidget {
  const Setting18ControlTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            color: Theme.of(context).colorScheme.onPrimary,
            child: TabBar(
              // controller: tabController,
              padding: const EdgeInsets.only(left: 6.0),
              dividerColor: Colors.grey,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                border: const Border(
                    left: BorderSide(
                      color: Colors.grey,
                    ),
                    top: BorderSide(
                      color: Colors.grey,
                    ),
                    right: BorderSide(
                      color: Colors.grey,
                    )),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              // labelPadding: const EdgeInsets.symmetric(horizontal: 24.0),
              tabs: [
                Tab(
                  child: SizedBox(
                    // width: 110,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.forwardControl,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: SizedBox(
                    // width: 110,
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
              // physics: NeverScrollableScrollPhysics(),
              // controller: tabController,
              children: [
                Setting18ForwardControlPage(),
                Setting18ReverseControlPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

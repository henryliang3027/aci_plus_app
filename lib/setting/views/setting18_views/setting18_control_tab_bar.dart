import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ControlTabBar extends StatelessWidget {
  const Setting18ControlTabBar({super.key});

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
            child: TabBar(
              // controller: tabController,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              unselectedLabelColor: Colors.white,
              labelColor: Theme.of(context).colorScheme.primary,
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
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}

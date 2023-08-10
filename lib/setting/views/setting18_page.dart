import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18Page extends StatelessWidget {
  const Setting18Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).setting),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        // leading: const _DeviceStatus(),
        // actions: const [_DeviceRefresh()],
      ),
      body: const _TabBar(),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({super.key});

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
            child: Center(
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
                      width: 130,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).configure,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: 130,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).threshold,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: 130,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).control,
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
              physics: NeverScrollableScrollPhysics(),
              children: [
                Icon(Icons.abc),
                Icon(Icons.wallet),
                Icon(Icons.face),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:aci_plus_app/setting/views/setting18_views/setting18_config_page.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_configure_page.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_control_page.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_threshold_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18TabBar extends StatelessWidget {
  const Setting18TabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
                          AppLocalizations.of(context)!.configuration,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: 110,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.threshold,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: 110,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.control,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: 110,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.advanced,
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
              children: [
                Setting18ConfigurePage(),
                Setting18ThresholdPage(),
                Setting18ControlPage(),
                Setting18ConfigPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

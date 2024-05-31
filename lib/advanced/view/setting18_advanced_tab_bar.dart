import 'package:aci_plus_app/advanced/view/setting18_config_page.dart';
import 'package:aci_plus_app/advanced/view/setting18_instruction_page.dart';
import 'package:aci_plus_app/advanced/view/setting18_firmware_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18AdvancedTabBar extends StatelessWidget {
  const Setting18AdvancedTabBar({
    super.key,
    // required this.tabController,
  });

  // final TabController tabController;

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
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                // controller: tabController,
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
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(
                    child: SizedBox(
                      width: 160,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.deviceSetting,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: 160,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.firmawreUpdate,
                        ),
                      ),
                    ),
                  ),
                  // Tab(
                  //   child: SizedBox(
                  //     width: 160,
                  //     child: Center(
                  //       child: Text(
                  //         AppLocalizations.of(context)!.bluetoothSetting,
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
              // controller: tabController,
              children: [
                Setting18ConfigPage(),
                Setting18FirmwarePage(),

                // Setting18InstructionPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:aci_plus_app/advanced/bloc/setting18_advanced/setting18_advanced_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_page.dart';
import 'package:aci_plus_app/advanced/view/setting18_firmware_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18AdvancedTabBar extends StatelessWidget {
  const Setting18AdvancedTabBar({
    super.key,
    required this.pageController,
    required this.tabController,
  });

  final TabController tabController;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18AdvancedBloc, Setting18AdvancedState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.maxFinite,
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: IgnorePointer(
                ignoring: !state.enableButtonsTap,
                child: TabBar(
                  controller: tabController,
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
                        // width: 160,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.deviceSetting,
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: SizedBox(
                        // width: 160,
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
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  const Setting18ConfigPage(),
                  Setting18FirmwarePage(
                    pageController: pageController,
                  ),
                  // Setting18InstructionPage(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

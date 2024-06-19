import 'package:aci_plus_app/advanced/bloc/setting18_advanced/setting18_advanced_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_page.dart';
import 'package:aci_plus_app/advanced/view/setting18_instruction_page.dart';
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
              // 移除 appbar 跟 body 中間白色細長的區域
              transform: Matrix4.translationValues(
                0,
                -0.2,
                0,
              ),
              width: double.maxFinite,
              color: Theme.of(context).colorScheme.primary,
              child: IgnorePointer(
                ignoring: !state.enableButtonsTap,
                child: TabBar(
                  controller: tabController,
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

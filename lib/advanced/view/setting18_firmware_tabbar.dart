import 'package:aci_plus_app/advanced/bloc/setting18_advanced/setting18_advanced_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_firmware_log_page.dart';
import 'package:aci_plus_app/advanced/view/setting18_firmware_update_page.dart';
import 'package:aci_plus_app/core/secondary_tab_bar_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18FirmwareTabBar extends StatelessWidget {
  const Setting18FirmwareTabBar({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18AdvancedBloc, Setting18AdvancedState>(
      builder: (context, state) {
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
                  child: IgnorePointer(
                    // 進行更新時 tabbar 不可以切換
                    ignoring: !state.enableButtonsTap,
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
                                AppLocalizations.of(context)!.update,
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: SizedBox(
                            // width: 110,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.firmwareUpdateLog,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  // physics: NeverScrollableScrollPhysics(),
                  // controller: tabController,
                  children: [
                    Setting18FirmwareUpdatePage(
                      pageController: pageController,
                    ),
                    const Setting18FirmwareLogPage(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

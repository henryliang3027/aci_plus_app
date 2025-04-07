import 'package:aci_plus_app/chart/bloc/chart18/chart18_bloc.dart';
import 'package:aci_plus_app/chart/view/data_log_chart_page.dart';
import 'package:aci_plus_app/chart/view/rf_level_chart_page.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Chart18TabBar extends StatelessWidget {
  const Chart18TabBar({
    super.key,
    required this.pageController,
    required this.tabController,
  });

  final PageController pageController;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Chart18Bloc, Chart18State>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.maxFinite,
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: IgnorePointer(
                ignoring: !state.enableTabChange,
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
                        width: getTextWidth(
                          context,
                          AppLocalizations.of(context)!.dataLog,
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.dataLog,
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: SizedBox(
                        width: getTextWidth(
                          context,
                          AppLocalizations.of(context)!.rfLevel,
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.rfLevel,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  DataLogChartPage(
                    pageController: pageController,
                  ),
                  RFLevelChartPage(
                    pageController: pageController,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

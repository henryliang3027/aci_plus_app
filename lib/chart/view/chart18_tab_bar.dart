import 'package:aci_plus_app/chart/chart/chart18_bloc/chart18_bloc.dart';
import 'package:aci_plus_app/chart/view/data_log_chart_page.dart';
import 'package:aci_plus_app/chart/view/rf_level_chart_page.dart';
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
              color: Theme.of(context).colorScheme.primary,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IgnorePointer(
                  ignoring: !state.enableTabChange,
                  child: TabBar(
                    controller: tabController,
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
                          width: 130,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.dataLog,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: 130,
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

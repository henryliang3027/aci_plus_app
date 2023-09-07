import 'package:dsim_app/chart/view/data_log_chart_view.dart';
import 'package:dsim_app/chart/view/rf_level_chart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Chart18TabBar extends StatelessWidget {
  const Chart18TabBar({super.key});

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
                          AppLocalizations.of(context).dataLog,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: 130,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).rfLevel,
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
                DataLogChartView(),
                RFLevelChartView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

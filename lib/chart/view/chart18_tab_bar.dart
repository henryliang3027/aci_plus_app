import 'package:dsim_app/chart/chart/chart18_bloc/chart18_bloc.dart';
import 'package:dsim_app/chart/view/data_log_chart_view.dart';
import 'package:dsim_app/chart/view/rf_level_chart_view.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Chart18TabBar extends StatelessWidget {
  const Chart18TabBar({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    // 如果正在讀取log 或 rf 資料, 就不能切換 tab
    bool isIgnoreTap() {
      Chart18State chart18state = context.read<Chart18Bloc>().state;

      if (chart18state.dataRequestStatus == FormStatus.requestInProgress) {
        return true;
      } else if (chart18state.rfDataRequestStatus ==
          FormStatus.requestInProgress) {
        return true;
      } else {
        return false;
      }
    }

    return BlocBuilder<Chart18Bloc, Chart18State>(
      builder: (context, state) {
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
                  child: IgnorePointer(
                    ignoring: isIgnoreTap(),
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
                      labelPadding:
                          const EdgeInsets.symmetric(horizontal: 24.0),
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
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    DataLogChartView(
                      pageController: pageController,
                    ),
                    RFLevelChartView(
                      pageController: pageController,
                    ),
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

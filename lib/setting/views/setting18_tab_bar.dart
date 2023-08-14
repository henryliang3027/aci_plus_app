import 'package:dsim_app/setting/views/setting18_configure_view.dart';
import 'package:dsim_app/setting/views/setting18_control_view.dart';
import 'package:dsim_app/setting/views/setting18_threshold_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18TabBar extends StatelessWidget {
  const Setting18TabBar({super.key});

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
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Setting18ConfigureView(),
                Setting18ThresholdView(),
                Setting18ControlView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

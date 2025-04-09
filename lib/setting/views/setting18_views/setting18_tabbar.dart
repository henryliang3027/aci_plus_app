import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_configure_page.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_control_page.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_threshold_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18TabBar extends StatelessWidget {
  const Setting18TabBar({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      // loadingStatus 時會一直 emit 新的 藍牙列表, 所以 loadingStatus 改變時再 build 就好
      buildWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus,
      builder: (context, state) {
        if (state.loadingStatus.isRequestInProgress) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _CustomTabBarView(
                tabController: tabController,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(70, 158, 158, 158),
                ),
                child: const Center(
                  child: SizedBox(
                    width: CustomStyle.diameter,
                    height: CustomStyle.diameter,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          );
        } else {
          return _CustomTabBarView(
            tabController: tabController,
          );
        }
      },
    );
  }
}

class _CustomTabBarView extends StatelessWidget {
  const _CustomTabBarView({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.maxFinite,
          color: Theme.of(context).appBarTheme.backgroundColor,
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
                  // width: 110,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.device,
                    ),
                  ),
                ),
              ),
              Tab(
                child: SizedBox(
                  // width: 110,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.alarm,
                    ),
                  ),
                ),
              ),
              Tab(
                child: SizedBox(
                  // width: 110,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.balance,
                    ),
                  ),
                ),
              ),
              // Tab(
              //   child: SizedBox(
              //     width: 110,
              //     child: Center(
              //       child: Text(
              //         AppLocalizations.of(context)!.advanced,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: const [
              Setting18ConfigurePage(),
              Setting18ThresholdPage(),
              Setting18ControlPage(),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_tabbar/setting18_tabbar_bloc.dart';
import 'package:aci_plus_app/setting/views/custom_setting_dialog.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_configure_page.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_control_page.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_threshold_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18TabBarForm extends StatelessWidget {
  const Setting18TabBarForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      // loadingStatus 時會一直 emit 新的 藍牙列表, 所以 loadingStatus 改變時再 build 就好
      buildWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus,
      builder: (context, state) {
        if (state.loadingStatus.isRequestInProgress) {
          // context
          //     .read<Setting18TabBarBloc>()
          //     .add(const CurrentForwardCEQPeriodicUpdateCanceled());
          return Stack(
            alignment: Alignment.center,
            children: [
              const _TimerTabBarView(),
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
        } else if (state.loadingStatus.isRequestSuccess) {
          return const _TimerTabBarView();
        } else {
          return const _TimerTabBarView();
        }
      },
    );
  }
}

class _TimerTabBarView extends StatelessWidget {
  const _TimerTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<Setting18TabBarBloc, Setting18TabBarState>(
        listenWhen: (previous, current) =>
            previous.forwardCEQStatus != current.forwardCEQStatus,
        listener: (context, state) {
          // 向 device 取得 CEQ index 後, forwardCEQStatus 就會變成 isRequestSuccess,
          // 再判斷 isForwardCEQIndexChanged 是否為 true
          // 接者跳出 Dialog 前判斷 Dialog 是否還在畫面中, 還在畫面中就不重複跳, 否則會一直疊加到畫面上
          if (state.forwardCEQStatus.isRequestSuccess) {
            if (state.isForwardCEQIndexChanged) {
              if (ModalRoute.of(context)?.isCurrent == true) {
                showCurrentForwardCEQChangedDialog(context).then((_) {
                  context
                      .read<Setting18TabBarBloc>()
                      .add(const NotifyChildTabUpdated());
                });
              }
            }
          }
        },
        child: BlocBuilder<Setting18TabBarBloc, Setting18TabBarState>(
          builder: (context, state) {
            return const _CustomTabBarView();
          },
        ));
  }
}

class _CustomTabBarView extends StatelessWidget {
  const _CustomTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: TabBar(
              // controller: tabController,
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
          const Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              // controller: tabController,
              children: [
                Setting18ConfigurePage(),
                Setting18ThresholdPage(),
                Setting18ControlPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

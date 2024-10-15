import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/setting/bloc/setting18_tabbar/setting18_tabbar_bloc.dart';
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
    Future<bool?> showCurrentForwardCEQChangedDialog() async {
      return showDialog<bool?>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;

          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: width * 0.1,
            ),
            title: Text(
              AppLocalizations.of(context)!.dialogTitleNotice,
              style: const TextStyle(
                color: CustomStyle.customYellow,
              ),
            ),
            content: SizedBox(
              width: width,
              child: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .dialogMessageForwardCEQChanged,
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeL,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogMessageOk,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    return BlocListener<Setting18TabBarBloc, Setting18TabBarState>(
      listenWhen: (previous, current) =>
          previous.isForwardCEQIndexChanged != current.isForwardCEQIndexChanged,
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent == true) {
          showCurrentForwardCEQChangedDialog().then((_) {
            context
                .read<Setting18TabBarBloc>()
                .add(const NotifyChildTabUpdated());
          });
        }
      },
      child: DefaultTabController(
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
      ),
    );
  }
}

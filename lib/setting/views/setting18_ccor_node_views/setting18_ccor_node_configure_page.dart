import 'package:aci_plus_app/core/secondary_tab_bar_theme.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_configure_tab_bar.dart';
import 'package:flutter/material.dart';

class Setting18CCorNodeConfigurePage extends StatelessWidget {
  const Setting18CCorNodeConfigurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getSecondaryTabBarBackGroundColor(context),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 6),
        child: Setting18CCorNodeConfigurationTabBar(),
      ),
    );
    // return BlocProvider(
    //   create: (context) => Setting18CCorNodeConfigureBloc(
    //     amp18CCorNodeRepository:
    //         RepositoryProvider.of<Amp18CCorNodeRepository>(context),
    //     gpsRepository: RepositoryProvider.of<GPSRepository>(context),
    //   ),
    //   child: Setting18CCorNodeConfigureView(),
    // );
  }
}

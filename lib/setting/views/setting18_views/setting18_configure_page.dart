import 'package:aci_plus_app/core/secondary_tab_bar_theme.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_configure_tab_bar.dart';
import 'package:flutter/material.dart';

class Setting18ConfigurePage extends StatelessWidget {
  const Setting18ConfigurePage({super.key});

  @override
  Widget build(BuildContext context) {
    // return Setting18ConfigureView();
    // return BlocProvider(
    //   create: (context) => Setting18ConfigureBloc(
    //     amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
    //     gpsRepository: RepositoryProvider.of<GPSRepository>(context),
    //   ),
    //   child: Setting18ConfigureView(),
    // );

    return Container(
      decoration: BoxDecoration(
        color: getSecondaryTabBarBackGroundColor(context),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 6),
        child: Setting18ConfigurationTabBar(),
      ),
    );
  }
}

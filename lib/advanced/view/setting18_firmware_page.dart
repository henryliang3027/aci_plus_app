import 'package:aci_plus_app/advanced/view/setting18_firmware_tabbar.dart';
import 'package:aci_plus_app/core/secondary_tab_bar_theme.dart';
import 'package:flutter/material.dart';

class Setting18FirmwarePage extends StatelessWidget {
  const Setting18FirmwarePage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getSecondaryTabBarBackGroundColor(context),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Setting18FirmwareTabBar(
          pageController: pageController,
        ),
      ),
    );
  }
}

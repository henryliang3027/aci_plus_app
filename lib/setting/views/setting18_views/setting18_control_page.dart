import 'package:aci_plus_app/core/color.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_control_tab_bar.dart';
import 'package:flutter/material.dart';

class Setting18ControlPage extends StatelessWidget {
  const Setting18ControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getSecondaryTabBarPaddingColor(context),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 6),
        child: Setting18ControlTabBar(),
      ),
    );
  }
}

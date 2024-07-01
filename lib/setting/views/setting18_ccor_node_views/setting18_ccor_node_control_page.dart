import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_control_tab_bar.dart';
import 'package:flutter/material.dart';

class Setting18CCorNodeControlPage extends StatelessWidget {
  const Setting18CCorNodeControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 6),
        child: Setting18CCroNodeControlTabBar(),
      ),
    );
  }
}

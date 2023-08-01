import 'package:dsim_app/core/custom_style.dart';
import 'package:flutter/material.dart';

class SettingListLoadingView extends StatelessWidget {
  const SettingListLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
    // return Scaffold(
    //   body: SafeArea(
    //     child: SingleChildScrollView(
    //       child: Padding(
    //         padding: const EdgeInsets.all(
    //           CustomStyle.sizeXL,
    //         ),
    //         child: Column(
    //           children: [
    //             _Location(
    //               textEditingController: locationTextEditingController,
    //             ),
    //             const _TGCCabelLength(),
    //             const _LogIntervalDropDownMenu(),
    //             const _WorkingMode(),
    //             _UserPilot(
    //               textEditingController: userPilotTextEditingController,
    //             ),
    //             _UserPilot2(
    //               textEditingController: userPilot2TextEditingController,
    //             ),
    //             const _AGCPrepAttenator(),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    //   floatingActionButton: const _SettingFloatingActionButton(),
    // );
  }
}

import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:dsim_app/setting/views/circuit_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingGraphView extends StatelessWidget {
  SettingGraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          child: CustomPaint(
            size: Size(400, 400),
            painter: CircuitPainter(),
          ),
        ),
      ),
      floatingActionButton: const _SettingFloatingActionButton(),
    );
  }
}

class _SettingFloatingActionButton extends StatelessWidget {
  const _SettingFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget getEditTools({
    //   required bool editMode,
    //   required bool enableSubmission,
    // }) {
    //   return editMode
    //       ? Column(
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             FloatingActionButton(
    //               shape: const CircleBorder(
    //                 side: BorderSide.none,
    //               ),
    //               backgroundColor:
    //                   Theme.of(context).colorScheme.primary.withAlpha(200),
    //               child: Icon(
    //                 CustomIcons.cancel,
    //                 color: Theme.of(context).colorScheme.onPrimary,
    //               ),
    //               onPressed: () {
    //                 context.read<SettingBloc>().add(const EditModeDisabled());
    //               },
    //             ),
    //             const SizedBox(
    //               height: 10.0,
    //             ),
    //             FloatingActionButton(
    //               shape: const CircleBorder(
    //                 side: BorderSide.none,
    //               ),
    //               backgroundColor: enableSubmission
    //                   ? Theme.of(context).colorScheme.primary.withAlpha(200)
    //                   : Colors.grey.withAlpha(200),
    //               onPressed: enableSubmission
    //                   ? () {
    //                       // context
    //                       //     .read<SettingBloc>()
    //                       //     .add(const SettingSubmitted());
    //                     }
    //                   : null,
    //               child: Icon(
    //                 Icons.check,
    //                 color: Theme.of(context).colorScheme.onPrimary,
    //               ),
    //             ),
    //           ],
    //         )
    //       : Column(
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             FloatingActionButton(
    //               shape: const CircleBorder(
    //                 side: BorderSide.none,
    //               ),
    //               backgroundColor:
    //                   Theme.of(context).colorScheme.primary.withAlpha(200),
    //               child: Icon(
    //                 Icons.grain_sharp,
    //                 color: Theme.of(context).colorScheme.onPrimary,
    //               ),
    //               onPressed: () {
    //                 context.read<SettingBloc>().add(const ListViewToggled());
    //               },
    //             ),
    //             const SizedBox(
    //               height: 10.0,
    //             ),
    //             FloatingActionButton(
    //               shape: const CircleBorder(
    //                 side: BorderSide.none,
    //               ),
    //               backgroundColor:
    //                   Theme.of(context).colorScheme.primary.withAlpha(200),
    //               child: Icon(
    //                 Icons.edit,
    //                 color: Theme.of(context).colorScheme.onPrimary,
    //               ),
    //               onPressed: () {
    //                 context.read<SettingBloc>().add(const EditModeEnabled());
    //               },
    //             ),
    //           ],
    //         );
    // }

    // bool getEditable(FormStatus loadingStatus) {
    //   if (loadingStatus.isRequestSuccess) {
    //     return true;
    //   } else if (loadingStatus.isRequestFailure) {
    //     return false;
    //   } else {
    //     return false;
    //   }
    // }

    return BlocBuilder<SettingBloc, SettingState>(builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            shape: const CircleBorder(
              side: BorderSide.none,
            ),
            backgroundColor:
                Theme.of(context).colorScheme.primary.withAlpha(200),
            child: Icon(
              Icons.list,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              context.read<SettingBloc>().add(const ListViewToggled());
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          FloatingActionButton(
            shape: const CircleBorder(
              side: BorderSide.none,
            ),
            backgroundColor:
                Theme.of(context).colorScheme.primary.withAlpha(200),
            onPressed: () {},
            child: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      );
    });
  }
}

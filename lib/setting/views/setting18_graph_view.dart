import 'package:aci_plus_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18GraphView extends StatelessWidget {
  const Setting18GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _SettingFloatingActionButton extends StatelessWidget {
  const _SettingFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          shape: const CircleBorder(
            side: BorderSide.none,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
          child: Icon(
            Icons.abc,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            print(111);
            // context.read<SettingBloc>().add(const ListViewToggled());
          },
        ),
        const SizedBox(
          height: 60.0,
        ),
      ],
    );
  }
}

import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingListView extends StatelessWidget {
  SettingListView({super.key});

  final TextEditingController _locationTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            _Location(
              initialValue: state.characteristicData[DataKey.location] ?? '',
              textEditingController: _locationTextEditingController
                ..text = state.characteristicData[DataKey.location] ?? '',
            ),
          ],
        );
      },
    );
  }
}

class _Location extends StatelessWidget {
  const _Location({
    super.key,
    this.initialValue = '',
    required this.textEditingController,
  });

  final String initialValue;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(
            18.0,
          ),
          child: TextField(
            controller: textEditingController,
            key: const Key('settingForm_locationInput_textField'),
            style: const TextStyle(fontSize: 16),
            textInputAction: TextInputAction.done,
            onChanged: (location) =>
                context.read<SettingBloc>().add(LocationChanged(location)),
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              contentPadding: const EdgeInsets.all(8.0),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              labelText: AppLocalizations.of(context).location,
              labelStyle: TextStyle(
                fontSize: CustomStyle.sizeL,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        );
      },
    );
  }
}

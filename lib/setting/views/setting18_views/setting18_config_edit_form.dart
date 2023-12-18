import 'package:aci_plus_app/setting/bloc/setting18_config_edit/setting18_config_edit_bloc.dart';
import 'package:aci_plus_app/setting/model/setting_wisgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18ConfigEditForm extends StatelessWidget {
  const Setting18ConfigEditForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {},
      child: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
              18.0,
            ),
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}

class _FirstChannelLoading extends StatelessWidget {
  const _FirstChannelLoading({
    super.key,
    required this.firstChannelLoadingFrequencyTextEditingController,
    required this.firstChannelLoadingLevelTextEditingController,
  });

  final TextEditingController firstChannelLoadingFrequencyTextEditingController;
  final TextEditingController firstChannelLoadingLevelTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigEditBloc, Setting18ConfigEditState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.startFrequency}:',
          editMode1: true,
          editMode2: true,
          textEditingControllerName1:
              'setting18Form_firstChannelLoadingFrequencyInput_textField',
          textEditingControllerName2:
              'setting18Form_firstChannelLoadingLevelInput_textField',
          textEditingController1:
              firstChannelLoadingFrequencyTextEditingController,
          textEditingController2: firstChannelLoadingLevelTextEditingController,
          onChanged1: (firstChannelLoadingFrequency) {
            context.read<Setting18ConfigEditBloc>().add(
                FirstChannelLoadingFrequencyChanged(
                    firstChannelLoadingFrequency));
          },
          onChanged2: (firstChannelLoadingLevel) {
            context
                .read<Setting18ConfigEditBloc>()
                .add(FirstChannelLoadingLevelChanged(firstChannelLoadingLevel));
          },
        );
      },
    );
  }
}

class _LastChannelLoading extends StatelessWidget {
  const _LastChannelLoading({
    super.key,
    required this.lastChannelLoadingFrequencyTextEditingController,
    required this.lastChannelLoadingLevelTextEditingController,
  });

  final TextEditingController lastChannelLoadingFrequencyTextEditingController;
  final TextEditingController lastChannelLoadingLevelTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18ConfigEditBloc, Setting18ConfigEditState>(
      builder: (context, state) {
        return twoTextField(
          context: context,
          title: '${AppLocalizations.of(context)!.stopFrequency}:',
          editMode1: true,
          editMode2: true,
          textEditingControllerName1:
              'setting18Form_lastChannelLoadingFrequencyInput_textField',
          textEditingControllerName2:
              'setting18Form_lastChannelLoadingLevelInput_textField',
          textEditingController1:
              lastChannelLoadingFrequencyTextEditingController,
          textEditingController2: lastChannelLoadingLevelTextEditingController,
          onChanged1: (lastChannelLoadingFrequency) {
            context.read<Setting18ConfigEditBloc>().add(
                LastChannelLoadingFrequencyChanged(
                    lastChannelLoadingFrequency));
          },
          onChanged2: (lastChannelLoadingLevel) {
            context
                .read<Setting18ConfigEditBloc>()
                .add(LastChannelLoadingLevelChanged(lastChannelLoadingLevel));
          },
        );
      },
    );
  }
}

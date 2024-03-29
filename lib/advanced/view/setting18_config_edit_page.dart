import 'package:aci_plus_app/advanced/bloc/setting18_config_edit/setting18_config_edit_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_edit_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ConfigEditPage extends StatelessWidget {
  const Setting18ConfigEditPage({
    super.key,
    required this.groupId,
    this.config,
    this.isEdit = false,
  });

  final dynamic config;
  final String groupId;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18ConfigEditBloc(
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
        configRepository: RepositoryProvider.of<ConfigRepository>(context),
        config: config,
        groupId: groupId,
      ),
      child: Setting18ConfigEditForm(
        isEdit: isEdit,
      ),
    );
  }
}

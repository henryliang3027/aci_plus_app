import 'package:aci_plus_app/advanced/bloc/setting18_config_edit/setting18_config_edit_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_edit_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ConfigEditPage extends StatelessWidget {
  const Setting18ConfigEditPage({
    super.key,
    this.config,
    this.groupId,
    this.isEdit = false,
  });

  final Config? config;
  final String? groupId;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18ConfigEditBloc(
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
        config: config,
        groupId: groupId,
      ),
      child: Setting18ConfigEditForm(
        isEdit: isEdit,
      ),
    );
  }
}

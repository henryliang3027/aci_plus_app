import 'package:aci_plus_app/advanced/bloc/setting18_config_edit/setting18_config_edit_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_config_edit_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ConfigEditPage extends StatelessWidget {
  const Setting18ConfigEditPage({
    super.key,
    required this.selectedPartId,
    this.isShortcut = false,
  });

  final String selectedPartId;
  final bool isShortcut;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18ConfigEditBloc(
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
        selectedPartId: selectedPartId,
      ),
      child: Setting18ConfigEditForm(
        isShortcut: isShortcut,
      ),
    );
  }
}

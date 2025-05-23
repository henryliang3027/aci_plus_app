import 'package:aci_plus_app/advanced/bloc/setting18_firmware_update/setting18_firmware_update_bloc.dart';

import 'package:aci_plus_app/advanced/view/setting18_firmware_update_form.dart';
import 'package:aci_plus_app/repositories/code_repository.dart';
import 'package:aci_plus_app/repositories/connection_repository.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18FirmwareUpdatePage extends StatelessWidget {
  const Setting18FirmwareUpdatePage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => Setting18FirmwareUpdateBloc(
        appLocalizations: appLocalizations,
        firmwareRepository: RepositoryProvider.of<FirmwareRepository>(context),
        codeRepository: RepositoryProvider.of<CodeRepository>(context),
        connectionRepository:
            RepositoryProvider.of<ConnectionRepository>(context),
      ),
      child: Setting18FirmwareUpdateForm(
        pageController: pageController,
      ),
    );
  }
}

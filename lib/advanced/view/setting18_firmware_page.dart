import 'package:aci_plus_app/advanced/bloc/setting18_firmware/setting18_firmware_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_firmware_form.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18FirmwarePage extends StatelessWidget {
  const Setting18FirmwarePage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => Setting18FirmwareBloc(
        appLocalizations: appLocalizations,
        firmwareRepository: RepositoryProvider.of<FirmwareRepository>(context),
      ),
      child: Setting18FirmwareForm(
        pageController: pageController,
      ),
    );
  }
}

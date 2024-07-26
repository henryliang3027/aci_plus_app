import 'package:aci_plus_app/information/bloc/warm_reset/warm_reset_bloc.dart';
import 'package:aci_plus_app/information/views/warm_reset_form.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WarmResetPage extends StatelessWidget {
  const WarmResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => WarmResetBloc(
        appLocalizations: appLocalizations,
        firmwareRepository: RepositoryProvider.of<FirmwareRepository>(context),
      ),
      child: const WarmResetForm(),
    );
  }
}

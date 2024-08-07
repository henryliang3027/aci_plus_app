import 'package:aci_plus_app/chart/bloc/chart18_ccor_node/chart18_ccor_node_bloc.dart';
import 'package:aci_plus_app/chart/view/chart18_ccor_node_form.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Chart18CCorNodePage extends StatelessWidget {
  const Chart18CCorNodePage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => Chart18CCorNodeBloc(
        appLocalizations: appLocalizations,
        amp18CCorNodeRepository:
            RepositoryProvider.of<Amp18CCorNodeRepository>(context),
      ),
      child: Chart18CCorNodeForm(
        pageController: pageController,
      ),
    );
  }
}

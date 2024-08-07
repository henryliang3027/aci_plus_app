import 'package:aci_plus_app/chart/bloc/chart18/chart18_bloc.dart';
import 'package:aci_plus_app/chart/view/chart18_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Chart18Page extends StatelessWidget {
  const Chart18Page({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => Chart18Bloc(
        appLocalizations: appLocalizations,
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
      ),
      child: Chart18Form(
        pageController: pageController,
      ),
    );
  }
}

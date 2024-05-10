import 'package:aci_plus_app/chart/bloc/downloader18_rf_out/downloader18_rf_out_bloc.dart';
import 'package:aci_plus_app/chart/view/downloader18_rf_out_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Downloader18RFOutPage extends StatelessWidget {
  const Downloader18RFOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Downloader18RFOutBloc(
          amp18Repository: RepositoryProvider.of<Amp18Repository>(context)),
      child: const Downloader18RFOutForm(),
    );
  }
}

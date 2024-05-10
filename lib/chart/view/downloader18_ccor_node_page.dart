import 'package:aci_plus_app/chart/bloc/downloader18_ccor_node/downloader18_ccor_node_bloc.dart';
import 'package:aci_plus_app/chart/view/downloader18_ccor_node_form.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Downloader18CCorNodePage extends StatelessWidget {
  const Downloader18CCorNodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Downloader18CCorNodeBloc(
          amp18CCorNodeRepository:
              RepositoryProvider.of<Amp18CCorNodeRepository>(context)),
      child: const Downloader18CCorNodeForm(),
    );
  }
}

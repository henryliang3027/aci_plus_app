import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_graph_view_bloc/setting18_graph_view_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18GraphPage extends StatelessWidget {
  const Setting18GraphPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const Setting18GraphPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18GraphViewBloc(
        dsimRepository: RepositoryProvider.of<Amp18Repository>(context),
      ),
      child: const Setting18GraphView(),
    );
  }
}

import 'package:aci_plus_app/information/bloc/information18_ccor_node/information18_ccor_node_bloc.dart';
import 'package:aci_plus_app/information/views/information18_ccor_node_form.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Information18CCorNodePage extends StatelessWidget {
  const Information18CCorNodePage({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Information18CCorNodeBloc(
        configRepository: RepositoryProvider.of<ConfigRepository>(context),
      ),
      child: Information18CCorNodeForm(
        pageController: pageController,
      ),
    );
  }
}

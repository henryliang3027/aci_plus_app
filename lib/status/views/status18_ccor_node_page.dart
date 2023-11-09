import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/status/bloc/status18_bloc/status18_bloc.dart';
import 'package:aci_plus_app/status/views/status18_ccor_node_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Status18CCorNodePage extends StatelessWidget {
  const Status18CCorNodePage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Status18Bloc(
          unitRepository: RepositoryProvider.of<UnitRepository>(context)),
      child: Status18CCorNodeForm(
        pageController: pageController,
      ),
    );
  }
}

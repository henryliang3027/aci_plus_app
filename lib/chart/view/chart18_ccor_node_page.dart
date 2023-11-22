import 'package:aci_plus_app/chart/chart/chart18_ccor_node_bloc/chart18_ccor_node_bloc.dart';
import 'package:aci_plus_app/chart/view/chart18_ccor_node_form.dart';
import 'package:aci_plus_app/repositories/dsim18_ccor_node_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chart18CCorNodePage extends StatelessWidget {
  const Chart18CCorNodePage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => Chart18CCorNodeBloc(
            dsimRepository:
                RepositoryProvider.of<Dsim18CCorNodeRepository>(context),
          ),
        ),
      ],
      child: Chart18CCorNodeForm(
        pageController: pageController,
      ),
    );
  }
}

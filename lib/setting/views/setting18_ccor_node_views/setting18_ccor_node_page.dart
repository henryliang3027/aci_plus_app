import 'package:aci_plus_app/setting/bloc/setting18_ccor_node/setting18_ccor_node_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18CCorNodePage extends StatelessWidget {
  const Setting18CCorNodePage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => Setting18CCorNodeBloc(),
        ),
      ],
      child: Setting18CCorNodeForm(
        pageController: pageController,
      ),
    );
  }
}

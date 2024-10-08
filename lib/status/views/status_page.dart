import 'package:aci_plus_app/status/bloc/status/status_bloc.dart';
import 'package:aci_plus_app/status/views/status_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatusBloc(),
      child: StatusForm(
        pageController: pageController,
      ),
    );
  }
}

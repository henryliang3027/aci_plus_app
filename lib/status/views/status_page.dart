import 'package:dsim_app/status/bloc/status_bloc/status_bloc.dart';
import 'package:dsim_app/status/views/status_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatusBloc(),
      child: const StatusForm(),
    );
  }
}

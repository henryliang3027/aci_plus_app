import 'package:aci_plus_app/information/bloc/mode_input/mode_input_bloc.dart';
import 'package:aci_plus_app/information/shared/mode_Input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModeInputPage extends StatelessWidget {
  const ModeInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ModeInputBloc(),
      child: ModeInputForm(),
    );
  }
}

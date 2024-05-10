import 'package:aci_plus_app/setting/bloc/confirm_input/confirm_input_bloc.dart';
import 'package:aci_plus_app/setting/views/confirm_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmInputPage extends StatelessWidget {
  const ConfirmInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmInputBloc(),
      child: ConfirmInputForm(),
    );
  }
}

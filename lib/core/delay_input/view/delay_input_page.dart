import 'package:aci_plus_app/core/delay_input/bloc/delay_input_bloc.dart';
import 'package:aci_plus_app/core/delay_input/view/delay_input_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DelayInputPage extends StatelessWidget {
  const DelayInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DelayInputBloc(
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
      ),
      child: DelayInputForm(),
    );
  }
}

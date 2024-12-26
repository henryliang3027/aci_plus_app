import 'package:aci_plus_app/chart/bloc/code_input/code_input_bloc.dart';
import 'package:aci_plus_app/chart/view/code_input_form.dart';
import 'package:aci_plus_app/repositories/code_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeInputPage extends StatelessWidget {
  const CodeInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CodeInputBloc(
        codeRepository: RepositoryProvider.of<CodeRepository>(context),
      ),
      child: CodeInputForm(),
    );
  }
}

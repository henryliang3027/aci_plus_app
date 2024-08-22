import 'package:aci_plus_app/advanced/bloc/description_input/description_input_bloc.dart';
import 'package:aci_plus_app/advanced/view/description_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DescriptionInputPage extends StatelessWidget {
  const DescriptionInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DescriptionInputBloc(),
      child: DescriptionInputForm(),
    );
  }
}

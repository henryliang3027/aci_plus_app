import 'package:aci_plus_app/information/bloc/theme/theme_bloc.dart';
import 'package:aci_plus_app/information/shared/theme_option_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeOptionPage extends StatelessWidget {
  const ThemeOptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: const ThemeOptionForm(),
    );
  }
}

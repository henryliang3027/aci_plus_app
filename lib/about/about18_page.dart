import 'package:aci_plus_app/about/about18_form.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/information/bloc/information18/information18_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class About18Page extends StatelessWidget {
  const About18Page._();

  static Route<void> route(Information18Bloc information18Bloc) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: information18Bloc,
        child: const About18Page._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const About18Form();
  }
}

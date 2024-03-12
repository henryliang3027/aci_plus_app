import 'package:aci_plus_app/information/bloc/information18_preset_bloc/information18_preset_bloc.dart';
import 'package:aci_plus_app/information/views/information18_preset_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Information18PresetPage extends StatelessWidget {
  const Information18PresetPage({
    super.key,
    required this.config,
  });

  final Config config;

  static Route route({
    required Config config,
  }) {
    return MaterialPageRoute(
      builder: (_) => Information18PresetPage(
        config: config,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Information18PresetBloc(
        amp18repository: RepositoryProvider.of<Amp18Repository>(context),
        config: config,
      ),
      child: const Information18PresetForm(),
    );
  }
}

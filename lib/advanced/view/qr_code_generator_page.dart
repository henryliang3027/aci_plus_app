import 'package:aci_plus_app/advanced/bloc/qr_code_generator/qr_code_generator_bloc.dart';
import 'package:aci_plus_app/advanced/view/qr_code_generator_form.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QRCodeGeneratorPage extends StatelessWidget {
  const QRCodeGeneratorPage({
    super.key,
    required this.encodedData,
    required this.description,
  });

  final String encodedData;
  final String description;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QRCodeGeneratorBloc(
        encodedData: encodedData,
        description: description,
        configRepository: RepositoryProvider.of<ConfigRepository>(context),
      ),
      child: QRCodeGeneratorForm(),
    );
  }
}

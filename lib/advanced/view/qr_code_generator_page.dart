import 'package:aci_plus_app/advanced/bloc/qr_code_generator/qr_code_generator_bloc.dart';
import 'package:aci_plus_app/advanced/view/qr_code_generator_form.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QRCodeGeneratorPage extends StatelessWidget {
  const QRCodeGeneratorPage({
    super.key,
    required this.encodedData,
  });

  final String encodedData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QRCodeGeneratorBloc(),
      child: QRCodeGeneratorForm(
        encodedData: encodedData,
      ),
    );
  }
}

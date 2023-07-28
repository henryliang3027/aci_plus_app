import 'package:dsim_app/information/bloc/information_bloc/information_bloc.dart';
import 'package:dsim_app/information/views/information_form.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InformationForm();
  }
}

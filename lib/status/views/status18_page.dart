import 'package:dsim_app/status/bloc/status18_bloc/status18_bloc.dart';
import 'package:dsim_app/status/views/status18_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Status18Page extends StatelessWidget {
  const Status18Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Status18Bloc(),
      child: const Status18Form(),
    );
  }
}

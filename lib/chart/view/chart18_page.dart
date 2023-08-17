import 'package:dsim_app/chart/chart/chart18_bloc/chart18_bloc.dart';
import 'package:dsim_app/chart/view/chart18_form.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chart18Page extends StatelessWidget {
  const Chart18Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Chart18Bloc(
          dsimRepository: RepositoryProvider.of<DsimRepository>(context)),
      child: const Chart18Form(),
    );
  }
}

import 'package:aci_plus_app/advanced/bloc/setting18_dongle/setting18_dongle_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_dongle_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18DonglePage extends StatelessWidget {
  const Setting18DonglePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18DongleBloc(
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
      ),
      child: const Setting18DongleForm(),
    );
  }
}

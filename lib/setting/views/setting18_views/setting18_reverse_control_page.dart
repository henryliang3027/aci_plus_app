import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting18_reverse_control/setting18_reverse_control_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_reverse_control_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18ReverseControlPage extends StatelessWidget {
  const Setting18ReverseControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18ReverseControlBloc(
        amp18Repository: RepositoryProvider.of<Amp18Repository>(context),
      ),
      child: const Setting18ReverseControlView(),
    );
  }
}

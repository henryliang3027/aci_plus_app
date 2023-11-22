import 'package:aci_plus_app/repositories/dsim12_repository.dart';
import 'package:aci_plus_app/setting/bloc/setting_list_view_bloc/setting_list_view_bloc.dart';
import 'package:aci_plus_app/setting/views/setting_views/setting_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingListViewBloc(
        dsimRepository: RepositoryProvider.of<Dsim12Repository>(context),
      ),
      child: SettingForm(
        pageController: pageController,
      ),
    );
  }
}

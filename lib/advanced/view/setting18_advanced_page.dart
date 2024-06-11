import 'package:aci_plus_app/advanced/bloc/setting18_advanced/setting18_advanced_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_advanced_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18AdvancedPage extends StatelessWidget {
  const Setting18AdvancedPage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Setting18AdvancedBloc(),
      child: Setting18AdvancedForm(
        pageController: pageController,
      ),
    );
  }
}

import 'package:dsim_app/information/views/information_form.dart';
import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return InformationForm(
      pageController: pageController,
    );
  }
}

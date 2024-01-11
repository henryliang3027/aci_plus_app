import 'package:aci_plus_app/advanced/view/setting18_advanced_form.dart';
import 'package:flutter/material.dart';

class Setting18AdvancedPage extends StatelessWidget {
  const Setting18AdvancedPage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Setting18AdvancedForm(
      pageController: pageController,
    );
  }
}

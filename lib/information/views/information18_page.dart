import 'package:dsim_app/information/views/information18_form.dart';
import 'package:flutter/material.dart';

class Information18Page extends StatelessWidget {
  const Information18Page({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Information18Form(
      pageController: pageController,
    );
  }
}

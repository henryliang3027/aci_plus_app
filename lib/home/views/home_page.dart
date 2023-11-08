import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/views/home_form.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    setPreferredOrientation();
    return const Scaffold(
      body: HomeForm(),
    );
  }
}

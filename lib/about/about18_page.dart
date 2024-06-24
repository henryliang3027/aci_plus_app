import 'package:aci_plus_app/about/about18_form.dart';
import 'package:flutter/material.dart';

class About18Page extends StatelessWidget {
  const About18Page._({
    required this.appVersion,
  });

  static Route<void> route({
    required String appVersion,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => About18Page._(
        appVersion: appVersion,
      ),
    );
  }

  final String appVersion;

  @override
  Widget build(BuildContext context) {
    return About18Form(
      appVersion: appVersion,
    );
  }
}

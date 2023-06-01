import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:dsim_app/setting/views/circuit_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingGraphView extends StatelessWidget {
  SettingGraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        size: Size(400, 400),
        painter: CircuitPainter(),
      ),
    );
  }
}

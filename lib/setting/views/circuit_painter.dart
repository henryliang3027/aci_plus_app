import 'dart:math';

import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/setting/model/svg_image.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_views/setting18_ccor_node_graph_module_page.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_module_page.dart';
import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

class CircuitPainter extends CustomPainter {
  CircuitPainter({
    required this.context,
    required this.svgImage,
    required this.partId,
    required this.onDone,
  });

  final BuildContext context;
  final SVGImage svgImage;
  final String partId;
  final VoidCallback onDone;

  Future<void> showModuleSettingDialog({
    required BuildContext context,
    required String moduleName,
    bool editable = true,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;

        return Dialog(
          clipBehavior: Clip.antiAlias,
          insetPadding: EdgeInsets.symmetric(
            horizontal: width * 0.01,
            vertical: height * 0.01,
          ),
          child: partId == '4' // 4 表示 C-Cor Node
              ? Setting18CCorNodeGraphModulePage(
                  moduleName: moduleName,
                  editable: editable,
                )
              : Setting18GraphModulePage(
                  moduleName: moduleName,
                  editable: editable,
                ),
        );
      },
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Add null/zero size check
    if (size.isEmpty ||
        size.width == 0 ||
        size.height == 0 ||
        svgImage.width == 0 ||
        svgImage.height == 0) {
      return;
    }

    // print('Canvas size: $size');

    double scaleFactorX = size.width / svgImage.width;

    double scaleFactorY = size.height / svgImage.height;

    double scaleFactor = min(scaleFactorX, scaleFactorY);
    double offsetX = (size.width - svgImage.width * scaleFactor) / 2;
    double offsetY = (size.height - svgImage.height * scaleFactor) / 2;
    // print('offsetX : ${size.width}, ${svgImage.width}, ${scaleFactor}');
    // print('offsetX : ${offsetX}');
    // print('offsetY: : ${offsetY}');

    var myCanvas = TouchyCanvas(context, canvas);
    for (Box box in svgImage.boxes) {
      Rect rect = Rect.fromLTWH(
          box.x * scaleFactor + offsetX,
          box.y * scaleFactor + offsetY,
          box.width * scaleFactor,
          box.height * scaleFactor);

      Paint paint = Paint()
        ..color = const Color.fromARGB(0, 43, 255, 0)
        ..style = PaintingStyle.fill
        ..strokeWidth = 1.0;

      myCanvas.drawRect(
        rect,
        paint,
        onTapUp: (details) {
          showModuleSettingDialog(
            context: context,
            moduleName: box.moduleName,
            editable: svgImage.editable,
          ).then(
            (_) => onDone(),
          );
        },
      );
    }

    // print('scaleFactor: $scaleFactor');

    for (ValueText valueText in svgImage.valueTexts) {
      // final int colorHex = int.parse(valueText.color);
      TextStyle textStyle = TextStyle(
        fontSize: 82 * scaleFactor,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      );
      final textSpan = TextSpan(
        text: valueText.text,
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      textPainter.paint(
          canvas,
          Offset(
              (valueText.x + (238.365 / 2)) * scaleFactor +
                  offsetX -
                  (textPainter.width / 2),
              (valueText.y - 20) * scaleFactor +
                  offsetY -
                  (textPainter.height / 2)));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

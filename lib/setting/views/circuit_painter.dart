import 'dart:math';

import 'package:aci_plus_app/setting/model/svg_image.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_graph_module_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:touchable/touchable.dart';

class CircuitPainter extends CustomPainter {
  CircuitPainter({
    required this.context,
    required this.svgImage,
  });

  final BuildContext context;
  final SVGImage svgImage;

  Future<void> showModuleSettingDialog({
    required BuildContext context,
    required int moduleId,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;
        // var height = MediaQuery.of(context).size.height;

        return Dialog(
          child: Setting18GraphModulePage(moduleId: moduleId),
        );
      },
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    print('Canvas size: $size');

    double scaleFactorX = size.width / svgImage.width;

    double scaleFactorY = size.height / svgImage.height;

    double scaleFactor = min(scaleFactorX, scaleFactorY);
    double offsetX = (size.width - svgImage.width * scaleFactor) / 2;
    double offsetY = (size.height - svgImage.height * scaleFactor) / 2;

    print(offsetX);
    print(offsetY);

    // canvas.scale(scaleFactor);

    // canvas.translate(offsetX, offsetY);

    final translateM = Float64List.fromList([
      scaleFactor,
      0,
      0,
      0,
      0,
      scaleFactor,
      0,
      0,
      0,
      0,
      1,
      0,
      offsetX,
      offsetY,
      0,
      1,
    ]);

    canvas.transform(translateM);

    for (Component component in svgImage.components) {
      final Path path = parseSvgPathData(component.path);
      int decimalColor = int.parse(component.color, radix: 16);
      canvas.drawPath(
        path,
        Paint()..color = Color(decimalColor),
      );
    }

    var myCanvas = TouchyCanvas(context, canvas);
    for (Box box in svgImage.boxes) {
      // canvas.drawRRect(
      //   RRect.fromRectAndRadius(
      //       Rect.fromLTWH(box.x, box.y, box.width, box.height),
      //       Radius.circular(10.0)),
      //   Paint()
      //     ..color = Colors.black
      //     ..style = PaintingStyle.stroke
      //     ..strokeWidth = 2.0,
      // );
      myCanvas.drawRect(
          Rect.fromLTWH(
              box.x * scaleFactor + offsetX,
              box.y * scaleFactor + offsetY,
              box.width * scaleFactor,
              box.height * scaleFactor),
          Paint()..color = Colors.transparent, onTapUp: (details) {
        showModuleSettingDialog(
          context: context,
          moduleId: box.moduleId,
        );
      });
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

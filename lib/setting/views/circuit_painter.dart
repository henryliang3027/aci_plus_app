import 'dart:math';

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

    // final translateM = Float64List.fromList([
    //   scaleFactor,
    //   0,
    //   0,
    //   0,
    //   0,
    //   scaleFactor,
    //   0,
    //   0,
    //   0,
    //   0,
    //   1,
    //   0,
    //   offsetX,
    //   offsetY,
    //   0,
    //   1,
    // ]);

    // canvas.transform(translateM);

    // for (Component component in svgImage.components) {
    //   final Path path = parseSvgPathData(component.path);
    //   int decimalColor = int.parse(component.color, radix: 16);
    //   canvas.drawPath(
    //     path,
    //     Paint()..color = Color(decimalColor),
    //   );
    // }

    var myCanvas = TouchyCanvas(context, canvas);
    for (Box box in svgImage.boxes) {
      // final textStyle = TextStyle(
      //   background: Paint()..color = Color.fromARGB(255, 170, 214, 255),
      //   color: Colors.black,
      //   fontSize: 12,
      // );
      // final textSpan = TextSpan(
      //   text: '12 dB',
      //   style: textStyle,
      // );

      // final textPainter = TextPainter(
      //   text: textSpan,
      //   textDirection: TextDirection.ltr,
      // );
      // textPainter.layout(
      //   minWidth: 0,
      //   maxWidth: size.width,
      // );

      // textPainter.paint(
      //     canvas,
      //     Offset((box.x + box.width - 50) * scaleFactor + offsetX,
      //         (box.y + box.height - 50) * scaleFactor + offsetY));

      Rect rect = Rect.fromLTWH(
          box.x * scaleFactor + offsetX,
          box.y * scaleFactor + offsetY,
          box.width * scaleFactor,
          box.height * scaleFactor);

      Paint paint = Paint()
        ..color = Color.fromARGB(0, 43, 255, 0)
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

    for (ValueText valueText in svgImage.valueTexts) {
      // final int colorHex = int.parse(valueText.color);
      const textStyle = TextStyle(
          // background: Paint()..color = Color.fromARGB(255, 170, 214, 255),
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold);
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

      print(textPainter.height);

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

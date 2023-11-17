import 'package:aci_plus_app/setting/model/component.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:touchable/touchable.dart';

class CircuitPainter extends CustomPainter {
  CircuitPainter({
    required this.context,
    required this.svgPaths,
    required this.boxes,
  });

  final BuildContext context;
  final List<Component> svgPaths;
  final List<Box> boxes;

  Future<void> showResultDialog({
    required BuildContext context,
    required String message,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;
        // var height = MediaQuery.of(context).size.height;

        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: width * 0.1,
          ),
          title: const Text("Setting"),
          content: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: ListBody(
                children: [Text(message)],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true); // pop dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context, canvas);

    for (Component svgPath in svgPaths) {
      final Path path = parseSvgPathData(svgPath.path);
      int decimalColor = int.parse(svgPath.color, radix: 16);
      canvas.drawPath(
        path,
        Paint()..color = Color(decimalColor),
      );
    }

    for (Box box in boxes) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(box.x, box.y, box.width, box.height),
            Radius.circular(10.0)),
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
      myCanvas.drawRect(Rect.fromLTWH(box.x, box.y, box.width, box.height),
          Paint()..color = Colors.transparent, onTapUp: (details) {
        showResultDialog(context: context, message: 'Tap!!!!!');
      });
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

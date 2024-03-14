import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/setting/model/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

class NamePlateView extends StatelessWidget {
  const NamePlateView({
    super.key,
    required this.partId,
  });

  final String partId;

  static Route<void> route({
    required String partId,
  }) {
    return MaterialPageRoute(
        builder: (_) => NamePlateView(
              partId: partId,
            ));
  }

  @override
  Widget build(BuildContext context) {
    setFullScreenOrientation();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: _NamePlateInteractor(
        partId: partId,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(
          side: BorderSide.none,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
        child: Icon(
          CustomIcons.cancel,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () {
          setPreferredOrientation();
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _NamePlateInteractor extends StatelessWidget {
  const _NamePlateInteractor({
    super.key,
    required this.partId,
  });

  final String partId;

  @override
  Widget build(BuildContext context) {
    String namePlatePath = namePlateFilePath[partId] ?? '';

    Future<SVGImage> _getSVGImage() async {
      String generalString =
          await rootBundle.loadString('assets/nameplates/BLE.svg');

      XmlDocument document = XmlDocument.parse(generalString);

      final paths = document.findAllElements('path');
      // final rects = document.findAllElements('rect');
      final header = document.findElements('svg').toList()[0];
      final double width =
          double.parse(header.getAttribute('width').toString());
      final double height =
          double.parse(header.getAttribute('height').toString());

      List<Component> components = [];
      List<Box> boxes = [];

      for (var element in paths) {
        String? fill = element.getAttribute('fill');
        String? stroke = element.getAttribute('stroke');
        String partColor;

        if (fill != null) {
          if (fill.toString() == 'none') {
            partColor = 'ff000000';
          } else {
            partColor = 'ff${fill.toString().substring(1)}';
          }
        } else {
          partColor = 'ff000000';
        }

        String partPath = element.getAttribute('d').toString();

        components.add(Component(color: partColor, path: partPath));
      }

      SVGImage namePlateImage = SVGImage(
        width: width,
        height: height,
        components: components,
        boxes: boxes,
      );

      return namePlateImage;
    }

    return PopScope(
      onPopInvoked: (bool canPop) async {
        setPreferredOrientation();
      },
      child: InteractiveViewer(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: namePlatePath.isNotEmpty
              ? Image.asset(namePlatePath)
              : const Icon(
                  Icons.warning_rounded,
                  size: 200,
                  color: Color(0xffffc107),
                ),
        ),
      ),
      //     FutureBuilder(
      //   future: _getSVGImage(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       SVGImage svgImage = snapshot.data!;

      //       return InteractiveViewer(
      //         child: SizedBox(
      //           width: MediaQuery.of(context).size.width,
      //           height: MediaQuery.of(context).size.height,
      //           child: CanvasTouchDetector(
      //             builder: (context) => CustomPaint(
      //                 painter: CircuitPainter(
      //               context: context,
      //               svgImage: svgImage,
      //             )),
      //             gesturesToOverride: [GestureType.onTapUp],
      //           ),
      //         ),
      //       );
      //     } else {
      //       if (snapshot.hasError) {
      //         print(snapshot.error.toString());
      //       }
      //       return const Center(
      //         child: SizedBox(
      //           width: CustomStyle.diameter,
      //           height: CustomStyle.diameter,
      //           child: CircularProgressIndicator(),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
}

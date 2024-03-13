import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/setting/model/svg_image.dart';
import 'package:aci_plus_app/setting/views/circuit_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:touchable/touchable.dart';

class NamePlateView extends StatelessWidget {
  const NamePlateView({
    super.key,
    required this.namePlateImage,
  });

  final SVGImage namePlateImage;

  static Route<void> route({
    required SVGImage namePlateImage,
  }) {
    return MaterialPageRoute(
        builder: (_) => NamePlateView(
              namePlateImage: namePlateImage,
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
        namePlateImage: namePlateImage,
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
    required this.namePlateImage,
  });

  final SVGImage namePlateImage;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setPreferredOrientation();
        return true;
      },
      child: InteractiveViewer(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset('assets/nameplates/BLE.png'),

          // SvgPicture.asset('assets/nameplates/BLE.svg',
          //     // colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
          //     semanticsLabel: 'A red up arrow'),
        ),

        // Stack(
        //   alignment: AlignmentDirectional.center,
        //   children: [
        //     Container(
        //       width: MediaQuery.of(context).size.width,
        //       height: MediaQuery.of(context).size.height,
        //       child: CanvasTouchDetector(
        //         builder: (context) => CustomPaint(
        //             painter: CircuitPainter(
        //           context: context,
        //           svgImage: namePlateImage,
        //         )),
        //         gesturesToOverride: [GestureType.onTapUp],
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

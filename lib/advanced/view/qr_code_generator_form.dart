import 'dart:ui' as ui;
import 'package:aci_plus_app/advanced/bloc/qr_code_generator/qr_code_generator_bloc.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class QRCodeGeneratorForm extends StatelessWidget {
  QRCodeGeneratorForm({
    super.key,
    required this.encodedData,
  });

  final String encodedData;
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<QRCodeGeneratorBloc, QRCodeGeneratorState>(
      listener: (context, state) {
        if (state.imageSaveStatus.isRequestSuccess) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          Share.shareXFiles(
            [XFile(state.imageFilePath)],
            subject: 'QR Code',
            text: 'QR Code',
            sharePositionOrigin:
                Rect.fromLTWH(0.0, height / 2, width, height / 2),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _QRCodeViewer(
              encodedData: encodedData,
              globalKey: globalKey,
            ),
            const SizedBox(
              height: 28,
            ),
            _QrCodeTool(
              globalKey: globalKey,
            ),
          ],
        ),
      ),
    );
  }
}

class _QRCodeViewer extends StatelessWidget {
  _QRCodeViewer({
    super.key,
    required this.encodedData,
    required this.globalKey,
  });

  final String encodedData;
  final GlobalKey globalKey;

  @override
  Widget build(BuildContext context) {
    // String test = [
    //   for (int i = 0; i < 2953; i++) ...['1']
    // ].join();

    // print(test.length);

    return RepaintBoundary(
      key: globalKey,
      child: QrImageView(
        data: encodedData,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        size: 360,
        gapless: false,
        embeddedImage: const AssetImage('assets/qr_logo.png'),
        embeddedImageStyle: const QrEmbeddedImageStyle(
          size: Size(50, 50),
        ),
      ),
    );
  }
}

class _QrCodeTool extends StatelessWidget {
  const _QrCodeTool({
    super.key,
    required this.globalKey,
  });

  final GlobalKey globalKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.dialogMessageCancel,
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          ElevatedButton(
            onPressed: () async {
              final RenderRepaintBoundary boundary = globalKey.currentContext!
                  .findRenderObject() as RenderRepaintBoundary;
              final ui.Image image = await boundary.toImage();

              image.toByteData(format: ui.ImageByteFormat.png).then((byteData) {
                if (byteData != null) {
                  context
                      .read<QRCodeGeneratorBloc>()
                      .add(QRCodeSaved(byteData));
                }
              });
            },
            child: Text(
              AppLocalizations.of(context)!.share,
            ),
          ),
          // ElevatedButton(
          //   style: ButtonStyle(
          //     elevation: MaterialStateProperty.resolveWith((states) => 0.0),
          //     shape: MaterialStateProperty.resolveWith(
          //       (states) => const CircleBorder(),
          //     ),
          //     backgroundColor: MaterialStateProperty.resolveWith(
          //       (states) => Colors.transparent,
          //     ),
          //   ),
          //   child: Column(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 4.0),
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Theme.of(context).colorScheme.primary,
          //             shape: BoxShape.circle,
          //           ),
          //           child: Padding(
          //             padding: const EdgeInsets.all(20.0),
          //             child: Icon(
          //               Icons.share,
          //               color: Theme.of(context).colorScheme.onPrimary,
          //             ),
          //           ),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(
          //           bottom: 10.0,
          //         ),
          //         child: Text(
          //           AppLocalizations.of(context)!.share,
          //           style: const TextStyle(
          //             fontSize: CustomStyle.sizeL,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}

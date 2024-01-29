import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:screenshot/screenshot.dart';

class QRCodeGeneratorForm extends StatelessWidget {
  QRCodeGeneratorForm({
    super.key,
    required this.encodedData,
  });

  final String encodedData;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QRCodeViewer(
            encodedData: encodedData,
            screenshotController: screenshotController,
          ),
          const SizedBox(
            height: 28,
          ),
          _QrCodeTool(
            screenshotController: screenshotController,
          ),
        ],
      ),
    );
  }
}

class _QRCodeViewer extends StatelessWidget {
  _QRCodeViewer({
    super.key,
    required this.encodedData,
    required this.screenshotController,
  });

  final String encodedData;
  final ScreenshotController screenshotController;

  @override
  Widget build(BuildContext context) {
    // String test = [
    //   for (int i = 0; i < 2953; i++) ...['1']
    // ].join();

    // print(test.length);

    return Screenshot(
      controller: screenshotController,
      child: QrImageView(
        data: encodedData,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
        size: 360,
        gapless: false,
      ),
    );
  }
}

class _QrCodeTool extends StatelessWidget {
  const _QrCodeTool({
    super.key,
    required this.screenshotController,
  });

  final ScreenshotController screenshotController;

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
            onPressed: () {
              // screenshotController
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

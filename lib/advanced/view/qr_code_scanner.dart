import 'dart:io';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  static Route<String> route() {
    return MaterialPageRoute(
      builder: (_) => const QRCodeScanner(),
    );
  }

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRCodeScanner> {
  Barcode? result;
  QRViewController? controller;
  bool isOpenFlash = false;
  bool isInvalid = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          _buildQrView(context),
          isInvalid
              ? Positioned(
                  bottom: 200,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(26),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 10),
                      child: Text(
                        AppLocalizations.of(context)!
                            .dialogMessageInvalidQRCode,
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeXL,
                          color: CustomStyle.customRed,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          Positioned(
            bottom: 50,
            child: Row(
              children: [
                FloatingActionButton(
                  heroTag: null,
                  shape: const CircleBorder(
                    side: BorderSide.none,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    CustomIcons.cancel,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  width: 20.0,
                ),
                FloatingActionButton(
                  heroTag: null,
                  shape: const CircleBorder(
                    side: BorderSide.none,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    isOpenFlash
                        ? Icons.flashlight_on
                        : Icons.flashlight_on_outlined,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {
                      isOpenFlash = !isOpenFlash;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).colorScheme.onPrimary,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  Future<void> showDecodeFailureDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.dialogTitleError,
            style: const TextStyle(
              color: CustomStyle.customRed,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.dialogMessageInvalidQRCode,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // pop dialog
              },
            ),
          ],
        );
      },
    );
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // print('${scanData.code}');

      printWrapped('${scanData.code}');

      if (scanData.code != null) {
        if (RegexUtil.configJsonRegex.hasMatch(scanData.code!) ||
            RegexUtil.configJsonRegex220.hasMatch(scanData.code!)) {
          if (isInvalid) {
            setState(() {
              isInvalid = false;
            });
          }
          if (ModalRoute.of(context)?.isCurrent == true) {
            Navigator.pop(context, scanData.code);
          }
        } else {
          if (!isInvalid) {
            setState(() {
              isInvalid = true;
            });
          }
        }
      }

      // if (ModalRoute.of(context)?.isCurrent == true) {
      //   Navigator.pop(context, scanData.code);
      // }

      // setState(() {
      //   result = scanData;
      // });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

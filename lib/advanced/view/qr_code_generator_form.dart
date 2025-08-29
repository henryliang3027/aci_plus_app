import 'dart:io';
import 'dart:ui' as ui;
import 'package:aci_plus_app/advanced/bloc/qr_code_generator/qr_code_generator_bloc.dart';
import 'package:aci_plus_app/chart/shared/share_file_widget.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRCodeGeneratorForm extends StatelessWidget {
  QRCodeGeneratorForm({
    super.key,
  });

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<QRCodeGeneratorBloc, QRCodeGeneratorState>(
      listener: (context, state) {
        if (state.imageSaveStatus.isRequestSuccess) {
          openShareFileWidget(
            context: context,
            subject: state.description,
            body: state.description,
            attachmentPath: state.imageFilePath,
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              _QRCodeViewer(
                globalKey: globalKey,
              ),
              const SizedBox(
                height: 30.0,
              ),
              _QrCodeTool(
                globalKey: globalKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QRCodeViewer extends StatelessWidget {
  const _QRCodeViewer({
    required this.globalKey,
  });

  final GlobalKey globalKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRCodeGeneratorBloc, QRCodeGeneratorState>(
      builder: (context, state) {
        return RepaintBoundary(
          key: globalKey,
          child: Container(
            // 避免分享截圖時, 註記的背景為透明導致看不清楚
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                QrImageView(
                  padding: const EdgeInsets.all(20.0),
                  data: state.encodedData,
                  version: QrVersions.auto,
                  errorCorrectionLevel: QrErrorCorrectLevel.L,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  gapless: true,
                  // embeddedImage: const AssetImage('assets/qr_logo.png'),
                  // embeddedImageStyle: const QrEmbeddedImageStyle(
                  //   size: Size(50, 50),
                  // ),
                ),
                Text(
                  state.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black, // 淺色/深色主題都為黑色
                  ),
                ),
                const SizedBox(
                  height: 6.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QrCodeTool extends StatelessWidget {
  const _QrCodeTool({
    required this.globalKey,
  });

  final GlobalKey globalKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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
            onPressed: Platform.isWindows
                ? () async {
                    final RenderRepaintBoundary boundary =
                        globalKey.currentContext!.findRenderObject()
                            as RenderRepaintBoundary;
                    final ui.Image image = await boundary.toImage();

                    image
                        .toByteData(format: ui.ImageByteFormat.png)
                        .then((byteData) {
                      if (byteData != null) {
                        context
                            .read<QRCodeGeneratorBloc>()
                            .add(QRCodeSaved(byteData));
                      }
                    });
                  }
                : () async {
                    final RenderRepaintBoundary boundary =
                        globalKey.currentContext!.findRenderObject()
                            as RenderRepaintBoundary;
                    final ui.Image image = await boundary.toImage();

                    image
                        .toByteData(format: ui.ImageByteFormat.png)
                        .then((byteData) {
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
        ],
      ),
    );
  }
}

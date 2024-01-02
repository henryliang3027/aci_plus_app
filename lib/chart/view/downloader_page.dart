import 'package:aci_plus_app/chart/downloader_bloc/downloader_bloc.dart';
import 'package:aci_plus_app/chart/view/downloader_form.dart';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloaderPage extends StatelessWidget {
  const DownloaderPage({
    super.key,
    required this.aciDeviceType,
  });

  final ACIDeviceType aciDeviceType;

  @override
  Widget build(BuildContext context) {
    Function(int) getRequestFunction() {
      if (aciDeviceType == ACIDeviceType.amp1P8G) {
        return RepositoryProvider.of<Amp18Repository>(context)
            .requestCommand1p8GForLogChunk;
      } else if (aciDeviceType == ACIDeviceType.ampCCorNode1P8G) {
        return RepositoryProvider.of<Amp18CCorNodeRepository>(context)
            .requestCommand1p8GCCorNodeLogChunk;
      } else {
        throw Exception('Unsupported ACIDeviceType');
      }
    }

    try {
      return BlocProvider(
        create: (context) => DownloaderBloc(
          requestLogChunk: getRequestFunction(),
        ),
        child: const DownloaderForm(),
      );
    } catch (e) {
      print('Exception caught: $e');
      // Handle the exception or provide a default behavior
      return Text('An error occurred: $e');
    }
  }
}

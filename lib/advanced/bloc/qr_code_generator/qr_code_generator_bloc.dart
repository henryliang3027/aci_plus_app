import 'dart:io';
import 'dart:typed_data';

import 'package:aci_plus_app/core/form_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

part 'qr_code_generator_event.dart';
part 'qr_code_generator_state.dart';

class QRCodeGeneratorBloc
    extends Bloc<QRCodeGeneratorEvent, QRCodeGeneratorState> {
  QRCodeGeneratorBloc() : super(const QRCodeGeneratorState()) {
    on<QRCodeSaved>(_onQRCodeSaved);
  }

  Future<void> _onQRCodeSaved(
    QRCodeSaved event,
    Emitter<QRCodeGeneratorState> emit,
  ) async {
    emit(state.copyWith(
      imageSaveStatus: FormStatus.requestInProgress,
    ));

    String dateTime = DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now());

    final Uint8List imageBytes = event.byteData.buffer.asUint8List();
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String imageFileName = 'QR_Code_$dateTime.png';
    final String imageFilePath = '$directory/$imageFileName';
    File imgFile = File(imageFilePath);
    await imgFile.writeAsBytes(imageBytes);

    emit(state.copyWith(
      imageSaveStatus: FormStatus.requestSuccess,
      imageFileName: imageFileName,
      imageFilePath: imageFilePath,
    ));
  }
}

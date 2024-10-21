import 'dart:io';
import 'dart:typed_data';

import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

part 'qr_code_generator_event.dart';
part 'qr_code_generator_state.dart';

class QRCodeGeneratorBloc
    extends Bloc<QRCodeGeneratorEvent, QRCodeGeneratorState> {
  QRCodeGeneratorBloc({
    required String encodedData,
    required String description,
    required ConfigRepository configRepository,
  })  : _configRepository = configRepository,
        super(QRCodeGeneratorState(
          encodedData: encodedData,
          description: description,
        )) {
    on<QRCodeSaved>(_onQRCodeSaved);
  }

  final ConfigRepository _configRepository;

  Future<void> _onQRCodeSaved(
    QRCodeSaved event,
    Emitter<QRCodeGeneratorState> emit,
  ) async {
    emit(state.copyWith(
      imageSaveStatus: FormStatus.requestInProgress,
    ));

    final Uint8List imageBytes = event.byteData.buffer.asUint8List();

    List<dynamic> result = await _configRepository.saveGenretatedQRCode(
      description: state.description,
      imageBytes: imageBytes,
    );

    if (result[0]) {
      emit(state.copyWith(
        imageSaveStatus: FormStatus.requestSuccess,
        imageFileName: result[1],
        imageFilePath: result[2],
      ));
    } else {
      emit(state.copyWith(
        imageSaveStatus: FormStatus.requestFailure,
        imageFileName: '',
        imageFilePath: '',
      ));
    }
  }
}

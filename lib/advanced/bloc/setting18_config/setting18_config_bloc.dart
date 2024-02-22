import 'dart:convert';

import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/config_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_config_event.dart';
part 'setting18_config_state.dart';

class Setting18ConfigBloc
    extends Bloc<Setting18ConfigEvent, Setting18ConfigState> {
  Setting18ConfigBloc({
    required Amp18Repository amp18repository,
  })  : _amp18repository = amp18repository,
        _configApi = ConfigApi(),
        super(const Setting18ConfigState()) {
    on<QRDataGenerated>(_onQRDataGenerated);
  }

  final Amp18Repository _amp18repository;
  final ConfigApi _configApi;

  void _onQRDataGenerated(
    QRDataGenerated event,
    Emitter<Setting18ConfigState> emit,
  ) {
    emit(state.copyWith(
      encodeStaus: FormStatus.requestInProgress,
    ));

    List<dynamic> result = _configApi.getConfigByPartId(event.selectedPartId);

    if (result[0]) {
      Config config = result[1];

      // StringBuffer stringBuffer = StringBuffer();

      // stringBuffer.write('${event.selectedPartId},');
      // stringBuffer.write('${config.firstChannelLoadingFrequency},');
      // stringBuffer.write('${config.firstChannelLoadingLevel},');
      // stringBuffer.write('${config.lastChannelLoadingFrequency},');
      // stringBuffer.write(config.lastChannelLoadingLevel);

      String encodedData = jsonEncode(config.toJson());

      emit(state.copyWith(
        encodeStaus: FormStatus.requestSuccess,
        encodedData: encodedData,
      ));
    } else {
      StringBuffer stringBuffer = StringBuffer();

      stringBuffer.write('${event.selectedPartId},');
      stringBuffer.write('258,');
      stringBuffer.write('34.0,');
      stringBuffer.write('1794,');
      stringBuffer.write('51.1');

      String encodedData = stringBuffer.toString();

      emit(state.copyWith(
        encodeStaus: FormStatus.requestSuccess,
        encodedData: encodedData,
      ));
    }
  }
}

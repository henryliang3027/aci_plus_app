import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim18_parser.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_chart/speed_chart.dart';

part 'chart18_event.dart';
part 'chart18_state.dart';

class Chart18Bloc extends Bloc<Chart18Event, Chart18State> {
  Chart18Bloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const Chart18State()) {
    on<DataExported>(_onDataExported);
    on<DataShared>(_onDataShared);
    on<AllDataExported>(_onAllDataExported);
  }

  final DsimRepository _dsimRepository;

  void _onDataExported(
    DataExported event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.requestInProgress,
      dataShareStatus: FormStatus.none,
      allDataDownloadStatus: FormStatus.none,
    ));

    final List<dynamic> result = await _dsimRepository.export1p8GRecords(
      log1p8Gs: state.log1p8Gs,
      event1p8Gs: state.event1p8Gs,
    );

    if (result[0]) {
      emit(state.copyWith(
        dataExportStatus: FormStatus.requestSuccess,
        dataExportPath: result[2],
      ));
    } else {
      emit(state.copyWith(
        dataExportStatus: FormStatus.requestFailure,
        dataExportPath: result[2],
      ));
    }
  }

  void _onDataShared(
    DataShared event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.requestInProgress,
      allDataDownloadStatus: FormStatus.none,
    ));

    final List<dynamic> result = await _dsimRepository.export1p8GRecords(
      log1p8Gs: state.log1p8Gs,
      event1p8Gs: state.event1p8Gs,
    );

    if (result[0]) {
      emit(state.copyWith(
        dataShareStatus: FormStatus.requestSuccess,
        exportFileName: result[1],
        dataExportPath: result[2],
      ));
    } else {
      emit(state.copyWith(
        dataShareStatus: FormStatus.requestFailure,
        exportFileName: result[1],
        dataExportPath: result[2],
      ));
    }
  }

  void _onAllDataExported(
    AllDataExported event,
    Emitter<Chart18State> emit,
  ) async {
    if (event.isSuccessful) {
      final List<dynamic> result = await _dsimRepository.export1p8GRecords(
        log1p8Gs: event.log1p8Gs,
        event1p8Gs: state.event1p8Gs,
      );

      if (result[0]) {
        emit(state.copyWith(
          allDataDownloadStatus: FormStatus.requestSuccess,
          dataExportPath: result[2],
        ));
      } else {
        emit(state.copyWith(
          allDataDownloadStatus: FormStatus.requestFailure,
          dataExportPath: result[2],
        ));
      }
    } else {
      emit(state.copyWith(
        allDataDownloadStatus: FormStatus.requestFailure,
        errorMessage: event.errorMessage,
      ));
    }
  }
}

import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chart18_event.dart';
part 'chart18_state.dart';

class Chart18Bloc extends Bloc<Chart18Event, Chart18State> {
  Chart18Bloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const Chart18State()) {
    on<TabChangedEnabled>(_onTabChangedEnabled);
    on<TabChangedDisabled>(_onTabChangedDisabled);
    on<DataExported>(_onDataExported);
    on<DataShared>(_onDataShared);
    on<AllDataExported>(_onAllDataExported);
    on<RFLevelShared>(_onRFLevelShared);
    on<RFLevelExported>(_onRFLevelExported);
  }

  final Amp18Repository _amp18Repository;

  void _onTabChangedEnabled(
    TabChangedEnabled event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.none,
      rfLevelExportStatus: FormStatus.none,
      rfLevelShareStatus: FormStatus.none,
      enableTabChange: true,
    ));
  }

  void _onTabChangedDisabled(
    TabChangedDisabled event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.none,
      rfLevelExportStatus: FormStatus.none,
      rfLevelShareStatus: FormStatus.none,
      enableTabChange: false,
    ));
  }

  void _onDataExported(
    DataExported event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.requestInProgress,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.none,
      rfLevelExportStatus: FormStatus.none,
      rfLevelShareStatus: FormStatus.none,
    ));

    final List<dynamic> result = await _amp18Repository.export1p8GRecords(
        code: event.code,
        configurationData: event.configurationData,
        controlData: event.controlData);

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
      allDataExportStatus: FormStatus.none,
      rfLevelExportStatus: FormStatus.none,
      rfLevelShareStatus: FormStatus.none,
    ));

    final List<dynamic> result = await _amp18Repository.export1p8GRecords(
      code: event.code,
      configurationData: event.configurationData,
      controlData: event.controlData,
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
      // 清除 cache
      _amp18Repository.clearAllLog1p8Gs();

      // 將所有 log 寫入 cache
      _amp18Repository.writeAllLog1p8Gs(event.log1p8Gs);
      final List<dynamic> result = await _amp18Repository.exportAll1p8GRecords(
        code: event.code,
        configurationData: event.configurationData,
        controlData: event.controlData,
      );

      if (result[0]) {
        emit(state.copyWith(
          allDataExportStatus: FormStatus.requestSuccess,
          dataExportPath: result[2],
        ));
      } else {
        emit(state.copyWith(
          allDataExportStatus: FormStatus.requestFailure,
          dataExportPath: result[2],
        ));
      }
    } else {
      emit(state.copyWith(
        allDataExportStatus: FormStatus.requestFailure,
        errorMessage: event.errorMessage,
      ));
    }
  }

  void _onRFLevelExported(
    RFLevelExported event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.none,
      rfLevelExportStatus: FormStatus.requestInProgress,
      rfLevelShareStatus: FormStatus.none,
    ));

    final List<dynamic> result = await _amp18Repository.export1p8GRFInOuts(
      code: event.code,
    );

    if (result[0]) {
      emit(state.copyWith(
        rfLevelExportStatus: FormStatus.requestSuccess,
        dataExportPath: result[2],
      ));
    } else {
      emit(state.copyWith(
        rfLevelExportStatus: FormStatus.requestFailure,
        dataExportPath: result[2],
      ));
    }
  }

  void _onRFLevelShared(
    RFLevelShared event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.none,
      rfLevelExportStatus: FormStatus.none,
      rfLevelShareStatus: FormStatus.requestInProgress,
    ));

    final List<dynamic> result = await _amp18Repository.export1p8GRFInOuts(
      code: event.code,
    );

    if (result[0]) {
      emit(state.copyWith(
        rfLevelShareStatus: FormStatus.requestSuccess,
        exportFileName: result[1],
        dataExportPath: result[2],
      ));
    } else {
      emit(state.copyWith(
        rfLevelShareStatus: FormStatus.requestFailure,
        exportFileName: result[1],
        dataExportPath: result[2],
      ));
    }
  }
}

import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_firmware_log_event.dart';
part 'setting18_firmware_log_state.dart';

class Setting18FirmwareLogBloc
    extends Bloc<Setting18FirmwareLogEvent, Setting18FirmwareLogState> {
  Setting18FirmwareLogBloc({required FirmwareRepository firmwareRepository})
      : _firmwareRepository = firmwareRepository,
        super(const Setting18FirmwareLogState()) {
    on<UpdateLogRequested>(_onUpdateLogRequested);
    on<TestUpdateLogRequested>(_onTestUpdateLogRequested);
    on<TestAllUpdateLogDeleted>(_onTestAllUpdateLogDeleted);
  }

  final FirmwareRepository _firmwareRepository;

  Future<void> _onUpdateLogRequested(
    UpdateLogRequested event,
    Emitter<Setting18FirmwareLogState> emit,
  ) async {
    emit(state.copyWith(
      updateLogStatus: FormStatus.requestInProgress,
    ));

    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      List<dynamic> resultOfGetUpdateLogs =
          await _firmwareRepository.requestCommand1p8GUpdateLogs();

      if (resultOfGetUpdateLogs[0]) {
        List<UpdateLog> updateLogs = resultOfGetUpdateLogs[1];

        emit(state.copyWith(
          updateLogStatus: FormStatus.requestSuccess,
          updateLogs: updateLogs,
        ));
        break;
      } else {
        if (i == 2) {
          emit(state.copyWith(
            updateLogStatus: FormStatus.requestFailure,
            updateLogs: [],
            errorMessage: 'Failed to load logs',
          ));
        }
      }
    }

    // List<UpdateLog> updateLogs = [
    //   const UpdateLog(
    //     type: UpdateType.upgrade,
    //     datetime: '20241231140723',
    //     version: '148',
    //     technicianID: '12345678',
    //   ),
    //   const UpdateLog(
    //     type: UpdateType.downgrade,
    //     datetime: '20241231140723',
    //     version: '146',
    //     technicianID: '12345678',
    //   ),
    //   const UpdateLog(
    //     type: UpdateType.downgrade,
    //     datetime: '20241231140723',
    //     version: '147',
    //     technicianID: '12345678',
    //   ),
    //   const UpdateLog(
    //     type: UpdateType.upgrade,
    //     datetime: '20241231140723',
    //     version: '148',
    //     technicianID: '12345678',
    //   )
    // ];
  }

  Future<void> _onTestUpdateLogRequested(
    TestUpdateLogRequested event,
    Emitter<Setting18FirmwareLogState> emit,
  ) async {
    emit(state.copyWith(
      updateLogStatus: FormStatus.requestInProgress,
    ));

    List<UpdateLog> updateLogs = List.from(state.updateLogs);
    String userCode = '12345678';

    UpdateLog updateLog = UpdateLog(
      type:
          updateLogs.length.isEven ? UpdateType.upgrade : UpdateType.downgrade,
      dateTime: DateTime.now(),
      firmwareVersion: '148',
      technicianID: userCode,
    );

    // 滿 32 筆時清除最舊的一筆
    if (updateLogs.length == 32) {
      updateLogs.removeLast();
    }
    updateLogs.insert(0, updateLog);

    await _firmwareRepository.set1p8GFirmwareUpdateLogs(updateLogs);

    List<dynamic> resultOgGetUpdateLogs =
        await _firmwareRepository.requestCommand1p8GUpdateLogs();

    if (resultOgGetUpdateLogs[0]) {
      List<UpdateLog> updateLogs = resultOgGetUpdateLogs[1];

      emit(state.copyWith(
        updateLogStatus: FormStatus.requestSuccess,
        updateLogs: updateLogs,
      ));
    }
  }

  Future<void> _onTestAllUpdateLogDeleted(
    TestAllUpdateLogDeleted event,
    Emitter<Setting18FirmwareLogState> emit,
  ) async {
    emit(state.copyWith(updateLogStatus: FormStatus.requestInProgress));

    await _firmwareRepository.set1p8GFirmwareUpdateLogs([]);

    List<dynamic> resultOgGetUpdateLogs =
        await _firmwareRepository.requestCommand1p8GUpdateLogs();

    if (resultOgGetUpdateLogs[0]) {
      List<UpdateLog> updateLogs = resultOgGetUpdateLogs[1];

      emit(state.copyWith(
        updateLogStatus: FormStatus.requestSuccess,
        updateLogs: updateLogs,
      ));
    }
  }
}

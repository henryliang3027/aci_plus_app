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

    add(const UpdateLogRequested());
  }

  final FirmwareRepository _firmwareRepository;

  void _onUpdateLogRequested(
    UpdateLogRequested event,
    Emitter<Setting18FirmwareLogState> emit,
  ) {
    emit(state.copyWith(
      updateLogStatus: FormStatus.requestInProgress,
    ));

    // List<UpdateLog> updateLogs = _firmwareRepository.getUpdateLogs();

    List<UpdateLog> updateLogs = [
      const UpdateLog(
        type: UpdateType.upgrade,
        datetime: '20241231140723',
        version: '148',
        technicianID: '12345678',
      ),
      const UpdateLog(
        type: UpdateType.downgrade,
        datetime: '20241231140723',
        version: '146',
        technicianID: '12345678',
      ),
      const UpdateLog(
        type: UpdateType.downgrade,
        datetime: '20241231140723',
        version: '147',
        technicianID: '12345678',
      ),
      const UpdateLog(
        type: UpdateType.upgrade,
        datetime: '20241231140723',
        version: '148',
        technicianID: '12345678',
      )
    ];

    emit(state.copyWith(
      updateLogStatus: FormStatus.requestSuccess,
      updateLogs: updateLogs,
    ));
  }
}

part of 'setting18_firmware_log_bloc.dart';

class Setting18FirmwareLogState extends Equatable {
  const Setting18FirmwareLogState({
    this.updateLogStatus = FormStatus.none,
    this.updateLogs = const [],
    this.message = '',
  });

  final FormStatus updateLogStatus;
  final List<UpdateLog> updateLogs;
  final String message;

  Setting18FirmwareLogState copyWith({
    FormStatus? updateLogStatus,
    List<UpdateLog>? updateLogs,
    String? message,
  }) {
    return Setting18FirmwareLogState(
      updateLogStatus: updateLogStatus ?? this.updateLogStatus,
      updateLogs: updateLogs ?? this.updateLogs,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        updateLogStatus,
        updateLogs,
        message,
      ];
}

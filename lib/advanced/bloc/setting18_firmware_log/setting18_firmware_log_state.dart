part of 'setting18_firmware_log_bloc.dart';

class Setting18FirmwareLogState extends Equatable {
  const Setting18FirmwareLogState({
    this.updateLogStatus = FormStatus.none,
    this.updateLogs = const [],
    this.errorMessage = '',
  });

  final FormStatus updateLogStatus;
  final List<UpdateLog> updateLogs;
  final String errorMessage;

  Setting18FirmwareLogState copyWith({
    FormStatus? updateLogStatus,
    List<UpdateLog>? updateLogs,
    String? errorMessage,
  }) {
    return Setting18FirmwareLogState(
      updateLogStatus: updateLogStatus ?? this.updateLogStatus,
      updateLogs: updateLogs ?? this.updateLogs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        updateLogStatus,
        updateLogs,
        errorMessage,
      ];
}

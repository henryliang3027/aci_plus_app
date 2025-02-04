part of 'setting18_firmware_log_bloc.dart';

class Setting18FirmwareLogState extends Equatable {
  const Setting18FirmwareLogState({
    this.updateLogStatus = FormStatus.none,
    this.updateLogExportStatus = FormStatus.none,
    this.updateLogs = const [],
    this.errorMessage = '',
    this.updateLogExportPath = '',
  });

  final FormStatus updateLogStatus;
  final FormStatus updateLogExportStatus;
  final List<UpdateLog> updateLogs;
  final String errorMessage;
  final String updateLogExportPath;

  Setting18FirmwareLogState copyWith({
    FormStatus? updateLogStatus,
    FormStatus? updateLogExportStatus,
    List<UpdateLog>? updateLogs,
    String? errorMessage,
    String? updateLogExportPath,
  }) {
    return Setting18FirmwareLogState(
      updateLogStatus: updateLogStatus ?? this.updateLogStatus,
      updateLogExportStatus:
          updateLogExportStatus ?? this.updateLogExportStatus,
      updateLogs: updateLogs ?? this.updateLogs,
      errorMessage: errorMessage ?? this.errorMessage,
      updateLogExportPath: updateLogExportPath ?? this.updateLogExportPath,
    );
  }

  @override
  List<Object> get props => [
        updateLogStatus,
        updateLogExportStatus,
        updateLogs,
        errorMessage,
        updateLogExportPath,
      ];
}

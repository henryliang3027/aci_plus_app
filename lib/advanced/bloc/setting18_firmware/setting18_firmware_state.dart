part of 'setting18_firmware_bloc.dart';

class Setting18FirmwareState extends Equatable {
  const Setting18FirmwareState({
    this.binaryLoadStatus = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.currentFirmwareVersion = 0,
    this.selectedBinaryInfo = const BinaryInfo.empty(),
    this.sum = 0,
    this.currentProgress = 0,
    this.binary = const [],
    this.updateCanceled = false,
    this.formattedTimeElapsed = '',
    this.technicianID = '',
    this.updateMessage = '',
    this.errorMessage = '',
    this.fileErrorMessage = '',
  });

  final FormStatus binaryLoadStatus;
  final SubmissionStatus submissionStatus;
  final int currentFirmwareVersion;
  final BinaryInfo selectedBinaryInfo;
  final int sum;
  final double currentProgress;
  final List<int> binary;
  final bool updateCanceled;
  final String formattedTimeElapsed;
  final String technicianID;
  final String updateMessage;
  final String errorMessage;
  final String fileErrorMessage;

  Setting18FirmwareState copyWith({
    FormStatus? binaryLoadStatus,
    SubmissionStatus? submissionStatus,
    int? currentFirmwareVersion,
    BinaryInfo? selectedBinaryInfo,
    int? sum,
    double? currentProgress,
    List<int>? binary,
    bool? updateCanceled,
    String? formattedTimeElapsed,
    String? technicianID,
    String? updateMessage,
    String? errorMessage,
    String? fileErrorMessage,
  }) {
    return Setting18FirmwareState(
      binaryLoadStatus: binaryLoadStatus ?? this.binaryLoadStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      currentFirmwareVersion:
          currentFirmwareVersion ?? this.currentFirmwareVersion,
      selectedBinaryInfo: selectedBinaryInfo ?? this.selectedBinaryInfo,
      currentProgress: currentProgress ?? this.currentProgress,
      sum: sum ?? this.sum,
      binary: binary ?? this.binary,
      updateCanceled: updateCanceled ?? this.updateCanceled,
      formattedTimeElapsed: formattedTimeElapsed ?? this.formattedTimeElapsed,
      technicianID: technicianID ?? this.technicianID,
      updateMessage: updateMessage ?? this.updateMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      fileErrorMessage: fileErrorMessage ?? this.fileErrorMessage,
    );
  }

  @override
  List<Object> get props => [
        binaryLoadStatus,
        submissionStatus,
        currentFirmwareVersion,
        selectedBinaryInfo,
        sum,
        currentProgress,
        binary,
        updateCanceled,
        formattedTimeElapsed,
        technicianID,
        updateMessage,
        errorMessage,
        fileErrorMessage,
      ];
}

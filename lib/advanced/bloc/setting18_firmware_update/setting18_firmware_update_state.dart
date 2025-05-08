part of 'setting18_firmware_update_bloc.dart';

class Setting18FirmwareUpdateState extends Equatable {
  const Setting18FirmwareUpdateState({
    this.binaryLoadStatus = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.selectedBinaryInfo = const BinaryInfo.empty(),
    this.binaryCheckResult = const BinaryCheckResult.empty(),
    this.currentProgress = 0,
    this.updateCanceled = false,
    this.formattedTimeElapsed = '',
    this.technicianID = '',
    this.updateMessage = '',
    this.errorMessage = '',
    this.fileErrorMessage = '',
  });

  final FormStatus binaryLoadStatus;
  final SubmissionStatus submissionStatus;
  final BinaryInfo selectedBinaryInfo;
  final BinaryCheckResult binaryCheckResult;
  final double currentProgress;
  final bool updateCanceled;
  final String formattedTimeElapsed;
  final String technicianID;
  final String updateMessage;
  final String errorMessage;
  final String fileErrorMessage;

  Setting18FirmwareUpdateState copyWith({
    FormStatus? binaryLoadStatus,
    SubmissionStatus? submissionStatus,
    BinaryInfo? selectedBinaryInfo,
    BinaryCheckResult? binaryCheckResult,
    double? currentProgress,
    bool? updateCanceled,
    String? formattedTimeElapsed,
    String? technicianID,
    String? updateMessage,
    String? errorMessage,
    String? fileErrorMessage,
  }) {
    return Setting18FirmwareUpdateState(
      binaryLoadStatus: binaryLoadStatus ?? this.binaryLoadStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      selectedBinaryInfo: selectedBinaryInfo ?? this.selectedBinaryInfo,
      currentProgress: currentProgress ?? this.currentProgress,
      binaryCheckResult: binaryCheckResult ?? this.binaryCheckResult,
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
        selectedBinaryInfo,
        binaryCheckResult,
        currentProgress,
        updateCanceled,
        formattedTimeElapsed,
        technicianID,
        updateMessage,
        errorMessage,
        fileErrorMessage,
      ];
}

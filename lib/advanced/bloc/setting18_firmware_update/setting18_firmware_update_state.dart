part of 'setting18_firmware_update_bloc.dart';

class Setting18FirmwareUpdateState extends Equatable {
  const Setting18FirmwareUpdateState({
    this.binaryLoadStatus = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
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

  Setting18FirmwareUpdateState copyWith({
    FormStatus? binaryLoadStatus,
    SubmissionStatus? submissionStatus,
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
    return Setting18FirmwareUpdateState(
      binaryLoadStatus: binaryLoadStatus ?? this.binaryLoadStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
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

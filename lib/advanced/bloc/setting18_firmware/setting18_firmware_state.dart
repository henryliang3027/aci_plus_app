part of 'setting18_firmware_bloc.dart';

class Setting18FirmwareState extends Equatable {
  const Setting18FirmwareState({
    this.binaryLoadStatus = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.selectedBinaryInfo = const BinaryInfo.empty(),
    this.sum = 0,
    this.currentProgress = 0,
    this.binary = const [],
    this.updateCanceled = false,
    this.formattedTimeElapsed = '',
    this.updateMessage = '',
    this.errorMessage = '',
  });

  final FormStatus binaryLoadStatus;
  final SubmissionStatus submissionStatus;
  final BinaryInfo selectedBinaryInfo;
  final int sum;
  final double currentProgress;
  final List<int> binary;
  final bool updateCanceled;
  final String formattedTimeElapsed;
  final String updateMessage;
  final String errorMessage;

  Setting18FirmwareState copyWith({
    FormStatus? binaryLoadStatus,
    SubmissionStatus? submissionStatus,
    BinaryInfo? selectedBinaryInfo,
    int? sum,
    double? currentProgress,
    List<int>? binary,
    bool? updateCanceled,
    String? formattedTimeElapsed,
    String? updateMessage,
    String? errorMessage,
  }) {
    return Setting18FirmwareState(
      binaryLoadStatus: binaryLoadStatus ?? this.binaryLoadStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      selectedBinaryInfo: selectedBinaryInfo ?? this.selectedBinaryInfo,
      currentProgress: currentProgress ?? this.currentProgress,
      sum: sum ?? this.sum,
      binary: binary ?? this.binary,
      updateCanceled: updateCanceled ?? this.updateCanceled,
      formattedTimeElapsed: formattedTimeElapsed ?? this.formattedTimeElapsed,
      updateMessage: updateMessage ?? this.updateMessage,
      errorMessage: errorMessage ?? this.errorMessage,
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
        updateMessage,
        errorMessage,
      ];
}

part of 'setting18_firmware_bloc.dart';

class Setting18FirmwareState extends Equatable {
  const Setting18FirmwareState({
    this.formStatus = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.sum = 0,
    this.binary = const [],
    this.errorMessage = '',
  });

  final FormStatus formStatus;
  final SubmissionStatus submissionStatus;
  final int sum;
  final List<int> binary;
  final String errorMessage;

  Setting18FirmwareState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? submissionStatus,
    int? sum,
    List<int>? binary,
    String? errorMessage,
  }) {
    return Setting18FirmwareState(
      formStatus: formStatus ?? this.formStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      sum: sum ?? this.sum,
      binary: binary ?? this.binary,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        submissionStatus,
        sum,
        binary,
        errorMessage,
      ];
}

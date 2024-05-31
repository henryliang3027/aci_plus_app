part of 'setting18_firmware_bloc.dart';

class Setting18FirmwareState extends Equatable {
  const Setting18FirmwareState({
    this.formStatus = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.errorMessage = '',
  });

  final FormStatus formStatus;
  final SubmissionStatus submissionStatus;
  final String errorMessage;

  Setting18FirmwareState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return Setting18FirmwareState(
      formStatus: formStatus ?? this.formStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        submissionStatus,
        errorMessage,
      ];
}

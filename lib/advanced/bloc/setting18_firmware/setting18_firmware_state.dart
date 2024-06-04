part of 'setting18_firmware_bloc.dart';

class Setting18FirmwareState extends Equatable {
  const Setting18FirmwareState({
    this.formStatus = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.selectedBinary = '2',
    this.sum = 0,
    this.binary = const [],
    this.updateMessage = '',
    this.errorMessage = '',
  });

  final FormStatus formStatus;
  final SubmissionStatus submissionStatus;
  final String selectedBinary;
  final int sum;
  final List<int> binary;
  final String updateMessage;
  final String errorMessage;

  Setting18FirmwareState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? submissionStatus,
    String? selectedBinary,
    int? sum,
    List<int>? binary,
    String? updateMessage,
    String? errorMessage,
  }) {
    return Setting18FirmwareState(
      formStatus: formStatus ?? this.formStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      selectedBinary: selectedBinary ?? this.selectedBinary,
      sum: sum ?? this.sum,
      binary: binary ?? this.binary,
      updateMessage: updateMessage ?? this.updateMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        submissionStatus,
        selectedBinary,
        sum,
        binary,
        updateMessage,
        errorMessage,
      ];
}

part of 'setting18_bloc.dart';

class Setting18State extends Equatable {
  const Setting18State({
    this.submissionStatus = SubmissionStatus.none,
  });

  final SubmissionStatus submissionStatus;

  Setting18State copyWith({
    SubmissionStatus? submissionStatus,
  }) {
    return Setting18State(
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object?> get props => [
        submissionStatus,
      ];
}

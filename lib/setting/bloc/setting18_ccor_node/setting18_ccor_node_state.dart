part of 'setting18_ccor_node_bloc.dart';

class Setting18CCorNodeState extends Equatable {
  const Setting18CCorNodeState({
    this.submissionStatus = SubmissionStatus.none,
  });

  final SubmissionStatus submissionStatus;

  Setting18CCorNodeState copyWith({
    SubmissionStatus? submissionStatus,
  }) {
    return Setting18CCorNodeState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object> get props => [submissionStatus];
}

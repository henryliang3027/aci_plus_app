part of 'setting18_graph_view_bloc.dart';

class Setting18GraphViewState extends Equatable {
  const Setting18GraphViewState({
    this.submissionStatus = SubmissionStatus.none,
  });

  final SubmissionStatus submissionStatus;

  Setting18GraphViewState copyWith({
    SubmissionStatus? submissionStatus,
  }) {
    return Setting18GraphViewState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object> get props => [];
}

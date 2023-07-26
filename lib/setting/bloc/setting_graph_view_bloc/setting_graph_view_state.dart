part of 'setting_graph_view_bloc.dart';

class SettingGraphViewState extends Equatable {
  const SettingGraphViewState({
    this.submissionStatus = SubmissionStatus.none,
  });

  final SubmissionStatus submissionStatus;

  SettingGraphViewState copyWith({
    SubmissionStatus? submissionStatus,
  }) {
    return SettingGraphViewState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object?> get props => [
        submissionStatus,
      ];
}

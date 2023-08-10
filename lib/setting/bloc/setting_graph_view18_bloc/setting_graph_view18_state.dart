part of 'setting_graph_view18_bloc.dart';

class SettingGraphView18State extends Equatable {
  const SettingGraphView18State({
    this.submissionStatus = SubmissionStatus.none,
  });

  final SubmissionStatus submissionStatus;

  SettingGraphView18State copyWith({
    SubmissionStatus? submissionStatus,
  }) {
    return SettingGraphView18State(
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object> get props => [];
}

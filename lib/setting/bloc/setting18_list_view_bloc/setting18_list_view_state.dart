part of 'setting18_list_view_bloc.dart';

class Setting18ListViewState extends Equatable {
  const Setting18ListViewState({
    this.submissionStatus = SubmissionStatus.none,
    this.splitOption = '',
    this.firstChannelLoading = '',
    this.lastChannelLoading = '',
    this.pilotFrequency = '',
  });

  final SubmissionStatus submissionStatus;
  final String splitOption;
  final String firstChannelLoading;
  final String lastChannelLoading;
  final String pilotFrequency;

  Setting18ListViewState copyWith({
    SubmissionStatus? submissionStatus,
    String? splitOption,
    String? firstChannelLoading,
    String? lastChannelLoading,
    String? pilotFrequency,
  }) {
    return Setting18ListViewState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      splitOption: splitOption ?? this.splitOption,
      firstChannelLoading: firstChannelLoading ?? this.firstChannelLoading,
      lastChannelLoading: lastChannelLoading ?? this.lastChannelLoading,
      pilotFrequency: pilotFrequency ?? this.pilotFrequency,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        splitOption,
        firstChannelLoading,
        lastChannelLoading,
        pilotFrequency,
      ];
}

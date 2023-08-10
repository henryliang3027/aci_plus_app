part of 'setting_list_view18_bloc.dart';

class SettingListView18State extends Equatable {
  const SettingListView18State({
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

  SettingListView18State copyWith({
    SubmissionStatus? submissionStatus,
    String? splitOption,
    String? firstChannelLoading,
    String? lastChannelLoading,
    String? pilotFrequency,
  }) {
    return SettingListView18State(
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

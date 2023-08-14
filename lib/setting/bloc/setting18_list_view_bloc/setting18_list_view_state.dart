part of 'setting18_list_view_bloc.dart';

class Setting18ListViewState extends Equatable {
  const Setting18ListViewState({
    this.submissionStatus = SubmissionStatus.none,
    this.splitOption = '1',
    this.firstChannelLoading = '',
    this.lastChannelLoading = '',
    this.pilotFrequency = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
  });

  final SubmissionStatus submissionStatus;
  final String splitOption;
  final String firstChannelLoading;
  final String lastChannelLoading;
  final String pilotFrequency;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;

  Setting18ListViewState copyWith({
    SubmissionStatus? submissionStatus,
    String? splitOption,
    String? firstChannelLoading,
    String? lastChannelLoading,
    String? pilotFrequency,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
  }) {
    return Setting18ListViewState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      splitOption: splitOption ?? this.splitOption,
      firstChannelLoading: firstChannelLoading ?? this.firstChannelLoading,
      lastChannelLoading: lastChannelLoading ?? this.lastChannelLoading,
      pilotFrequency: pilotFrequency ?? this.pilotFrequency,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        splitOption,
        firstChannelLoading,
        lastChannelLoading,
        pilotFrequency,
        editMode,
        enableSubmission,
        isInitialize,
      ];
}

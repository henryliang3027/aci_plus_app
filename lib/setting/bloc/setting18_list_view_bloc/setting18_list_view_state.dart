part of 'setting18_list_view_bloc.dart';

class Setting18ListViewState extends Equatable {
  const Setting18ListViewState({
    this.submissionStatus = SubmissionStatus.none,
    this.splitOption = '1',
    this.firstChannelLoadingFrequency = '',
    this.firstChannelLoadingLevel = '',
    this.lastChannelLoadingFrequency = '',
    this.lastChannelLoadingLevel = '',
    this.pilotFrequencyMode = '',
    this.pilotFrequency1 = '',
    this.pilotFrequency2 = '',
    this.fwdAGCMode = '',
    this.autoLevelControl = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
  });

  final SubmissionStatus submissionStatus;
  final String splitOption;
  final String firstChannelLoadingFrequency;
  final String firstChannelLoadingLevel;
  final String lastChannelLoadingFrequency;
  final String lastChannelLoadingLevel;
  final String pilotFrequencyMode;
  final String pilotFrequency1;
  final String pilotFrequency2;
  final String fwdAGCMode;
  final String autoLevelControl;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;

  Setting18ListViewState copyWith({
    SubmissionStatus? submissionStatus,
    String? splitOption,
    String? firstChannelLoadingFrequency,
    String? firstChannelLoadingLevel,
    String? lastChannelLoadingFrequency,
    String? lastChannelLoadingLevel,
    String? pilotFrequencyMode,
    String? pilotFrequency1,
    String? pilotFrequency2,
    String? fwdAGCMode,
    String? autoLevelControl,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
  }) {
    return Setting18ListViewState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      splitOption: splitOption ?? this.splitOption,
      firstChannelLoadingFrequency:
          firstChannelLoadingFrequency ?? this.firstChannelLoadingFrequency,
      firstChannelLoadingLevel:
          firstChannelLoadingLevel ?? this.firstChannelLoadingLevel,
      lastChannelLoadingFrequency:
          lastChannelLoadingFrequency ?? this.lastChannelLoadingFrequency,
      lastChannelLoadingLevel:
          lastChannelLoadingLevel ?? this.lastChannelLoadingLevel,
      pilotFrequencyMode: pilotFrequencyMode ?? this.pilotFrequencyMode,
      pilotFrequency1: pilotFrequency1 ?? this.pilotFrequency1,
      pilotFrequency2: pilotFrequency2 ?? this.pilotFrequency2,
      fwdAGCMode: fwdAGCMode ?? this.fwdAGCMode,
      autoLevelControl: autoLevelControl ?? this.autoLevelControl,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        splitOption,
        firstChannelLoadingFrequency,
        firstChannelLoadingLevel,
        lastChannelLoadingFrequency,
        lastChannelLoadingLevel,
        pilotFrequencyMode,
        pilotFrequency1,
        pilotFrequency2,
        fwdAGCMode,
        autoLevelControl,
        editMode,
        enableSubmission,
        isInitialize,
      ];
}

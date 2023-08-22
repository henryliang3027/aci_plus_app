part of 'setting18_configure_bloc.dart';

class Setting18ConfigureState extends Equatable {
  const Setting18ConfigureState({
    this.submissionStatus = SubmissionStatus.none,
    this.location = '',
    this.coordinates = '',
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
    this.initialValues = const [],
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final String location;
  final String coordinates;
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
  final List<dynamic> initialValues;
  final List<String> settingResult;

  Setting18ConfigureState copyWith({
    SubmissionStatus? submissionStatus,
    String? location,
    String? coordinates,
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
    List<dynamic>? initialValues,
    List<String>? settingResult,
  }) {
    return Setting18ConfigureState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      location: location ?? this.location,
      coordinates: coordinates ?? this.coordinates,
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
      initialValues: initialValues ?? this.initialValues,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        location,
        coordinates,
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
        initialValues,
        settingResult,
      ];
}

part of 'setting18_configure_bloc.dart';

class Setting18ConfigureState extends Equatable {
  const Setting18ConfigureState({
    this.submissionStatus = SubmissionStatus.none,
    this.gpsStatus = FormStatus.none,
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
    this.manualModePilot1RFOutputPower = '',
    this.manualModePilot2RFOutputPower = '',
    this.fwdAGCMode = '',
    this.autoLevelControl = '',
    this.logInterval = '30',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const [],
    this.settingResult = const [],
    this.gpsCoordinateErrorMessage = '',
  });

  final SubmissionStatus submissionStatus;
  final FormStatus gpsStatus;
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
  final String manualModePilot1RFOutputPower;
  final String manualModePilot2RFOutputPower;
  final String fwdAGCMode;
  final String autoLevelControl;
  final String logInterval;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final List<dynamic> initialValues;
  final List<String> settingResult;
  final String gpsCoordinateErrorMessage;

  Setting18ConfigureState copyWith({
    SubmissionStatus? submissionStatus,
    FormStatus? gpsStatus,
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
    String? manualModePilot1RFOutputPower,
    String? manualModePilot2RFOutputPower,
    String? fwdAGCMode,
    String? autoLevelControl,
    String? logInterval,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    List<dynamic>? initialValues,
    List<String>? settingResult,
    String? gpsCoordinateErrorMessage,
  }) {
    return Setting18ConfigureState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      gpsStatus: gpsStatus ?? this.gpsStatus,
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
      manualModePilot1RFOutputPower:
          manualModePilot1RFOutputPower ?? this.manualModePilot1RFOutputPower,
      manualModePilot2RFOutputPower:
          manualModePilot2RFOutputPower ?? this.manualModePilot2RFOutputPower,
      fwdAGCMode: fwdAGCMode ?? this.fwdAGCMode,
      autoLevelControl: autoLevelControl ?? this.autoLevelControl,
      logInterval: logInterval ?? this.logInterval,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
      initialValues: initialValues ?? this.initialValues,
      settingResult: settingResult ?? this.settingResult,
      gpsCoordinateErrorMessage:
          gpsCoordinateErrorMessage ?? this.gpsCoordinateErrorMessage,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        gpsStatus,
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
        manualModePilot1RFOutputPower,
        manualModePilot2RFOutputPower,
        fwdAGCMode,
        autoLevelControl,
        logInterval,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
        gpsCoordinateErrorMessage
      ];
}

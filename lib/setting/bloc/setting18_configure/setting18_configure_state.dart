part of 'setting18_configure_bloc.dart';

class Setting18ConfigureState extends Equatable {
  const Setting18ConfigureState({
    this.submissionStatus = SubmissionStatus.none,
    this.gpsStatus = FormStatus.none,
    this.location = '',
    this.coordinates = '',
    this.splitOption = '1',
    this.firstChannelLoadingFrequency = const IntegerInput.pure(),
    this.firstChannelLoadingLevel = const FloatPointInput.pure(),
    this.lastChannelLoadingFrequency = const IntegerInput.pure(),
    this.lastChannelLoadingLevel = const FloatPointInput.pure(),
    this.pilotFrequencyMode = '',
    this.pilotFrequency1 = const IntegerInput.pure(),
    this.pilotFrequency2 = const IntegerInput.pure(),
    this.manualModePilot1RFOutputPower = '',
    this.manualModePilot2RFOutputPower = '',
    this.agcMode = '',
    this.alcMode = '',
    this.logInterval = '',
    this.rfOutputLogInterval = '',
    this.tgcCableLength = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const {},
    this.tappedSet = const {},
    this.settingResult = const [],
    this.gpsCoordinateErrorMessage = '',
  });

  final SubmissionStatus submissionStatus;
  final FormStatus gpsStatus;
  final String location;
  final String coordinates;
  final String splitOption;
  final IntegerInput firstChannelLoadingFrequency;
  final FloatPointInput firstChannelLoadingLevel;
  final IntegerInput lastChannelLoadingFrequency;
  final FloatPointInput lastChannelLoadingLevel;
  final String pilotFrequencyMode;
  final IntegerInput pilotFrequency1;
  final IntegerInput pilotFrequency2;
  final String manualModePilot1RFOutputPower;
  final String manualModePilot2RFOutputPower;
  final String agcMode;
  final String alcMode;
  final String logInterval;
  final String rfOutputLogInterval;
  final String tgcCableLength;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
  final Set<DataKey> tappedSet;
  final List<String> settingResult;
  final String gpsCoordinateErrorMessage;

  Setting18ConfigureState copyWith({
    SubmissionStatus? submissionStatus,
    FormStatus? gpsStatus,
    String? location,
    String? coordinates,
    String? splitOption,
    IntegerInput? firstChannelLoadingFrequency,
    FloatPointInput? firstChannelLoadingLevel,
    IntegerInput? lastChannelLoadingFrequency,
    FloatPointInput? lastChannelLoadingLevel,
    String? pilotFrequencyMode,
    IntegerInput? pilotFrequency1,
    IntegerInput? pilotFrequency2,
    String? manualModePilot1RFOutputPower,
    String? manualModePilot2RFOutputPower,
    String? agcMode,
    String? alcMode,
    String? logInterval,
    String? rfOutputLogInterval,
    String? tgcCableLength,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    Map<DataKey, String>? initialValues,
    Set<DataKey>? tappedSet,
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
      agcMode: agcMode ?? this.agcMode,
      alcMode: alcMode ?? this.alcMode,
      logInterval: logInterval ?? this.logInterval,
      rfOutputLogInterval: rfOutputLogInterval ?? this.rfOutputLogInterval,
      tgcCableLength: tgcCableLength ?? this.tgcCableLength,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
      initialValues: initialValues ?? this.initialValues,
      tappedSet: tappedSet ?? this.tappedSet,
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
        agcMode,
        alcMode,
        logInterval,
        rfOutputLogInterval,
        tgcCableLength,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
        gpsCoordinateErrorMessage
      ];
}

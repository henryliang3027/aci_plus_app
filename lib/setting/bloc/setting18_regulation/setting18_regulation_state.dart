part of 'setting18_regulation_bloc.dart';

class Setting18RegulationState extends Equatable {
  const Setting18RegulationState({
    this.submissionStatus = SubmissionStatus.none,
    this.splitOption = '1',
    this.firstChannelLoadingFrequency = const RangeIntegerInput.pure(),
    this.firstChannelLoadingLevel = const RangeFloatPointInput.pure(),
    this.lastChannelLoadingFrequency = const RangeIntegerInput.pure(),
    this.lastChannelLoadingLevel = const RangeFloatPointInput.pure(),
    this.minFirstChannelLoadingFrequency = 0,
    this.maxLastChannelLoadingFrequency = 0,
    this.pilotFrequencyMode = '',
    this.eqType = EQType.none,
    this.pilotFrequency1 = const RangeIntegerInput.pure(),
    this.pilotFrequency2 = const RangeIntegerInput.pure(),
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
    this.isInitialPilotFrequencyLevelValues = false,
    this.initialValues = const {},
    this.tappedSet = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final String splitOption;
  final RangeIntegerInput firstChannelLoadingFrequency;
  final RangeFloatPointInput firstChannelLoadingLevel;
  final RangeIntegerInput lastChannelLoadingFrequency;
  final RangeFloatPointInput lastChannelLoadingLevel;
  final int minFirstChannelLoadingFrequency;
  final int maxLastChannelLoadingFrequency;
  final String pilotFrequencyMode;
  final EQType eqType;
  final RangeIntegerInput pilotFrequency1;
  final RangeIntegerInput pilotFrequency2;
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
  final bool isInitialPilotFrequencyLevelValues;
  final Map<DataKey, String> initialValues;
  final Set<DataKey> tappedSet;
  final List<String> settingResult;

  Setting18RegulationState copyWith({
    SubmissionStatus? submissionStatus,
    String? splitOption,
    RangeIntegerInput? firstChannelLoadingFrequency,
    RangeFloatPointInput? firstChannelLoadingLevel,
    RangeIntegerInput? lastChannelLoadingFrequency,
    RangeFloatPointInput? lastChannelLoadingLevel,
    int? minFirstChannelLoadingFrequency,
    int? maxLastChannelLoadingFrequency,
    String? pilotFrequencyMode,
    EQType? eqType,
    RangeIntegerInput? pilotFrequency1,
    RangeIntegerInput? pilotFrequency2,
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
    bool? isInitialPilotFrequencyLevelValues,
    Map<DataKey, String>? initialValues,
    Set<DataKey>? tappedSet,
    List<String>? settingResult,
    bool? isForwardCEQChanged,
  }) {
    return Setting18RegulationState(
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
      minFirstChannelLoadingFrequency: minFirstChannelLoadingFrequency ??
          this.minFirstChannelLoadingFrequency,
      maxLastChannelLoadingFrequency:
          maxLastChannelLoadingFrequency ?? this.maxLastChannelLoadingFrequency,
      pilotFrequencyMode: pilotFrequencyMode ?? this.pilotFrequencyMode,
      eqType: eqType ?? this.eqType,
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
      initialValues: initialValues != null
          ? Map<DataKey, String>.from(initialValues)
          : this.initialValues,
      isInitialPilotFrequencyLevelValues: isInitialPilotFrequencyLevelValues ??
          this.isInitialPilotFrequencyLevelValues,
      tappedSet: tappedSet ?? this.tappedSet,
      settingResult: settingResult ?? this.settingResult,
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
        minFirstChannelLoadingFrequency,
        maxLastChannelLoadingFrequency,
        pilotFrequencyMode,
        eqType,
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
        isInitialPilotFrequencyLevelValues,
        initialValues,
        settingResult,
      ];
}

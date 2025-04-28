part of 'setting18_graph_module_bloc.dart';

class Setting18GraphModuleState extends Equatable {
  const Setting18GraphModuleState({
    this.submissionStatus = SubmissionStatus.none,
    this.forwardCEQStatus = FormStatus.none,
    this.targetValues = const {},
    this.targetIngressValues = const {},
    this.firstChannelLoadingFrequency = const RangeIntegerInput.pure(),
    this.firstChannelLoadingLevel = const RangeFloatPointInput.pure(),
    this.lastChannelLoadingFrequency = const RangeIntegerInput.pure(),
    this.lastChannelLoadingLevel = const RangeFloatPointInput.pure(),
    this.pilotFrequencyMode = '',
    this.pilotFrequency1 = const RangeIntegerInput.pure(),
    this.pilotFrequency2 = const RangeIntegerInput.pure(),
    this.manualModePilot1RFOutputPower = '',
    this.manualModePilot2RFOutputPower = '',
    this.agcMode = '',
    this.alcMode = '',
    this.editMode = true,
    this.enableSubmission = false,
    this.isInitialize = false,
    this.isInitialPilotFrequencyLevelValues = false,
    this.initialValues = const {},
    this.tappedSet = const {},
    this.settingResult = const [],
    this.isForwardCEQIndexChanged = false,
  });

  final SubmissionStatus submissionStatus;
  final FormStatus forwardCEQStatus;
  final Map<DataKey, RangeFloatPointInput> targetValues;
  final Map<DataKey, String> targetIngressValues;
  final RangeIntegerInput firstChannelLoadingFrequency;
  final RangeFloatPointInput firstChannelLoadingLevel;
  final RangeIntegerInput lastChannelLoadingFrequency;
  final RangeFloatPointInput lastChannelLoadingLevel;
  final String pilotFrequencyMode;
  final RangeIntegerInput pilotFrequency1;
  final RangeIntegerInput pilotFrequency2;
  final String manualModePilot1RFOutputPower;
  final String manualModePilot2RFOutputPower;
  final String agcMode;
  final String alcMode;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final bool isInitialPilotFrequencyLevelValues;
  final Map<DataKey, String> initialValues;

  final Set<DataKey> tappedSet;
  final List<String> settingResult;
  final bool isForwardCEQIndexChanged;

  Setting18GraphModuleState copyWith({
    SubmissionStatus? submissionStatus,
    FormStatus? forwardCEQStatus,
    Map<DataKey, RangeFloatPointInput>? targetValues,
    Map<DataKey, String>? targetIngressValues,
    RangeIntegerInput? firstChannelLoadingFrequency,
    RangeFloatPointInput? firstChannelLoadingLevel,
    RangeIntegerInput? lastChannelLoadingFrequency,
    RangeFloatPointInput? lastChannelLoadingLevel,
    String? pilotFrequencyMode,
    RangeIntegerInput? pilotFrequency1,
    RangeIntegerInput? pilotFrequency2,
    String? manualModePilot1RFOutputPower,
    String? manualModePilot2RFOutputPower,
    String? agcMode,
    String? alcMode,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    bool? isInitialPilotFrequencyLevelValues,
    Map<DataKey, String>? initialValues,
    Set<DataKey>? tappedSet,
    List<String>? settingResult,
    bool? isForwardCEQIndexChanged,
  }) {
    return Setting18GraphModuleState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      forwardCEQStatus: forwardCEQStatus ?? this.forwardCEQStatus,
      targetValues: targetValues ?? this.targetValues,
      targetIngressValues: targetIngressValues ?? this.targetIngressValues,
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
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
      isInitialPilotFrequencyLevelValues: isInitialPilotFrequencyLevelValues ??
          this.isInitialPilotFrequencyLevelValues,
      initialValues: initialValues ?? this.initialValues,
      tappedSet: tappedSet ?? this.tappedSet,
      settingResult: settingResult ?? this.settingResult,
      isForwardCEQIndexChanged:
          isForwardCEQIndexChanged ?? this.isForwardCEQIndexChanged,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        forwardCEQStatus,
        targetValues,
        targetIngressValues,
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
        editMode,
        enableSubmission,
        isInitialize,
        isInitialPilotFrequencyLevelValues,
        initialValues,
        tappedSet,
        settingResult,
        isForwardCEQIndexChanged,
      ];
}

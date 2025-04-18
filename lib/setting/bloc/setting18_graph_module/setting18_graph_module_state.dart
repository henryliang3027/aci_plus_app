part of 'setting18_graph_module_bloc.dart';

class Setting18GraphModuleState extends Equatable {
  const Setting18GraphModuleState({
    this.submissionStatus = SubmissionStatus.none,
    this.forwardCEQStatus = FormStatus.none,
    this.targetValues = const {},
    this.targetIngressValues = const {},
    // this.dsVVA1 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 30,
    // ),
    // this.dsVVA4 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 10,
    // ),
    // this.dsVVA5 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 10,
    // ),
    // this.dsSlope1 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 24,
    // ),
    // this.dsSlope3 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 10,
    // ),
    // this.dsSlope4 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 10,
    // ),
    // this.usVCA1 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 25,
    // ),
    // this.usVCA2 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 15,
    // ),
    // this.usVCA3 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 25,
    // ),
    // this.usVCA4 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 25,
    // ),
    // this.eREQ = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 15,
    // ),
    // this.returnIngressSetting2 = '',
    // this.returnIngressSetting3 = '',
    // this.returnIngressSetting4 = '',
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
  // final RangeFloatPointInput dsVVA1;
  // final RangeFloatPointInput dsVVA4;
  // final RangeFloatPointInput dsVVA5;
  // final RangeFloatPointInput dsSlope1;
  // final RangeFloatPointInput dsSlope3;
  // final RangeFloatPointInput dsSlope4;
  // final RangeFloatPointInput usVCA1;
  // final RangeFloatPointInput usVCA2;
  // final RangeFloatPointInput usVCA3;
  // final RangeFloatPointInput usVCA4;
  // final RangeFloatPointInput eREQ;
  // final String returnIngressSetting2;
  // final String returnIngressSetting3;
  // final String returnIngressSetting4;
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
    // RangeFloatPointInput? dsVVA1,
    // RangeFloatPointInput? dsVVA4,
    // RangeFloatPointInput? dsVVA5,
    // RangeFloatPointInput? dsSlope1,
    // RangeFloatPointInput? dsSlope3,
    // RangeFloatPointInput? dsSlope4,
    // RangeFloatPointInput? usVCA1,
    // RangeFloatPointInput? usVCA2,
    // RangeFloatPointInput? usVCA3,
    // RangeFloatPointInput? usVCA4,
    // RangeFloatPointInput? eREQ,
    // String? returnIngressSetting2,
    // String? returnIngressSetting3,
    // String? returnIngressSetting4,
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
      // dsVVA1: dsVVA1 ?? this.dsVVA1,
      // dsVVA4: dsVVA4 ?? this.dsVVA4,
      // dsVVA5: dsVVA5 ?? this.dsVVA5,
      // dsSlope1: dsSlope1 ?? this.dsSlope1,
      // dsSlope3: dsSlope3 ?? this.dsSlope3,
      // dsSlope4: dsSlope4 ?? this.dsSlope4,
      // usVCA1: usVCA1 ?? this.usVCA1,
      // usVCA2: usVCA2 ?? this.usVCA2,
      // usVCA3: usVCA3 ?? this.usVCA3,
      // usVCA4: usVCA4 ?? this.usVCA4,
      // eREQ: eREQ ?? this.eREQ,
      // returnIngressSetting2:
      //     returnIngressSetting2 ?? this.returnIngressSetting2,
      // returnIngressSetting3:
      //     returnIngressSetting3 ?? this.returnIngressSetting3,
      // returnIngressSetting4:
      //     returnIngressSetting4 ?? this.returnIngressSetting4,
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
        // dsVVA1,
        // dsVVA4,
        // dsVVA5,
        // dsSlope1,
        // dsSlope3,
        // dsSlope4,
        // usVCA1,
        // usVCA2,
        // usVCA3,
        // usVCA4,
        // eREQ,
        // returnIngressSetting2,
        // returnIngressSetting3,
        // returnIngressSetting4,
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

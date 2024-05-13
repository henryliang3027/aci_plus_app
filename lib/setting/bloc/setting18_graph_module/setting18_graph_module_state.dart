part of 'setting18_graph_module_bloc.dart';

class Setting18GraphModuleState extends Equatable {
  const Setting18GraphModuleState({
    this.submissionStatus = SubmissionStatus.none,
    this.dsVVA1 = '',
    this.dsVVA4 = '',
    this.dsVVA5 = '',
    this.dsSlope1 = '',
    this.dsSlope3 = '',
    this.dsSlope4 = '',
    this.usVCA1 = '',
    this.usVCA2 = '',
    this.usVCA3 = '',
    this.usVCA4 = '',
    this.eREQ = '',
    this.returnIngressSetting2 = '',
    this.returnIngressSetting3 = '',
    this.returnIngressSetting4 = '',
    this.tgcCableLength = '',
    // this.usTGC = '',
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
    this.editMode = true,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final String dsVVA1;
  final String dsVVA4;
  final String dsVVA5;
  final String dsSlope1;
  final String dsSlope3;
  final String dsSlope4;
  final String usVCA1;
  final String usVCA2;
  final String usVCA3;
  final String usVCA4;
  final String eREQ;
  final String returnIngressSetting2;
  final String returnIngressSetting3;
  final String returnIngressSetting4;
  final String tgcCableLength;

  // final String usTGC;
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
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;

  Setting18GraphModuleState copyWith({
    SubmissionStatus? submissionStatus,
    String? dsVVA1,
    String? dsVVA4,
    String? dsVVA5,
    String? dsSlope1,
    String? dsSlope3,
    String? dsSlope4,
    String? usVCA1,
    String? usVCA2,
    String? usVCA3,
    String? usVCA4,
    String? eREQ,
    String? returnIngressSetting2,
    String? returnIngressSetting3,
    String? returnIngressSetting4,
    String? tgcCableLength,
    // String? usTGC,
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
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    Map<DataKey, String>? initialValues,
    List<String>? settingResult,
  }) {
    return Setting18GraphModuleState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      dsVVA1: dsVVA1 ?? this.dsVVA1,
      dsVVA4: dsVVA4 ?? this.dsVVA4,
      dsVVA5: dsVVA5 ?? this.dsVVA5,
      dsSlope1: dsSlope1 ?? this.dsSlope1,
      dsSlope3: dsSlope3 ?? this.dsSlope3,
      dsSlope4: dsSlope4 ?? this.dsSlope4,
      usVCA1: usVCA1 ?? this.usVCA1,
      usVCA2: usVCA2 ?? this.usVCA2,
      usVCA3: usVCA3 ?? this.usVCA3,
      usVCA4: usVCA4 ?? this.usVCA4,
      eREQ: eREQ ?? this.eREQ,
      returnIngressSetting2:
          returnIngressSetting2 ?? this.returnIngressSetting2,
      returnIngressSetting3:
          returnIngressSetting3 ?? this.returnIngressSetting3,
      returnIngressSetting4:
          returnIngressSetting4 ?? this.returnIngressSetting4,
      tgcCableLength: tgcCableLength ?? this.tgcCableLength,
      // usTGC: usTGC ?? this.usTGC,
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
        dsVVA1,
        dsVVA4,
        dsVVA5,
        dsSlope1,
        dsSlope3,
        dsSlope4,
        usVCA1,
        usVCA2,
        usVCA3,
        usVCA4,
        eREQ,
        returnIngressSetting2,
        returnIngressSetting3,
        returnIngressSetting4,
        tgcCableLength,
        // usTGC,
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
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
      ];
}

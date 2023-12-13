part of 'setting18_graph_module_bloc.dart';

class Setting18GraphModuleState extends Equatable {
  const Setting18GraphModuleState({
    this.submissionStatus = SubmissionStatus.none,
    this.dsVVA1 = '',
    this.dsSlope1 = '',
    this.rtnInputAttenuation2 = '',
    this.rtnInputAttenuation3 = '',
    this.rtnInputAttenuation4 = '',
    this.rtnOutputLevelAttenuation = '',
    this.rtnOutputEQ = '',
    this.rtnIngressSetting2 = '',
    this.rtnIngressSetting3 = '',
    this.rtnIngressSetting4 = '',
    this.tgcCableLength = '',
    this.dsVVA2 = '',
    this.dsSlope2 = '',
    this.dsVVA3 = '',
    this.dsVVA4 = '',
    // this.usTGC = '',
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
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final String dsVVA1;
  final String dsSlope1;
  final String rtnInputAttenuation2;
  final String rtnInputAttenuation3;
  final String rtnInputAttenuation4;
  final String rtnOutputLevelAttenuation;
  final String rtnOutputEQ;
  final String rtnIngressSetting2;
  final String rtnIngressSetting3;
  final String rtnIngressSetting4;
  final String tgcCableLength;
  final String dsVVA2;
  final String dsSlope2;
  final String dsVVA3;
  final String dsVVA4;
  // final String usTGC;
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
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;

  Setting18GraphModuleState copyWith({
    SubmissionStatus? submissionStatus,
    String? dsVVA1,
    String? dsSlope1,
    String? rtnInputAttenuation2,
    String? rtnInputAttenuation3,
    String? rtnInputAttenuation4,
    String? rtnOutputLevelAttenuation,
    String? rtnOutputEQ,
    String? rtnIngressSetting2,
    String? rtnIngressSetting3,
    String? rtnIngressSetting4,
    String? tgcCableLength,
    String? dsVVA2,
    String? dsSlope2,
    String? dsVVA3,
    String? dsVVA4,
    // String? usTGC,
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
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    Map<DataKey, String>? initialValues,
    List<String>? settingResult,
  }) {
    return Setting18GraphModuleState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      dsVVA1: dsVVA1 ?? this.dsVVA1,
      dsSlope1: dsSlope1 ?? this.dsSlope1,
      rtnInputAttenuation2: rtnInputAttenuation2 ?? this.rtnInputAttenuation2,
      rtnInputAttenuation3: rtnInputAttenuation3 ?? this.rtnInputAttenuation3,
      rtnInputAttenuation4: rtnInputAttenuation4 ?? this.rtnInputAttenuation4,
      rtnOutputLevelAttenuation:
          rtnOutputLevelAttenuation ?? this.rtnOutputLevelAttenuation,
      rtnOutputEQ: rtnOutputEQ ?? this.rtnOutputEQ,
      rtnIngressSetting2: rtnIngressSetting2 ?? this.rtnIngressSetting2,
      rtnIngressSetting3: rtnIngressSetting3 ?? this.rtnIngressSetting3,
      rtnIngressSetting4: rtnIngressSetting4 ?? this.rtnIngressSetting4,
      tgcCableLength: tgcCableLength ?? this.tgcCableLength,
      dsVVA2: dsVVA2 ?? this.dsVVA2,
      dsSlope2: dsSlope2 ?? this.dsSlope2,
      dsVVA3: dsVVA3 ?? this.dsVVA3,
      dsVVA4: dsVVA4 ?? this.dsVVA4,
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
        dsSlope1,
        rtnInputAttenuation2,
        rtnInputAttenuation3,
        rtnInputAttenuation4,
        rtnOutputLevelAttenuation,
        rtnOutputEQ,
        rtnIngressSetting2,
        rtnIngressSetting3,
        rtnIngressSetting4,
        tgcCableLength,
        dsVVA2,
        dsSlope2,
        dsVVA3,
        dsVVA4,
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
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
      ];
}

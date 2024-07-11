part of 'setting18_ccor_node_graph_module_bloc.dart';

class Setting18CCorNodeGraphModuleState extends Equatable {
  const Setting18CCorNodeGraphModuleState({
    this.submissionStatus = SubmissionStatus.none,
    this.forwardConfig = '',
    this.splitOption = '',
    this.dsVVA1 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 25,
    ),
    this.dsVVA3 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 25,
    ),
    this.dsVVA4 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 25,
    ),
    this.dsVVA6 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 25,
    ),
    // this.dsInSlope1 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 8,
    // ),
    // this.dsInSlope3 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 8,
    // ),
    // this.dsInSlope4 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 8,
    // ),
    // this.dsInSlope6 = const RangeFloatPointInput.pure(
    //   minValue: 0,
    //   maxValue: 8,
    // ),
    this.dsOutSlope1 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 8,
    ),
    this.dsOutSlope3 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 8,
    ),
    this.dsOutSlope4 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 8,
    ),
    this.dsOutSlope6 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 8,
    ),
    this.biasCurrent1 = const RangeIntegerInput.pure(
      minValue: 320,
      maxValue: 520,
    ),
    this.biasCurrent3 = const RangeIntegerInput.pure(
      minValue: 320,
      maxValue: 520,
    ),
    this.biasCurrent4 = const RangeIntegerInput.pure(
      minValue: 320,
      maxValue: 520,
    ),
    this.biasCurrent6 = const RangeIntegerInput.pure(
      minValue: 320,
      maxValue: 520,
    ),
    this.usVCA1 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 25,
    ),
    this.usVCA3 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 25,
    ),
    this.usVCA4 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 25,
    ),
    this.usVCA6 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 25,
    ),
    this.returnIngressSetting1 = '',
    this.returnIngressSetting3 = '',
    this.returnIngressSetting4 = '',
    this.returnIngressSetting6 = '',
    this.editMode = true,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final String forwardConfig;
  final String splitOption;
  final RangeFloatPointInput dsVVA1;
  final RangeFloatPointInput dsVVA3;
  final RangeFloatPointInput dsVVA4;
  final RangeFloatPointInput dsVVA6;
  // final RangeFloatPointInput dsInSlope1;
  // final RangeFloatPointInput dsInSlope3;
  // final RangeFloatPointInput dsInSlope4;
  // final RangeFloatPointInput dsInSlope6;
  final RangeFloatPointInput dsOutSlope1;
  final RangeFloatPointInput dsOutSlope3;
  final RangeFloatPointInput dsOutSlope4;
  final RangeFloatPointInput dsOutSlope6;
  final RangeIntegerInput biasCurrent1;
  final RangeIntegerInput biasCurrent3;
  final RangeIntegerInput biasCurrent4;
  final RangeIntegerInput biasCurrent6;
  final RangeFloatPointInput usVCA1;
  final RangeFloatPointInput usVCA3;
  final RangeFloatPointInput usVCA4;
  final RangeFloatPointInput usVCA6;
  final String returnIngressSetting1;
  final String returnIngressSetting3;
  final String returnIngressSetting4;
  final String returnIngressSetting6;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;

  Setting18CCorNodeGraphModuleState copyWith({
    SubmissionStatus? submissionStatus,
    String? forwardConfig,
    String? splitOption,
    RangeFloatPointInput? dsVVA1,
    RangeFloatPointInput? dsVVA3,
    RangeFloatPointInput? dsVVA4,
    RangeFloatPointInput? dsVVA6,
    // RangeFloatPointInput? dsInSlope1,
    // RangeFloatPointInput? dsInSlope3,
    // RangeFloatPointInput? dsInSlope4,
    // RangeFloatPointInput? dsInSlope6,
    RangeFloatPointInput? dsOutSlope1,
    RangeFloatPointInput? dsOutSlope3,
    RangeFloatPointInput? dsOutSlope4,
    RangeFloatPointInput? dsOutSlope6,
    RangeIntegerInput? biasCurrent1,
    RangeIntegerInput? biasCurrent3,
    RangeIntegerInput? biasCurrent4,
    RangeIntegerInput? biasCurrent6,
    RangeFloatPointInput? usVCA1,
    RangeFloatPointInput? usVCA3,
    RangeFloatPointInput? usVCA4,
    RangeFloatPointInput? usVCA6,
    String? returnIngressSetting1,
    String? returnIngressSetting3,
    String? returnIngressSetting4,
    String? returnIngressSetting6,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    Map<DataKey, String>? initialValues,
    List<String>? settingResult,
  }) {
    return Setting18CCorNodeGraphModuleState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      forwardConfig: forwardConfig ?? this.forwardConfig,
      splitOption: splitOption ?? this.splitOption,
      dsVVA1: dsVVA1 ?? this.dsVVA1,
      dsVVA3: dsVVA3 ?? this.dsVVA3,
      dsVVA4: dsVVA4 ?? this.dsVVA4,
      dsVVA6: dsVVA6 ?? this.dsVVA6,
      // dsInSlope1: dsInSlope1 ?? this.dsInSlope1,
      // dsInSlope3: dsInSlope3 ?? this.dsInSlope3,
      // dsInSlope4: dsInSlope4 ?? this.dsInSlope4,
      // dsInSlope6: dsInSlope6 ?? this.dsInSlope6,
      dsOutSlope1: dsOutSlope1 ?? this.dsOutSlope1,
      dsOutSlope3: dsOutSlope3 ?? this.dsOutSlope3,
      dsOutSlope4: dsOutSlope4 ?? this.dsOutSlope4,
      dsOutSlope6: dsOutSlope6 ?? this.dsOutSlope6,
      biasCurrent1: biasCurrent1 ?? this.biasCurrent1,
      biasCurrent3: biasCurrent3 ?? this.biasCurrent3,
      biasCurrent4: biasCurrent4 ?? this.biasCurrent4,
      biasCurrent6: biasCurrent6 ?? this.biasCurrent6,
      usVCA1: usVCA1 ?? this.usVCA1,
      usVCA3: usVCA3 ?? this.usVCA3,
      usVCA4: usVCA4 ?? this.usVCA4,
      usVCA6: usVCA6 ?? this.usVCA6,
      returnIngressSetting1:
          returnIngressSetting1 ?? this.returnIngressSetting1,
      returnIngressSetting3:
          returnIngressSetting3 ?? this.returnIngressSetting3,
      returnIngressSetting4:
          returnIngressSetting4 ?? this.returnIngressSetting4,
      returnIngressSetting6:
          returnIngressSetting6 ?? this.returnIngressSetting6,
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
        forwardConfig,
        splitOption,
        dsVVA1,
        dsVVA3,
        dsVVA4,
        dsVVA6,
        // dsInSlope1,
        // dsInSlope3,
        // dsInSlope4,
        // dsInSlope6,
        dsOutSlope1,
        dsOutSlope3,
        dsOutSlope4,
        dsOutSlope6,
        biasCurrent1,
        biasCurrent3,
        biasCurrent4,
        biasCurrent6,
        usVCA1,
        usVCA3,
        usVCA4,
        usVCA6,
        returnIngressSetting1,
        returnIngressSetting3,
        returnIngressSetting4,
        returnIngressSetting6,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
      ];
}

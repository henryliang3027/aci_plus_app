part of 'setting18_ccor_node_graph_module_bloc.dart';

class Setting18CCorNodeGraphModuleState extends Equatable {
  const Setting18CCorNodeGraphModuleState({
    this.submissionStatus = SubmissionStatus.none,
    this.forwardConfig = '',
    this.splitOption = '',
    this.dsVVA1 = '',
    this.dsVVA3 = '',
    this.dsVVA4 = '',
    this.dsVVA6 = '',
    this.dsInSlope1 = '',
    this.dsInSlope3 = '',
    this.dsInSlope4 = '',
    this.dsInSlope6 = '',
    this.dsOutSlope1 = '',
    this.dsOutSlope3 = '',
    this.dsOutSlope4 = '',
    this.dsOutSlope6 = '',
    this.biasCurrent1 = '',
    this.biasCurrent3 = '',
    this.biasCurrent4 = '',
    this.biasCurrent6 = '',
    this.usVCA1 = '',
    this.usVCA3 = '',
    this.usVCA4 = '',
    this.usVCA6 = '',
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
  final String dsVVA1;
  final String dsVVA3;
  final String dsVVA4;
  final String dsVVA6;
  final String dsInSlope1;
  final String dsInSlope3;
  final String dsInSlope4;
  final String dsInSlope6;
  final String dsOutSlope1;
  final String dsOutSlope3;
  final String dsOutSlope4;
  final String dsOutSlope6;
  final String biasCurrent1;
  final String biasCurrent3;
  final String biasCurrent4;
  final String biasCurrent6;
  final String usVCA1;
  final String usVCA3;
  final String usVCA4;
  final String usVCA6;
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
    String? dsVVA1,
    String? dsVVA3,
    String? dsVVA4,
    String? dsVVA6,
    String? dsInSlope1,
    String? dsInSlope3,
    String? dsInSlope4,
    String? dsInSlope6,
    String? dsOutSlope1,
    String? dsOutSlope3,
    String? dsOutSlope4,
    String? dsOutSlope6,
    String? biasCurrent1,
    String? biasCurrent3,
    String? biasCurrent4,
    String? biasCurrent6,
    String? usVCA1,
    String? usVCA3,
    String? usVCA4,
    String? usVCA6,
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
      dsInSlope1: dsInSlope1 ?? this.dsInSlope1,
      dsInSlope3: dsInSlope3 ?? this.dsInSlope3,
      dsInSlope4: dsInSlope4 ?? this.dsInSlope4,
      dsInSlope6: dsInSlope6 ?? this.dsInSlope6,
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
        dsInSlope1,
        dsInSlope3,
        dsInSlope4,
        dsInSlope6,
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
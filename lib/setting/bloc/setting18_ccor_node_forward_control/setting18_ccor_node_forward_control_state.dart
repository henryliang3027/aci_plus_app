part of 'setting18_ccor_node_forward_control_bloc.dart';

// C-Cor Node 的 dsVVA{x}, dsInSlope{x}, usVCA{x}, returnIngressSetting{x}
// x 代表的是 port 的數字

class Setting18CCorNodeForwardControlState extends Equatable {
  const Setting18CCorNodeForwardControlState({
    this.submissionStatus = SubmissionStatus.none,
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
    this.biasCurrent1 = const RangeFloatPointInput.pure(),
    this.biasCurrent3 = const RangeFloatPointInput.pure(),
    this.biasCurrent4 = const RangeFloatPointInput.pure(),
    this.biasCurrent6 = const RangeFloatPointInput.pure(),
    this.editMode = false,
    this.enableSubmission = false,
    this.initialValues = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
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
  final RangeFloatPointInput biasCurrent1;
  final RangeFloatPointInput biasCurrent3;
  final RangeFloatPointInput biasCurrent4;
  final RangeFloatPointInput biasCurrent6;
  final bool editMode;
  final bool enableSubmission;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;

  Setting18CCorNodeForwardControlState copyWith({
    SubmissionStatus? submissionStatus,
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
    RangeFloatPointInput? biasCurrent1,
    RangeFloatPointInput? biasCurrent3,
    RangeFloatPointInput? biasCurrent4,
    RangeFloatPointInput? biasCurrent6,
    bool? editMode,
    bool? enableSubmission,
    Map<DataKey, String>? initialValues,
    List<String>? settingResult,
  }) {
    return Setting18CCorNodeForwardControlState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
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
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      initialValues: initialValues ?? this.initialValues,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
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
        editMode,
        enableSubmission,
        initialValues,
        settingResult,
      ];
}

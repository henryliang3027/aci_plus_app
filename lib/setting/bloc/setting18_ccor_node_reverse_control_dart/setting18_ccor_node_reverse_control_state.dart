part of 'setting18_ccor_node_reverse_control_bloc.dart';

class Setting18CCorNodeReverseControlState extends Equatable {
  const Setting18CCorNodeReverseControlState({
    this.submissionStatus = SubmissionStatus.none,
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
    this.editMode = false,
    this.enableSubmission = false,
    this.initialValues = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
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
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;

  Setting18CCorNodeReverseControlState copyWith({
    SubmissionStatus? submissionStatus,
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
    Map<DataKey, String>? initialValues,
    List<String>? settingResult,
  }) {
    return Setting18CCorNodeReverseControlState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
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
      initialValues: initialValues ?? this.initialValues,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
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
        initialValues,
        settingResult,
      ];
}

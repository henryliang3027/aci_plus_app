part of 'setting18_reverse_control_bloc.dart';

class Setting18ReverseControlState extends Equatable {
  const Setting18ReverseControlState({
    this.submissionStatus = SubmissionStatus.none,
    this.resetReverseValuesSubmissionStatus = SubmissionStatus.none,
    this.usVCA1 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 25,
    ),
    this.usVCA2 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 15,
    ),
    this.usVCA3 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 25,
    ),
    this.usVCA4 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 25,
    ),
    this.eREQ = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 15,
    ),
    this.returnIngressSetting2 = '',
    this.returnIngressSetting3 = '',
    this.returnIngressSetting4 = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.initialValues = const {},
    this.tappedSet = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final SubmissionStatus resetReverseValuesSubmissionStatus;
  final RangeFloatPointInput usVCA1;
  final RangeFloatPointInput usVCA2;
  final RangeFloatPointInput usVCA3;
  final RangeFloatPointInput usVCA4;
  final RangeFloatPointInput eREQ;
  final String returnIngressSetting2;
  final String returnIngressSetting3;
  final String returnIngressSetting4;
  final bool editMode;
  final bool enableSubmission;
  final Map<DataKey, String> initialValues;
  final Set<DataKey> tappedSet;
  final List<String> settingResult;

  Setting18ReverseControlState copyWith({
    SubmissionStatus? submissionStatus,
    SubmissionStatus? resetReverseValuesSubmissionStatus,
    RangeFloatPointInput? usVCA1,
    RangeFloatPointInput? usVCA2,
    RangeFloatPointInput? usVCA3,
    RangeFloatPointInput? usVCA4,
    RangeFloatPointInput? eREQ,
    String? returnIngressSetting2,
    String? returnIngressSetting3,
    String? returnIngressSetting4,
    bool? editMode,
    bool? enableSubmission,
    Map<DataKey, String>? initialValues,
    Set<DataKey>? tappedSet,
    List<String>? settingResult,
  }) {
    return Setting18ReverseControlState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      resetReverseValuesSubmissionStatus: resetReverseValuesSubmissionStatus ??
          this.resetReverseValuesSubmissionStatus,
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
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      initialValues: initialValues ?? this.initialValues,
      tappedSet: tappedSet ?? this.tappedSet,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        resetReverseValuesSubmissionStatus,
        usVCA1,
        usVCA2,
        usVCA3,
        usVCA4,
        eREQ,
        returnIngressSetting2,
        returnIngressSetting3,
        returnIngressSetting4,
        editMode,
        enableSubmission,
        initialValues,
        tappedSet,
        settingResult,
      ];
}

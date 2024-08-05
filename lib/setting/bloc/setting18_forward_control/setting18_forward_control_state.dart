part of 'setting18_forward_control_bloc.dart';

class Setting18ForwardControlState extends Equatable {
  const Setting18ForwardControlState({
    this.submissionStatus = SubmissionStatus.none,
    this.resetForwardValuesSubmissionStatus = SubmissionStatus.none,
    this.dsVVA1 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 30,
    ),
    this.dsVVA2 = const RangeFloatPointInput.pure(),
    this.dsVVA3 = const RangeFloatPointInput.pure(),
    this.dsVVA4 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 10,
    ),
    this.dsVVA5 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 10,
    ),
    this.dsSlope1 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 12,
    ),
    this.dsSlope2 = const RangeFloatPointInput.pure(),
    this.dsSlope3 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 10,
    ),
    this.dsSlope4 = const RangeFloatPointInput.pure(
      minValue: 0,
      maxValue: 10,
    ),
    this.tgcCableLength = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.initialValues = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final SubmissionStatus resetForwardValuesSubmissionStatus;
  final RangeFloatPointInput dsVVA1;
  final RangeFloatPointInput dsVVA2;
  final RangeFloatPointInput dsVVA3;
  final RangeFloatPointInput dsVVA4;
  final RangeFloatPointInput dsVVA5;
  final RangeFloatPointInput dsSlope1;
  final RangeFloatPointInput dsSlope2;
  final RangeFloatPointInput dsSlope3;
  final RangeFloatPointInput dsSlope4;
  final String tgcCableLength;
  final bool editMode;
  final bool enableSubmission;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;

  Setting18ForwardControlState copyWith({
    SubmissionStatus? submissionStatus,
    SubmissionStatus? resetForwardValuesSubmissionStatus,
    RangeFloatPointInput? dsVVA1,
    RangeFloatPointInput? dsVVA2,
    RangeFloatPointInput? dsVVA3,
    RangeFloatPointInput? dsVVA4,
    RangeFloatPointInput? dsVVA5,
    RangeFloatPointInput? dsSlope1,
    RangeFloatPointInput? dsSlope2,
    RangeFloatPointInput? dsSlope3,
    RangeFloatPointInput? dsSlope4,
    String? tgcCableLength,
    bool? editMode,
    bool? enableSubmission,
    Map<DataKey, String>? initialValues,
    List<String>? settingResult,
  }) {
    return Setting18ForwardControlState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      resetForwardValuesSubmissionStatus: resetForwardValuesSubmissionStatus ??
          this.resetForwardValuesSubmissionStatus,
      dsVVA1: dsVVA1 ?? this.dsVVA1,
      dsVVA2: dsVVA2 ?? this.dsVVA2,
      dsVVA3: dsVVA3 ?? this.dsVVA3,
      dsVVA4: dsVVA4 ?? this.dsVVA4,
      dsVVA5: dsVVA5 ?? this.dsVVA5,
      dsSlope1: dsSlope1 ?? this.dsSlope1,
      dsSlope2: dsSlope2 ?? this.dsSlope2,
      dsSlope3: dsSlope3 ?? this.dsSlope3,
      dsSlope4: dsSlope4 ?? this.dsSlope4,
      tgcCableLength: tgcCableLength ?? this.tgcCableLength,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      initialValues: initialValues ?? this.initialValues,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        resetForwardValuesSubmissionStatus,
        dsVVA1,
        dsVVA2,
        dsVVA3,
        dsVVA4,
        dsVVA5,
        dsSlope1,
        dsSlope2,
        dsSlope3,
        dsSlope4,
        tgcCableLength,
        editMode,
        enableSubmission,
        initialValues,
        settingResult,
      ];
}

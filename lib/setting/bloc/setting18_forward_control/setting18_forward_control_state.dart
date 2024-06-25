part of 'setting18_forward_control_bloc.dart';

class Setting18ForwardControlState extends Equatable {
  const Setting18ForwardControlState({
    this.submissionStatus = SubmissionStatus.none,
    this.resetForwardValuesSubmissionStatus = SubmissionStatus.none,
    this.dsVVA1 = '',
    this.dsVVA2 = '',
    this.dsVVA3 = '',
    this.dsVVA4 = '',
    this.dsVVA5 = '',
    this.dsSlope1 = '',
    this.dsSlope2 = '',
    this.dsSlope3 = '',
    this.dsSlope4 = '',
    this.tgcCableLength = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.initialValues = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final SubmissionStatus resetForwardValuesSubmissionStatus;
  final String dsVVA1;
  final String dsVVA2;
  final String dsVVA3;
  final String dsVVA4;
  final String dsVVA5;
  final String dsSlope1;
  final String dsSlope2;
  final String dsSlope3;
  final String dsSlope4;
  final String tgcCableLength;
  final bool editMode;
  final bool enableSubmission;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;

  Setting18ForwardControlState copyWith({
    SubmissionStatus? submissionStatus,
    SubmissionStatus? resetForwardValuesSubmissionStatus,
    String? dsVVA1,
    String? dsVVA2,
    String? dsVVA3,
    String? dsVVA4,
    String? dsVVA5,
    String? dsSlope1,
    String? dsSlope2,
    String? dsSlope3,
    String? dsSlope4,
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

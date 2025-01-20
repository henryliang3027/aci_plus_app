part of 'setting18_forward_control_bloc.dart';

class Setting18ForwardControlState extends Equatable {
  const Setting18ForwardControlState({
    this.submissionStatus = SubmissionStatus.none,
    this.resetForwardValuesSubmissionStatus = SubmissionStatus.none,
    this.editMode = false,
    this.enableSubmission = false,
    this.targetValues = const {},
    this.initialValues = const {},
    this.tappedSet = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final SubmissionStatus resetForwardValuesSubmissionStatus;

  final bool editMode;
  final bool enableSubmission;
  final Map<DataKey, RangeFloatPointInput> targetValues;
  final Map<DataKey, String> initialValues;
  final Set<DataKey> tappedSet;
  final List<String> settingResult;

  Setting18ForwardControlState copyWith({
    SubmissionStatus? submissionStatus,
    SubmissionStatus? resetForwardValuesSubmissionStatus,
    bool? editMode,
    bool? enableSubmission,
    Map<DataKey, RangeFloatPointInput>? targetValues,
    Map<DataKey, String>? initialValues,
    Set<DataKey>? tappedSet,
    List<String>? settingResult,
  }) {
    return Setting18ForwardControlState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      resetForwardValuesSubmissionStatus: resetForwardValuesSubmissionStatus ??
          this.resetForwardValuesSubmissionStatus,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      targetValues: targetValues ?? this.targetValues,
      initialValues: initialValues ?? this.initialValues,
      tappedSet: tappedSet ?? this.tappedSet,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        resetForwardValuesSubmissionStatus,
        editMode,
        enableSubmission,
        targetValues,
        initialValues,
        tappedSet,
        settingResult,
      ];
}

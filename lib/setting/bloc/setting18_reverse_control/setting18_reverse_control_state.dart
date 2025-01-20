part of 'setting18_reverse_control_bloc.dart';

class Setting18ReverseControlState extends Equatable {
  const Setting18ReverseControlState({
    this.submissionStatus = SubmissionStatus.none,
    this.resetReverseValuesSubmissionStatus = SubmissionStatus.none,
    this.editMode = false,
    this.enableSubmission = false,
    this.targetValues = const {},
    this.targetIngressValues = const {},
    this.initialValues = const {},
    this.tappedSet = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final SubmissionStatus resetReverseValuesSubmissionStatus;
  final bool editMode;
  final bool enableSubmission;
  final Map<DataKey, RangeFloatPointInput> targetValues;
  final Map<DataKey, String> targetIngressValues;
  final Map<DataKey, String> initialValues;
  final Set<DataKey> tappedSet;
  final List<String> settingResult;

  Setting18ReverseControlState copyWith({
    SubmissionStatus? submissionStatus,
    SubmissionStatus? resetReverseValuesSubmissionStatus,
    bool? editMode,
    bool? enableSubmission,
    Map<DataKey, RangeFloatPointInput>? targetValues,
    Map<DataKey, String>? targetIngressValues,
    Map<DataKey, String>? initialValues,
    Set<DataKey>? tappedSet,
    List<String>? settingResult,
  }) {
    return Setting18ReverseControlState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      resetReverseValuesSubmissionStatus: resetReverseValuesSubmissionStatus ??
          this.resetReverseValuesSubmissionStatus,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      targetValues: targetValues ?? this.targetValues,
      targetIngressValues: targetIngressValues ?? this.targetIngressValues,
      initialValues: initialValues ?? this.initialValues,
      tappedSet: tappedSet ?? this.tappedSet,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        resetReverseValuesSubmissionStatus,
        editMode,
        enableSubmission,
        targetValues,
        targetIngressValues,
        initialValues,
        tappedSet,
        settingResult,
      ];
}

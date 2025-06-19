part of 'setting18_ingress_control_bloc.dart';

class Setting18IngressControlState extends Equatable {
  const Setting18IngressControlState({
    this.submissionStatus = SubmissionStatus.none,
    this.editMode = false,
    this.enableSubmission = false,
    this.targetValues = const {},
    this.initialValues = const {},
    this.tappedSet = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final bool editMode;
  final bool enableSubmission;
  final Map<DataKey, String> targetValues;
  final Map<DataKey, String> initialValues;
  final Set<DataKey> tappedSet;
  final List<String> settingResult;

  Setting18IngressControlState copyWith({
    SubmissionStatus? submissionStatus,
    bool? editMode,
    bool? enableSubmission,
    Map<DataKey, String>? targetValues,
    Map<DataKey, String>? initialValues,
    Set<DataKey>? tappedSet,
    List<String>? settingResult,
  }) {
    return Setting18IngressControlState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
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
        editMode,
        enableSubmission,
        targetValues,
        initialValues,
        tappedSet,
        settingResult,
      ];
}

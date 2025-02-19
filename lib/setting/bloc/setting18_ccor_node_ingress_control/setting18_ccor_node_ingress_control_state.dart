part of 'setting18_ccor_node_ingress_control_bloc.dart';

class Setting18CCorNodeIngressControlState extends Equatable {
  const Setting18CCorNodeIngressControlState({
    this.submissionStatus = SubmissionStatus.none,
    this.returnIngressSetting1 = '',
    this.returnIngressSetting3 = '',
    this.returnIngressSetting4 = '',
    this.returnIngressSetting6 = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.initialValues = const {},
    this.tappedSet = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final String returnIngressSetting1;
  final String returnIngressSetting3;
  final String returnIngressSetting4;
  final String returnIngressSetting6;
  final bool editMode;
  final bool enableSubmission;
  final Map<DataKey, String> initialValues;
  final Set<DataKey> tappedSet;
  final List<String> settingResult;

  Setting18CCorNodeIngressControlState copyWith({
    SubmissionStatus? submissionStatus,
    String? returnIngressSetting1,
    String? returnIngressSetting3,
    String? returnIngressSetting4,
    String? returnIngressSetting6,
    bool? editMode,
    bool? enableSubmission,
    Map<DataKey, String>? initialValues,
    Set<DataKey>? tappedSet,
    List<String>? settingResult,
  }) {
    return Setting18CCorNodeIngressControlState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
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
      tappedSet: tappedSet ?? this.tappedSet,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        returnIngressSetting1,
        returnIngressSetting3,
        returnIngressSetting4,
        returnIngressSetting6,
        editMode,
        enableSubmission,
        initialValues,
        tappedSet,
        settingResult,
      ];
}

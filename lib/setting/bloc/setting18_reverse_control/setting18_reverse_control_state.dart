part of 'setting18_reverse_control_bloc.dart';

class Setting18ReverseControlState extends Equatable {
  const Setting18ReverseControlState({
    this.submissionStatus = SubmissionStatus.none,
    this.resetReverseValuesSubmissionStatus = SubmissionStatus.none,
    this.usVCA1 = '',
    this.usVCA2 = '',
    this.usVCA3 = '',
    this.usVCA4 = '',
    this.eREQ = '',
    this.returnIngressSetting2 = '',
    this.returnIngressSetting3 = '',
    this.returnIngressSetting4 = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.initialValues = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final SubmissionStatus resetReverseValuesSubmissionStatus;
  final String usVCA1;
  final String usVCA2;
  final String usVCA3;
  final String usVCA4;
  final String eREQ;
  final String returnIngressSetting2;
  final String returnIngressSetting3;
  final String returnIngressSetting4;
  final bool editMode;
  final bool enableSubmission;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;

  Setting18ReverseControlState copyWith({
    SubmissionStatus? submissionStatus,
    SubmissionStatus? resetReverseValuesSubmissionStatus,
    String? usVCA1,
    String? usVCA2,
    String? usVCA3,
    String? usVCA4,
    String? eREQ,
    String? returnIngressSetting2,
    String? returnIngressSetting3,
    String? returnIngressSetting4,
    bool? editMode,
    bool? enableSubmission,
    Map<DataKey, String>? initialValues,
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
        settingResult,
      ];
}

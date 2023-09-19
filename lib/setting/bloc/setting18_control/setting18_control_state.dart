part of 'setting18_control_bloc.dart';

class Setting18ControlState extends Equatable {
  const Setting18ControlState({
    this.submissionStatus = SubmissionStatus.none,
    this.fwdInputAttenuation = '',
    this.fwdInputEQ = '',
    this.rtnInputAttenuation2 = '',
    this.rtnInputAttenuation3 = '',
    this.rtnInputAttenuation4 = '',
    this.rtnOutputLevelAttenuation = '',
    this.rtnOutputEQ = '',
    this.rtnIngressSetting2 = '',
    this.rtnIngressSetting3 = '',
    this.rtnIngressSetting4 = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const [],
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final String fwdInputAttenuation;
  final String fwdInputEQ;
  final String rtnInputAttenuation2;
  final String rtnInputAttenuation3;
  final String rtnInputAttenuation4;
  final String rtnOutputLevelAttenuation;
  final String rtnOutputEQ;
  final String rtnIngressSetting2;
  final String rtnIngressSetting3;
  final String rtnIngressSetting4;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final List<dynamic> initialValues;
  final List<String> settingResult;

  Setting18ControlState copyWith({
    SubmissionStatus? submissionStatus,
    String? fwdInputAttenuation,
    String? fwdInputEQ,
    String? rtnInputAttenuation2,
    String? rtnInputAttenuation3,
    String? rtnInputAttenuation4,
    String? rtnOutputLevelAttenuation,
    String? rtnOutputEQ,
    String? rtnIngressSetting2,
    String? rtnIngressSetting3,
    String? rtnIngressSetting4,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    List<dynamic>? initialValues,
    List<String>? settingResult,
  }) {
    return Setting18ControlState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      fwdInputAttenuation: fwdInputAttenuation ?? this.fwdInputAttenuation,
      fwdInputEQ: fwdInputEQ ?? this.fwdInputEQ,
      rtnInputAttenuation2: rtnInputAttenuation2 ?? this.rtnInputAttenuation2,
      rtnInputAttenuation3: rtnInputAttenuation3 ?? this.rtnInputAttenuation3,
      rtnInputAttenuation4: rtnInputAttenuation4 ?? this.rtnInputAttenuation4,
      rtnOutputLevelAttenuation:
          rtnOutputLevelAttenuation ?? this.rtnOutputLevelAttenuation,
      rtnOutputEQ: rtnOutputEQ ?? this.rtnOutputEQ,
      rtnIngressSetting2: rtnIngressSetting2 ?? this.rtnIngressSetting2,
      rtnIngressSetting3: rtnIngressSetting3 ?? this.rtnIngressSetting3,
      rtnIngressSetting4: rtnIngressSetting4 ?? this.rtnIngressSetting4,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
      initialValues: initialValues ?? this.initialValues,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        fwdInputAttenuation,
        fwdInputEQ,
        rtnInputAttenuation2,
        rtnInputAttenuation3,
        rtnInputAttenuation4,
        rtnOutputLevelAttenuation,
        rtnOutputEQ,
        rtnIngressSetting2,
        rtnIngressSetting3,
        rtnIngressSetting4,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
      ];
}

part of 'setting18_control_bloc.dart';

class Setting18ControlState extends Equatable {
  const Setting18ControlState({
    this.submissionStatus = SubmissionStatus.none,
    this.fwdInputAttenuation = 0.0,
    this.fwdInputEQ = 0.0,
    this.rtnInputAttenuation2 = 0.0,
    this.rtnInputAttenuation3 = 0.0,
    this.rtnInputAttenuation4 = 0.0,
    this.rtnOutputLevelAttenuation = 0.0,
    this.rtnOutputEQ = 0.0,
    this.rtnIngressSetting2 = '',
    this.rtnIngressSetting3 = '',
    this.rtnIngressSetting4 = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
  });

  final SubmissionStatus submissionStatus;
  final double fwdInputAttenuation;
  final double fwdInputEQ;
  final double rtnInputAttenuation2;
  final double rtnInputAttenuation3;
  final double rtnInputAttenuation4;
  final double rtnOutputLevelAttenuation;
  final double rtnOutputEQ;
  final String rtnIngressSetting2;
  final String rtnIngressSetting3;
  final String rtnIngressSetting4;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;

  Setting18ControlState copyWith({
    SubmissionStatus? submissionStatus,
    double? fwdInputAttenuation,
    double? fwdInputEQ,
    double? rtnInputAttenuation2,
    double? rtnInputAttenuation3,
    double? rtnInputAttenuation4,
    double? rtnOutputLevelAttenuation,
    double? rtnOutputEQ,
    String? rtnIngressSetting2,
    String? rtnIngressSetting3,
    String? rtnIngressSetting4,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
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
      ];
}

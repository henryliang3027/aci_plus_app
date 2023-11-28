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
    this.tgcCableLength = '',
    this.dsVVA2 = '',
    this.dsSlope2 = '',
    this.dsVVA3 = '',
    this.dsVVA4 = '',
    this.usTGC = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const {},
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
  final String tgcCableLength;
  final String dsVVA2;
  final String dsSlope2;
  final String dsVVA3;
  final String dsVVA4;
  final String usTGC;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
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
    String? tgcCableLength,
    String? dsVVA2,
    String? dsSlope2,
    String? dsVVA3,
    String? dsVVA4,
    String? usTGC,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    Map<DataKey, String>? initialValues,
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
      tgcCableLength: tgcCableLength ?? this.tgcCableLength,
      dsVVA2: dsVVA2 ?? this.dsVVA2,
      dsSlope2: dsSlope2 ?? this.dsSlope2,
      dsVVA3: dsVVA3 ?? this.dsVVA3,
      dsVVA4: dsVVA4 ?? this.dsVVA4,
      usTGC: usTGC ?? this.usTGC,
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
        tgcCableLength,
        dsVVA2,
        dsSlope2,
        dsVVA3,
        dsVVA4,
        usTGC,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
      ];
}

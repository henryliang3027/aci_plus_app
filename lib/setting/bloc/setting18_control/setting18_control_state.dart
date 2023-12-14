part of 'setting18_control_bloc.dart';

class Setting18ControlState extends Equatable {
  const Setting18ControlState({
    this.submissionStatus = SubmissionStatus.none,
    this.dsVVA1 = '',
    this.dsSlope1 = '',
    this.usVCA1 = '',
    this.usVCA3 = '',
    this.usVCA4 = '',
    this.usVCA2 = '',
    this.eREQ = '',
    this.rtnIngressSetting2 = '',
    this.rtnIngressSetting3 = '',
    this.rtnIngressSetting4 = '',
    this.tgcCableLength = '',
    this.dsVVA2 = '',
    this.dsSlope2 = '',
    this.dsVVA3 = '',
    this.dsVVA4 = '',
    this.dsVVA5 = '',
    this.dsSlope3 = '',
    this.dsSlope4 = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final String dsVVA1;
  final String dsSlope1;
  final String usVCA1;
  final String usVCA3;
  final String usVCA4;
  final String usVCA2;
  final String eREQ;
  final String rtnIngressSetting2;
  final String rtnIngressSetting3;
  final String rtnIngressSetting4;
  final String tgcCableLength;
  final String dsVVA2;
  final String dsSlope2;
  final String dsVVA3;
  final String dsVVA4;
  final String dsVVA5;
  final String dsSlope3;
  final String dsSlope4;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;

  Setting18ControlState copyWith({
    SubmissionStatus? submissionStatus,
    String? dsVVA1,
    String? dsSlope1,
    String? usVCA1,
    String? usVCA3,
    String? usVCA4,
    String? usVCA2,
    String? eREQ,
    String? rtnIngressSetting2,
    String? rtnIngressSetting3,
    String? rtnIngressSetting4,
    String? tgcCableLength,
    String? dsVVA2,
    String? dsSlope2,
    String? dsVVA3,
    String? dsVVA4,
    String? dsVVA5,
    String? dsSlope3,
    String? dsSlope4,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    Map<DataKey, String>? initialValues,
    List<String>? settingResult,
  }) {
    return Setting18ControlState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      dsVVA1: dsVVA1 ?? this.dsVVA1,
      dsSlope1: dsSlope1 ?? this.dsSlope1,
      usVCA1: usVCA1 ?? this.usVCA1,
      usVCA3: usVCA3 ?? this.usVCA3,
      usVCA4: usVCA4 ?? this.usVCA4,
      usVCA2: usVCA2 ?? this.usVCA2,
      eREQ: eREQ ?? this.eREQ,
      rtnIngressSetting2: rtnIngressSetting2 ?? this.rtnIngressSetting2,
      rtnIngressSetting3: rtnIngressSetting3 ?? this.rtnIngressSetting3,
      rtnIngressSetting4: rtnIngressSetting4 ?? this.rtnIngressSetting4,
      tgcCableLength: tgcCableLength ?? this.tgcCableLength,
      dsVVA2: dsVVA2 ?? this.dsVVA2,
      dsSlope2: dsSlope2 ?? this.dsSlope2,
      dsVVA3: dsVVA3 ?? this.dsVVA3,
      dsVVA4: dsVVA4 ?? this.dsVVA4,
      dsVVA5: dsVVA5 ?? this.dsVVA5,
      dsSlope3: dsSlope3 ?? this.dsSlope3,
      dsSlope4: dsSlope4 ?? this.dsSlope4,
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
        dsVVA1,
        dsSlope1,
        usVCA1,
        usVCA3,
        usVCA4,
        usVCA2,
        eREQ,
        rtnIngressSetting2,
        rtnIngressSetting3,
        rtnIngressSetting4,
        tgcCableLength,
        dsVVA2,
        dsSlope2,
        dsVVA3,
        dsVVA4,
        dsVVA5,
        dsSlope3,
        dsSlope4,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
      ];
}

part of 'setting18_ccor_node_control_bloc.dart';

class Setting18CCorNodeControlState extends Equatable {
  const Setting18CCorNodeControlState({
    this.submissionStatus = SubmissionStatus.none,
    this.returnInputAttenuation1 = '',
    this.returnInputAttenuation3 = '',
    this.returnInputAttenuation4 = '',
    this.returnInputAttenuation6 = '',
    this.returnIngressSetting1 = '',
    this.returnIngressSetting3 = '',
    this.returnIngressSetting4 = '',
    this.returnIngressSetting6 = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const [],
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final String returnInputAttenuation1;
  final String returnInputAttenuation3;
  final String returnInputAttenuation4;
  final String returnInputAttenuation6;
  final String returnIngressSetting1;
  final String returnIngressSetting3;
  final String returnIngressSetting4;
  final String returnIngressSetting6;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final List<dynamic> initialValues;
  final List<String> settingResult;

  Setting18CCorNodeControlState copyWith({
    SubmissionStatus? submissionStatus,
    String? returnInputAttenuation1,
    String? returnInputAttenuation3,
    String? returnInputAttenuation4,
    String? returnInputAttenuation6,
    String? returnIngressSetting1,
    String? returnIngressSetting3,
    String? returnIngressSetting4,
    String? returnIngressSetting6,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    List<dynamic>? initialValues,
    List<String>? settingResult,
  }) {
    return Setting18CCorNodeControlState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      returnInputAttenuation1:
          returnInputAttenuation1 ?? this.returnInputAttenuation1,
      returnInputAttenuation3:
          returnInputAttenuation3 ?? this.returnInputAttenuation3,
      returnInputAttenuation4:
          returnInputAttenuation4 ?? this.returnInputAttenuation4,
      returnInputAttenuation6:
          returnInputAttenuation6 ?? this.returnInputAttenuation6,
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
      isInitialize: isInitialize ?? this.isInitialize,
      initialValues: initialValues ?? this.initialValues,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        returnInputAttenuation1,
        returnInputAttenuation3,
        returnInputAttenuation4,
        returnInputAttenuation6,
        returnIngressSetting1,
        returnIngressSetting3,
        returnIngressSetting4,
        returnIngressSetting6,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
      ];
}

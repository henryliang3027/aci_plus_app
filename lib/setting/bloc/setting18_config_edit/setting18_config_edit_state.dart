part of 'setting18_config_edit_bloc.dart';

class Setting18ConfigEditState extends Equatable {
  const Setting18ConfigEditState({
    this.formStatus = FormStatus.none,
    this.saveStatus = SubmissionStatus.none,
    this.settingStatus = SubmissionStatus.none,
    this.partId = '',
    this.firstChannelLoadingFrequency = '',
    this.lastChannelLoadingFrequency = '',
    this.firstChannelLoadingLevel = '',
    this.lastChannelLoadingLevel = '',
    this.initialValues = const {},
    this.settingResult = const [],
    this.enableSubmission = false,
  });

  final FormStatus formStatus;
  final SubmissionStatus saveStatus;
  final SubmissionStatus settingStatus;
  final String partId;
  final String firstChannelLoadingFrequency;
  final String firstChannelLoadingLevel;
  final String lastChannelLoadingFrequency;
  final String lastChannelLoadingLevel;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;
  final bool enableSubmission;

  Setting18ConfigEditState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? saveStatus,
    SubmissionStatus? settingStatus,
    String? partId,
    String? firstChannelLoadingFrequency,
    String? firstChannelLoadingLevel,
    String? lastChannelLoadingFrequency,
    String? lastChannelLoadingLevel,
    Map<DataKey, String>? initialValues,
    List<String>? settingResult,
    bool? enableSubmission,
  }) {
    return Setting18ConfigEditState(
      formStatus: formStatus ?? this.formStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      settingStatus: settingStatus ?? this.settingStatus,
      partId: partId ?? this.partId,
      firstChannelLoadingFrequency:
          firstChannelLoadingFrequency ?? this.firstChannelLoadingFrequency,
      firstChannelLoadingLevel:
          firstChannelLoadingLevel ?? this.firstChannelLoadingLevel,
      lastChannelLoadingFrequency:
          lastChannelLoadingFrequency ?? this.lastChannelLoadingFrequency,
      lastChannelLoadingLevel:
          lastChannelLoadingLevel ?? this.lastChannelLoadingLevel,
      initialValues: initialValues ?? this.initialValues,
      settingResult: settingResult ?? this.settingResult,
      enableSubmission: enableSubmission ?? this.enableSubmission,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        saveStatus,
        settingStatus,
        partId,
        firstChannelLoadingFrequency,
        firstChannelLoadingLevel,
        lastChannelLoadingFrequency,
        lastChannelLoadingLevel,
        initialValues,
        settingResult,
        enableSubmission,
      ];
}

part of 'setting18_config_edit_bloc.dart';

class Setting18ConfigEditState extends Equatable {
  const Setting18ConfigEditState({
    this.formStatus = FormStatus.none,
    this.saveStatus = SubmissionStatus.none,
    this.settingStatus = SubmissionStatus.none,
    this.splitOption = '0',
    this.groupId = '',
    this.name = const NameInput.pure(),
    this.firstChannelLoadingFrequency = const RangeIntegerInput.pure(),
    this.firstChannelLoadingLevel = const RangeFloatPointInput.pure(),
    this.lastChannelLoadingFrequency = const RangeIntegerInput.pure(),
    this.lastChannelLoadingLevel = const RangeFloatPointInput.pure(),
    this.isInitialize = false,
    this.settingResult = const [],
    this.enableSubmission = false,
  });

  final FormStatus formStatus;
  final SubmissionStatus saveStatus;
  final SubmissionStatus settingStatus;

  final String groupId;
  final NameInput name;
  final String splitOption;
  final RangeIntegerInput firstChannelLoadingFrequency;
  final RangeFloatPointInput firstChannelLoadingLevel;
  final RangeIntegerInput lastChannelLoadingFrequency;
  final RangeFloatPointInput lastChannelLoadingLevel;
  final bool isInitialize;
  final List<String> settingResult;
  final bool enableSubmission;

  Setting18ConfigEditState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? saveStatus,
    SubmissionStatus? settingStatus,
    String? groupId,
    NameInput? name,
    String? splitOption,
    RangeIntegerInput? firstChannelLoadingFrequency,
    RangeFloatPointInput? firstChannelLoadingLevel,
    RangeIntegerInput? lastChannelLoadingFrequency,
    RangeFloatPointInput? lastChannelLoadingLevel,
    bool? isInitialize,
    List<String>? settingResult,
    bool? enableSubmission,
  }) {
    return Setting18ConfigEditState(
      formStatus: formStatus ?? this.formStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      settingStatus: settingStatus ?? this.settingStatus,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      splitOption: splitOption ?? this.splitOption,
      firstChannelLoadingFrequency:
          firstChannelLoadingFrequency ?? this.firstChannelLoadingFrequency,
      firstChannelLoadingLevel:
          firstChannelLoadingLevel ?? this.firstChannelLoadingLevel,
      lastChannelLoadingFrequency:
          lastChannelLoadingFrequency ?? this.lastChannelLoadingFrequency,
      lastChannelLoadingLevel:
          lastChannelLoadingLevel ?? this.lastChannelLoadingLevel,
      isInitialize: isInitialize ?? this.isInitialize,
      settingResult: settingResult ?? this.settingResult,
      enableSubmission: enableSubmission ?? this.enableSubmission,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        saveStatus,
        settingStatus,
        groupId,
        name,
        splitOption,
        firstChannelLoadingFrequency,
        firstChannelLoadingLevel,
        lastChannelLoadingFrequency,
        lastChannelLoadingLevel,
        isInitialize,
        settingResult,
        enableSubmission,
      ];
}

part of 'setting18_config_edit_bloc.dart';

class Setting18ConfigEditState extends Equatable {
  const Setting18ConfigEditState({
    this.formStatus = FormStatus.none,
    // this.encodeStaus = FormStatus.none,
    this.saveStatus = SubmissionStatus.none,
    this.settingStatus = SubmissionStatus.none,
    this.splitOption = '0',
    this.groupId = '',
    this.name = '',
    this.firstChannelLoadingFrequency = const IntegerInput.pure(),
    this.firstChannelLoadingLevel = const FloatPointInput.pure(),
    this.lastChannelLoadingFrequency = const IntegerInput.pure(),
    this.lastChannelLoadingLevel = const FloatPointInput.pure(),
    // this.encodedData = '',
    this.isInitialize = false,
    this.initialValues = const {},
    this.settingResult = const [],
    this.enableSubmission = false,
  });

  final FormStatus formStatus;
  // final FormStatus encodeStaus;
  final SubmissionStatus saveStatus;
  final SubmissionStatus settingStatus;

  final String groupId;
  final String name;
  final String splitOption;
  final IntegerInput firstChannelLoadingFrequency;
  final FloatPointInput firstChannelLoadingLevel;
  final IntegerInput lastChannelLoadingFrequency;
  final FloatPointInput lastChannelLoadingLevel;
  // final String encodedData;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;
  final bool enableSubmission;

  Setting18ConfigEditState copyWith({
    FormStatus? formStatus,
    // FormStatus? encodeStaus,
    SubmissionStatus? saveStatus,
    SubmissionStatus? settingStatus,
    String? groupId,
    String? name,
    String? splitOption,
    IntegerInput? firstChannelLoadingFrequency,
    FloatPointInput? firstChannelLoadingLevel,
    IntegerInput? lastChannelLoadingFrequency,
    FloatPointInput? lastChannelLoadingLevel,
    // String? encodedData,
    bool? isInitialize,
    Map<DataKey, String>? initialValues,
    List<String>? settingResult,
    bool? enableSubmission,
  }) {
    return Setting18ConfigEditState(
      formStatus: formStatus ?? this.formStatus,
      // encodeStaus: encodeStaus ?? this.encodeStaus,
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
      // encodedData: encodedData ?? this.encodedData,
      isInitialize: isInitialize ?? this.isInitialize,
      initialValues: initialValues ?? this.initialValues,
      settingResult: settingResult ?? this.settingResult,
      enableSubmission: enableSubmission ?? this.enableSubmission,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        // encodeStaus,
        saveStatus,
        settingStatus,
        groupId,
        name,
        splitOption,
        firstChannelLoadingFrequency,
        firstChannelLoadingLevel,
        lastChannelLoadingFrequency,
        lastChannelLoadingLevel,
        // encodedData,
        isInitialize,
        initialValues,
        settingResult,
        enableSubmission,
      ];
}

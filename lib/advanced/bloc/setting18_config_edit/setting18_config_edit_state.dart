part of 'setting18_config_edit_bloc.dart';

class Setting18ConfigEditState extends Equatable {
  const Setting18ConfigEditState({
    this.formStatus = FormStatus.none,
    // this.encodeStaus = FormStatus.none,
    this.saveStatus = SubmissionStatus.none,
    this.settingStatus = SubmissionStatus.none,
    this.selectedPartId = '',
    this.firstChannelLoadingFrequency = const IntegerInput.pure(),
    this.firstChannelLoadingLevel = const FloatPointInput.pure(),
    this.lastChannelLoadingFrequency = const IntegerInput.pure(),
    this.lastChannelLoadingLevel = const FloatPointInput.pure(),
    // this.encodedData = '',
    this.isShortcut = false,
    this.isInitialize = false,
    this.initialValues = const {},
    this.settingResult = const [],
    this.enableSubmission = false,
  });

  final FormStatus formStatus;
  // final FormStatus encodeStaus;
  final SubmissionStatus saveStatus;
  final SubmissionStatus settingStatus;

  final String selectedPartId;
  final IntegerInput firstChannelLoadingFrequency;
  final FloatPointInput firstChannelLoadingLevel;
  final IntegerInput lastChannelLoadingFrequency;
  final FloatPointInput lastChannelLoadingLevel;
  // final String encodedData;
  final bool isShortcut;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;
  final bool enableSubmission;

  Setting18ConfigEditState copyWith({
    FormStatus? formStatus,
    // FormStatus? encodeStaus,
    SubmissionStatus? saveStatus,
    SubmissionStatus? settingStatus,
    String? selectedPartId,
    IntegerInput? firstChannelLoadingFrequency,
    FloatPointInput? firstChannelLoadingLevel,
    IntegerInput? lastChannelLoadingFrequency,
    FloatPointInput? lastChannelLoadingLevel,
    // String? encodedData,
    bool? isShortcut,
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
      selectedPartId: selectedPartId ?? this.selectedPartId,
      firstChannelLoadingFrequency:
          firstChannelLoadingFrequency ?? this.firstChannelLoadingFrequency,
      firstChannelLoadingLevel:
          firstChannelLoadingLevel ?? this.firstChannelLoadingLevel,
      lastChannelLoadingFrequency:
          lastChannelLoadingFrequency ?? this.lastChannelLoadingFrequency,
      lastChannelLoadingLevel:
          lastChannelLoadingLevel ?? this.lastChannelLoadingLevel,
      // encodedData: encodedData ?? this.encodedData,
      isShortcut: isShortcut ?? this.isShortcut,
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
        selectedPartId,
        firstChannelLoadingFrequency,
        firstChannelLoadingLevel,
        lastChannelLoadingFrequency,
        lastChannelLoadingLevel,
        // encodedData,
        isShortcut,
        isInitialize,
        initialValues,
        settingResult,
        enableSubmission,
      ];
}

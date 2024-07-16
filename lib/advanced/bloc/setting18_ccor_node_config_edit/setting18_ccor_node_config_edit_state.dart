part of 'setting18_ccor_node_config_edit_bloc.dart';

class Setting18CCorNodeConfigEditState extends Equatable {
  const Setting18CCorNodeConfigEditState({
    this.formStatus = FormStatus.none,
    this.saveStatus = SubmissionStatus.none,
    this.settingStatus = SubmissionStatus.none,
    this.groupId = '',
    this.name = const NameInput.pure(),
    this.forwardMode = '',
    this.forwardConfig = '',
    this.splitOption = '0',
    this.isInitialize = false,
    this.settingResult = const [],
    this.enableSubmission = false,
  });

  final FormStatus formStatus;
  final SubmissionStatus saveStatus;
  final SubmissionStatus settingStatus;

  final String groupId;
  final NameInput name;
  final String forwardMode;
  final String forwardConfig;
  final String splitOption;
  final bool isInitialize;
  final List<String> settingResult;
  final bool enableSubmission;

  Setting18CCorNodeConfigEditState copyWith({
    FormStatus? formStatus,
    SubmissionStatus? saveStatus,
    SubmissionStatus? settingStatus,
    String? groupId,
    NameInput? name,
    String? forwardMode,
    String? forwardConfig,
    String? splitOption,
    bool? isInitialize,
    List<String>? settingResult,
    bool? enableSubmission,
  }) {
    return Setting18CCorNodeConfigEditState(
      formStatus: formStatus ?? this.formStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      settingStatus: settingStatus ?? this.settingStatus,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      forwardMode: forwardMode ?? this.forwardMode,
      forwardConfig: forwardConfig ?? this.forwardConfig,
      splitOption: splitOption ?? this.splitOption,
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
        forwardMode,
        forwardConfig,
        splitOption,
        isInitialize,
        settingResult,
        enableSubmission,
      ];
}

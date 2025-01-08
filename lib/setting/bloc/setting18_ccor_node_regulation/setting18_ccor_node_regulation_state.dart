part of 'setting18_ccor_node_regulation_bloc.dart';

class Setting18CCorNodeRegulationState extends Equatable {
  const Setting18CCorNodeRegulationState({
    this.submissionStatus = SubmissionStatus.none,
    this.forwardConfig = '',
    this.splitOption = '1',
    this.forwardMode = '',
    this.logInterval = '30',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const {},
    this.tappedSet = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final String forwardConfig;
  final String splitOption;
  final String forwardMode;
  final String logInterval;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
  final Set<DataKey> tappedSet;
  final List<String> settingResult;

  Setting18CCorNodeRegulationState copyWith({
    SubmissionStatus? submissionStatus,
    String? forwardConfig,
    String? splitOption,
    String? forwardMode,
    String? logInterval,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    Map<DataKey, String>? initialValues,
    Set<DataKey>? tappedSet,
    List<String>? settingResult,
  }) {
    return Setting18CCorNodeRegulationState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      forwardConfig: forwardConfig ?? this.forwardConfig,
      splitOption: splitOption ?? this.splitOption,
      forwardMode: forwardMode ?? this.forwardMode,
      logInterval: logInterval ?? this.logInterval,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
      initialValues: initialValues ?? this.initialValues,
      tappedSet: tappedSet ?? this.tappedSet,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        forwardConfig,
        splitOption,
        forwardMode,
        logInterval,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
        tappedSet,
      ];
}

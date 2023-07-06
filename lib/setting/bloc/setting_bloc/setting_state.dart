part of 'setting_bloc.dart';

class SettingState extends Equatable {
  const SettingState({
    this.submissionStatus = SubmissionStatus.none,
    this.initialValues = const [],
    this.location = const Location.pure(),
    this.isGraphType = false,
    this.selectedTGCCableLength = const {
      '9': false,
      '18': false,
      '27': false,
    },
    this.selectedWorkingMode = const {
      'MGC': false,
      'AGC': false,
      'TGC': false,
    },
    this.logIntervalId = 1,
    this.pilotChannel = '',
    this.pilotMode = '', // IRC or DIG
    this.pilotCode = '',
    this.pilot2Channel = '',
    this.pilot2Mode = '', // IRC or DIG
    this.pilot2Code = '',
    this.maxAttenuation = 3000,
    this.minAttenuation = 0,
    this.currentAttenuation = 0,
    this.centerAttenuation = 0,
    this.hasDualPilot = false,
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final List<dynamic> initialValues;
  final Location location;
  final bool isGraphType;
  final Map<String, bool> selectedTGCCableLength;
  final Map<String, bool> selectedWorkingMode;
  final int logIntervalId;
  final String pilotChannel;
  final String pilotMode;
  final String pilotCode;
  final String pilot2Channel;
  final String pilot2Mode;
  final String pilot2Code;
  final int maxAttenuation;
  final int minAttenuation;
  final int currentAttenuation;
  final int centerAttenuation;
  final bool hasDualPilot;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final List<String> settingResult;

  SettingState copyWith({
    SubmissionStatus? submissionStatus,
    List<dynamic>? initialValues,
    Location? location,
    bool? isGraphType,
    Map<String, bool>? selectedTGCCableLength,
    Map<String, bool>? selectedWorkingMode,
    int? logIntervalId,
    String? pilotChannel,
    String? pilotMode,
    String? pilotCode,
    String? pilot2Channel,
    String? pilot2Mode,
    String? pilot2Code,
    int? maxAttenuation,
    int? minAttenuation,
    int? currentAttenuation,
    int? centerAttenuation,
    bool? hasDualPilot,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    List<String>? settingResult,
  }) {
    return SettingState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      initialValues: initialValues ?? this.initialValues,
      location: location ?? this.location,
      isGraphType: isGraphType ?? this.isGraphType,
      selectedTGCCableLength:
          selectedTGCCableLength ?? this.selectedTGCCableLength,
      selectedWorkingMode: selectedWorkingMode ?? this.selectedWorkingMode,
      logIntervalId: logIntervalId ?? this.logIntervalId,
      pilotChannel: pilotChannel ?? this.pilotChannel,
      pilotMode: pilotMode ?? this.pilotMode,
      pilotCode: pilotCode ?? this.pilotCode,
      pilot2Channel: pilot2Channel ?? this.pilot2Channel,
      pilot2Mode: pilot2Mode ?? this.pilot2Mode,
      pilot2Code: pilot2Code ?? this.pilot2Code,
      maxAttenuation: maxAttenuation ?? this.maxAttenuation,
      minAttenuation: minAttenuation ?? this.minAttenuation,
      currentAttenuation: currentAttenuation ?? this.currentAttenuation,
      centerAttenuation: centerAttenuation ?? this.centerAttenuation,
      hasDualPilot: hasDualPilot ?? this.hasDualPilot,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object?> get props => [
        submissionStatus,
        initialValues,
        location,
        isGraphType,
        selectedTGCCableLength,
        selectedWorkingMode,
        logIntervalId,
        pilotChannel,
        pilotMode,
        pilotCode,
        pilot2Channel,
        pilot2Mode,
        pilot2Code,
        maxAttenuation,
        minAttenuation,
        currentAttenuation,
        centerAttenuation,
        hasDualPilot,
        editMode,
        enableSubmission,
        isInitialize,
        settingResult,
      ];
}

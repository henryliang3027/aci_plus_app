part of 'setting_list_view_bloc.dart';

class SettingListViewState extends Equatable {
  const SettingListViewState({
    this.submissionStatus = SubmissionStatus.none,
    this.initialValues = const [],
    this.location = const Location.pure(),
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
    this.logIntervalId = '0',
    this.pilotChannelStatus = FormStatus.none,
    this.pilotChannel = '',
    this.pilotMode = '', // IRC or DIG
    this.pilotCode = const PilotCode.pure(),
    this.pilot2ChannelStatus = FormStatus.none,
    this.pilot2Channel = '',
    this.pilot2Mode = '', // IRC or DIG
    this.pilot2Code = const PilotCode.pure(),
    this.maxAttenuation = 3000,
    this.minAttenuation = 0,
    this.currentAttenuation = 0,
    this.centerAttenuation = 0,
    this.hasDualPilot = false,
    this.editable = false,
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.isChangedAGCPrepAttenuation = false,
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final List<dynamic> initialValues;
  final Location location;
  final Map<String, bool> selectedTGCCableLength;
  final Map<String, bool> selectedWorkingMode;
  final String logIntervalId;
  final FormStatus pilotChannelStatus;
  final String pilotChannel;
  final String pilotMode;
  final PilotCode pilotCode;
  final FormStatus pilot2ChannelStatus;
  final String pilot2Channel;
  final String pilot2Mode;
  final PilotCode pilot2Code;
  final int maxAttenuation;
  final int minAttenuation;
  final int currentAttenuation;
  final int centerAttenuation;
  final bool hasDualPilot;
  final bool editable;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final bool isChangedAGCPrepAttenuation;
  final List<String> settingResult;

  SettingListViewState copyWith({
    SubmissionStatus? submissionStatus,
    List<dynamic>? initialValues,
    Location? location,
    Map<String, bool>? selectedTGCCableLength,
    Map<String, bool>? selectedWorkingMode,
    String? logIntervalId,
    FormStatus? pilotChannelStatus,
    String? pilotChannel,
    String? pilotMode,
    PilotCode? pilotCode,
    FormStatus? pilot2ChannelStatus,
    String? pilot2Channel,
    String? pilot2Mode,
    PilotCode? pilot2Code,
    int? maxAttenuation,
    int? minAttenuation,
    int? currentAttenuation,
    int? centerAttenuation,
    bool? hasDualPilot,
    bool? editable,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    bool? isChangedAGCPrepAttenuation,
    List<String>? settingResult,
  }) {
    return SettingListViewState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      initialValues: initialValues ?? this.initialValues,
      location: location ?? this.location,
      selectedTGCCableLength:
          selectedTGCCableLength ?? this.selectedTGCCableLength,
      selectedWorkingMode: selectedWorkingMode ?? this.selectedWorkingMode,
      logIntervalId: logIntervalId ?? this.logIntervalId,
      pilotChannelStatus: pilotChannelStatus ?? this.pilotChannelStatus,
      pilotChannel: pilotChannel ?? this.pilotChannel,
      pilotMode: pilotMode ?? this.pilotMode,
      pilotCode: pilotCode ?? this.pilotCode,
      pilot2ChannelStatus: pilot2ChannelStatus ?? this.pilot2ChannelStatus,
      pilot2Channel: pilot2Channel ?? this.pilot2Channel,
      pilot2Mode: pilot2Mode ?? this.pilot2Mode,
      pilot2Code: pilot2Code ?? this.pilot2Code,
      maxAttenuation: maxAttenuation ?? this.maxAttenuation,
      minAttenuation: minAttenuation ?? this.minAttenuation,
      currentAttenuation: currentAttenuation ?? this.currentAttenuation,
      centerAttenuation: centerAttenuation ?? this.centerAttenuation,
      hasDualPilot: hasDualPilot ?? this.hasDualPilot,
      editable: editable ?? this.editable,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
      isChangedAGCPrepAttenuation:
          isChangedAGCPrepAttenuation ?? this.isChangedAGCPrepAttenuation,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object?> get props => [
        submissionStatus,
        initialValues,
        location,
        selectedTGCCableLength,
        selectedWorkingMode,
        logIntervalId,
        pilotChannelStatus,
        pilotChannel,
        pilotMode,
        pilotCode,
        pilot2ChannelStatus,
        pilot2Channel,
        pilot2Mode,
        pilot2Code,
        maxAttenuation,
        minAttenuation,
        currentAttenuation,
        centerAttenuation,
        hasDualPilot,
        editable,
        editMode,
        enableSubmission,
        isInitialize,
        isChangedAGCPrepAttenuation,
        settingResult,
      ];
}

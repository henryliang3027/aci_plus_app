import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/pilot_channel.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/setting/model/location.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc({required DsimRepository dsimRepository})
      : _dsimRepository = dsimRepository,
        super(const SettingState()) {
    on<Initialized>(_onInitialized);
    on<GraphViewToggled>(_onGraphViewToggled);
    on<ListViewToggled>(_onListViewToggled);
    on<LocationChanged>(_onLocationChanged);
    on<TGCCableLengthChanged>(_onTGCCableLengthChanged);
    on<WorkingModeChanged>(_onWorkingModeChanged);
    on<LogIntervalChanged>(_onLogIntervalChanged);
    on<PilotCodeChanged>(_onPilotCodeChanged);
    on<Pilot2CodeChanged>(_onPilot2CodeChanged);
    on<PilotChannelSearched>(_onPilotChannelSearched);
    on<Pilot2ChannelSearched>(_onPilot2ChannelSearched);
    on<AGCPrepAttenuationChanged>(_onAGCPrepAttenuationChanged);
    on<AGCPrepAttenuationIncreased>(_onAGCPrepAttenuationIncreased);
    on<AGCPrepAttenuationDecreased>(_onAGCPrepAttenuationDecreased);
    on<AGCPrepAttenuationCentered>(_onAGCPrepAttenuationCentered);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final DsimRepository _dsimRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<SettingState> emit,
  ) async {
    SettingData settingData = await _dsimRepository.getSettingData();

    final Location location = Location.dirty(settingData.location);

    final Map<String, bool> newSelectedTGCCableLength = {
      '9': false,
      '18': false,
      '27': false,
    };

    if (newSelectedTGCCableLength.containsKey(settingData.tgcCableLength)) {
      newSelectedTGCCableLength[settingData.tgcCableLength] = true;
    }

    final Map<String, bool> newSelectedWorkingMode = {
      'MGC': false,
      'AGC': false,
      'TGC': false,
    };

    if (newSelectedWorkingMode.containsKey(settingData.workingMode)) {
      newSelectedWorkingMode[settingData.workingMode] = true;
    }

    final int maxAttenuation = settingData.maxAttenuation.isNotEmpty
        ? int.parse(settingData.maxAttenuation)
        : 3000;
    final int minAttenuation = settingData.minAttenuation.isNotEmpty
        ? int.parse(settingData.minAttenuation)
        : 0;
    final int currentAttenuation = settingData.currentAttenuation.isNotEmpty
        ? int.parse(settingData.currentAttenuation)
        : 0;
    final int centerAttenuation = settingData.centerAttenuation.isNotEmpty
        ? int.parse(settingData.centerAttenuation)
        : 0;

    emit(state.copyWith(
      initialValues: [
        settingData.location,
        settingData.tgcCableLength,
        settingData.logIntervalId,
        settingData.workingMode,
        settingData.currentAttenuation,
      ],
      location: location,
      selectedTGCCableLength: newSelectedTGCCableLength,
      selectedWorkingMode: newSelectedWorkingMode,
      logIntervalId: settingData.logIntervalId,
      pilotChannel: _getPilotChannel(settingData.pilotCode),
      pilotMode: _getPilotMode(settingData.pilotCode),
      pilotCode: settingData.pilotCode,
      pilot2Channel: _getPilotChannel(settingData.pilot2Code),
      pilot2Mode: _getPilotMode(settingData.pilot2Code),
      pilot2Code: settingData.pilot2Code,
      maxAttenuation: maxAttenuation,
      minAttenuation: minAttenuation,
      currentAttenuation: currentAttenuation,
      centerAttenuation: centerAttenuation,
      hasDualPilot: settingData.hasDualPilot,
      isInitialize: true,
      submissionStatus: SubmissionStatus.none,
    ));
  }

  void _onGraphViewToggled(
    GraphViewToggled event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isInitialize: true,
      submissionStatus: SubmissionStatus.none,
      isGraphType: true,
    ));
  }

  void _onListViewToggled(
    ListViewToggled event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isInitialize: true,
      submissionStatus: SubmissionStatus.none,
      isGraphType: false,
    ));
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<SettingState> emit,
  ) {
    final Location location = Location.dirty(event.location);

    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      location: location,
      enableSubmission: location.value != state.initialValues[0],
    ));
  }

  void _onTGCCableLengthChanged(
    TGCCableLengthChanged event,
    Emitter<SettingState> emit,
  ) {
    Map<String, bool> newSelectedTGCCableLength = {
      '9': false,
      '18': false,
      '27': false,
    };

    newSelectedTGCCableLength[event.tgcCableLength] = true;

    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      selectedTGCCableLength: newSelectedTGCCableLength,
      enableSubmission: event.tgcCableLength != state.initialValues[1],
    ));
  }

  void _onLogIntervalChanged(
    LogIntervalChanged event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      logIntervalId: event.logIntervalId,
      enableSubmission: event.logIntervalId != state.initialValues[2],
    ));
  }

  void _onWorkingModeChanged(
    WorkingModeChanged event,
    Emitter<SettingState> emit,
  ) {
    Map<String, bool> newSelectedWorkingMode = {
      'MGC': false,
      'AGC': false,
      'TGC': false,
    };

    newSelectedWorkingMode[event.workingMode] = true;

    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      selectedWorkingMode: newSelectedWorkingMode,
      enableSubmission: event.workingMode != state.initialValues[3],
    ));
  }

  String _getPilotMode(String pilotCode) {
    if (pilotCode.substring(pilotCode.length - 1) == '@') {
      return 'IRC';
    } else {
      return 'DIG';
    }
  }

  String _getPilotChannel(String pilotCode) {
    String adjustedPilotCode = pilotCode;
    if (adjustedPilotCode.isNotEmpty) {
      if (adjustedPilotCode.substring(adjustedPilotCode.length - 1) == '@') {
        adjustedPilotCode =
            '${adjustedPilotCode.substring(0, adjustedPilotCode.length - 1)}A';
      }
    }

    String pilotChannel = PilotChannel.channelCode.keys.firstWhere(
      (k) => PilotChannel.channelCode[k] == adjustedPilotCode,
      orElse: () => '',
    );

    return pilotChannel;
  }

  void _onPilotCodeChanged(
    PilotCodeChanged event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      pilotCode: event.pilotCode,
    ));
  }

  Future<void> _onPilotChannelSearched(
    PilotChannelSearched event,
    Emitter<SettingState> emit,
  ) async {
    String pilotChannel = _getPilotChannel(state.pilotCode);
    String pilotMode = _getPilotMode(state.pilotCode);

    await _dsimRepository.writePilotCode(state.pilotCode);

    bool enableSubmission = state.pilotCode.isNotEmpty &&
        state.pilot2Code.isNotEmpty &&
        state.pilotChannel.isNotEmpty &&
        state.pilot2Channel.isNotEmpty;

    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      pilotChannel: pilotChannel,
      pilotMode: pilotMode,
      enableSubmission: enableSubmission,
    ));
  }

  void _onPilot2CodeChanged(
    Pilot2CodeChanged event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      pilot2Code: event.pilot2Code,
    ));
  }

  Future<void> _onPilot2ChannelSearched(
    Pilot2ChannelSearched event,
    Emitter<SettingState> emit,
  ) async {
    String pilot2Channel = _getPilotChannel(state.pilot2Code);
    String pilot2Mode = _getPilotMode(state.pilot2Code);

    await _dsimRepository.writePilot2Code(state.pilot2Code);

    bool enableSubmission = state.pilotCode.isNotEmpty &&
        state.pilot2Code.isNotEmpty &&
        state.pilotChannel.isNotEmpty &&
        pilot2Channel.isNotEmpty;

    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      pilot2Channel: pilot2Channel,
      pilot2Mode: pilot2Mode,
      enableSubmission: enableSubmission,
    ));
  }

  void _onAGCPrepAttenuationChanged(
    AGCPrepAttenuationChanged event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      currentAttenuation: event.attenuation,
      selectedWorkingMode: <String, bool>{
        'MGC': true,
        'AGC': false,
        'TGC': false,
      },
      enableSubmission: event.attenuation.toString() != state.initialValues[4],
    ));
  }

  void _onAGCPrepAttenuationIncreased(
    AGCPrepAttenuationIncreased event,
    Emitter<SettingState> emit,
  ) {
    int newAttenuation = state.currentAttenuation + 50 <= state.maxAttenuation
        ? state.currentAttenuation + 50
        : state.maxAttenuation;
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      currentAttenuation: newAttenuation,
      selectedWorkingMode: <String, bool>{
        'MGC': true,
        'AGC': false,
        'TGC': false,
      },
      enableSubmission: newAttenuation.toString() != state.initialValues[4],
    ));
  }

  void _onAGCPrepAttenuationDecreased(
    AGCPrepAttenuationDecreased event,
    Emitter<SettingState> emit,
  ) {
    int newAttenuation = state.currentAttenuation - 50 >= state.minAttenuation
        ? state.currentAttenuation - 50
        : state.minAttenuation;
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      currentAttenuation: newAttenuation,
      selectedWorkingMode: <String, bool>{
        'MGC': true,
        'AGC': false,
        'TGC': false,
      },
      enableSubmission: newAttenuation.toString() != state.initialValues[4],
    ));
  }

  void _onAGCPrepAttenuationCentered(
    AGCPrepAttenuationCentered event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      currentAttenuation: state.centerAttenuation,
      selectedWorkingMode: <String, bool>{
        'MGC': true,
        'AGC': false,
        'TGC': false,
      },
      enableSubmission:
          state.centerAttenuation.toString() != state.initialValues[4],
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: true,
      editMode: false,
      enableSubmission: false,
    ));
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<SettingState> emit,
  ) async {
    // initialValues: [
    //   settingData.location,
    //   settingData.tgcCableLength,
    //   settingData.logIntervalId,
    //   settingData.workingMode,
    //   settingData.currentAttenuation,
    // ],

    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    String workingMode = _getWorkingMode();
    String tgcCableLength = _getTgcCableLength();
    List<String> settingResult = [];

    if (state.location.value != state.initialValues[0]) {
      bool resultOfSettingLocation =
          await _dsimRepository.setLocation(state.location.value);

      settingResult.add('${DataKey.location.name},$resultOfSettingLocation');
    }

    if (tgcCableLength != state.initialValues[1]) {
      bool resultOfSettingTGCCableLength =
          await _dsimRepository.setTGCCableLength(
        currentAttenuation: state.currentAttenuation,
        tgcCableLength: tgcCableLength,
        pilotChannel: state.pilotChannel,
        pilotMode: state.pilotMode,
        logIntervalId: state.logIntervalId,
      );

      settingResult
          .add('${DataKey.tgcCableLength.name},$resultOfSettingTGCCableLength');
    }

    if (state.logIntervalId != state.initialValues[2]) {
      bool resultOfSettingLogInterval = await _dsimRepository.setLogInterval(
        logIntervalId: state.logIntervalId,
      );

      settingResult
          .add('${DataKey.logInterval.name},$resultOfSettingLogInterval');
    }

    if (workingMode != state.initialValues[3] ||
        state.currentAttenuation.toString() != state.initialValues[4]) {
      bool resultOfSettingWorkingMode = false;
      if (state.hasDualPilot) {
        resultOfSettingWorkingMode = await _dsimRepository.setWorkingMode(
          workingMode: workingMode,
          currentAttenuation: state.currentAttenuation,
          tgcCableLength: tgcCableLength,
          pilotChannel: state.pilotChannel,
          pilotMode: state.pilotMode,
          pilot2Channel: state.pilot2Channel,
          pilot2Mode: state.pilot2Mode,
          logIntervalId: state.logIntervalId,
        );
      } else {
        resultOfSettingWorkingMode = await _dsimRepository.setWorkingMode(
          workingMode: workingMode,
          currentAttenuation: state.currentAttenuation,
          tgcCableLength: tgcCableLength,
          pilotChannel: state.pilotChannel,
          pilotMode: state.pilotMode,
          logIntervalId: state.logIntervalId,
        );
      }

      settingResult.add('${DataKey.dsimMode.name},$resultOfSettingWorkingMode');
    }

    emit(state.copyWith(
      isInitialize: true,
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      editMode: false,
    ));
  }

  String _getWorkingMode() {
    return state.selectedWorkingMode.keys
        .firstWhere((k) => state.selectedWorkingMode[k] == true);
  }

  String _getTgcCableLength() {
    return state.selectedTGCCableLength.keys
        .firstWhere((k) => state.selectedTGCCableLength[k] == true);
  }
}

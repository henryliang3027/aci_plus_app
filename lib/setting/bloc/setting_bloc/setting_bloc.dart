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
    on<PilotChannelSearched>(_onPilotChannelSearched);
    on<AGCPrepAttenuationChanged>(_onAGCPrepAttenuationChanged);
    on<AGCPrepAttenuationIncreased>(_onAGCPrepAttenuationIncreased);
    on<AGCPrepAttenuationDecreased>(_onAGCPrepAttenuationDecreased);
    on<AGCPrepAttenuationCentered>(_onAGCPrepAttenuationCentered);
    on<EditModeChanged>(_onEditModeChanged);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final DsimRepository _dsimRepository;

  void _onInitialized(
    Initialized event,
    Emitter<SettingState> emit,
  ) {
    SettingData settingData = _dsimRepository.getSettingData();

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
      pilotChannel: settingData.pilotChannel,
      pilotMode: settingData.pilotMode,
      maxAttenuation: maxAttenuation,
      minAttenuation: minAttenuation,
      currentAttenuation: currentAttenuation,
      centerAttenuation: centerAttenuation,
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
      enableSubmission: _isEnableSubmission(
        location: location.value,
        tgcCableLength: _getTgcCableLength(),
        logIntervalId: state.logIntervalId,
        workingMode: _getWorkingMode(),
        pilotChannel: state.pilotChannel,
        currentAttenuation: state.centerAttenuation,
      ),
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
      enableSubmission: _isEnableSubmission(
        location: state.location.value,
        tgcCableLength: event.tgcCableLength,
        logIntervalId: state.logIntervalId,
        workingMode: _getWorkingMode(),
        pilotChannel: state.pilotChannel,
        currentAttenuation: state.centerAttenuation,
      ),
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
      enableSubmission: _isEnableSubmission(
        location: state.location.value,
        tgcCableLength: _getTgcCableLength(),
        logIntervalId: event.logIntervalId,
        workingMode: _getWorkingMode(),
        pilotChannel: state.pilotChannel,
        currentAttenuation: state.centerAttenuation,
      ),
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
      enableSubmission: _isEnableSubmission(
        location: state.location.value,
        tgcCableLength: _getTgcCableLength(),
        logIntervalId: state.logIntervalId,
        workingMode: event.workingMode,
        pilotChannel: state.pilotChannel,
        currentAttenuation: state.centerAttenuation,
      ),
    ));
  }

  void _onPilotCodeChanged(
    PilotCodeChanged event,
    Emitter<SettingState> emit,
  ) {
    // String pilotChannel = PilotChannel.channelCode.keys.firstWhere(
    //   (k) => PilotChannel.channelCode[k] == event.pilotCode,
    //   orElse: () => '',
    // );
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      pilotCode: event.pilotCode,
    ));
  }

  void _onPilotChannelSearched(
    PilotChannelSearched event,
    Emitter<SettingState> emit,
  ) {
    String pilotCode = state.pilotCode;

    if (pilotCode.isNotEmpty) {
      if (pilotCode.substring(pilotCode.length - 1) == '@') {
        pilotCode = '${pilotCode.substring(0, pilotCode.length - 1)}A';
      }
    }

    String pilotChannel = PilotChannel.channelCode.keys.firstWhere(
      (k) => PilotChannel.channelCode[k] == pilotCode,
      orElse: () => '',
    );
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      pilotChannel: pilotChannel,
      enableSubmission: _isEnableSubmission(
        location: state.location.value,
        tgcCableLength: _getTgcCableLength(),
        logIntervalId: state.logIntervalId,
        workingMode: _getWorkingMode(),
        pilotChannel: pilotChannel,
        currentAttenuation: state.centerAttenuation,
      ),
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
      enableSubmission: _isEnableSubmission(
        location: state.location.value,
        tgcCableLength: _getTgcCableLength(),
        logIntervalId: state.logIntervalId,
        workingMode: _getWorkingMode(),
        pilotChannel: state.pilotChannel,
        currentAttenuation: state.centerAttenuation,
      ),
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
      enableSubmission: _isEnableSubmission(
        location: state.location.value,
        tgcCableLength: _getTgcCableLength(),
        logIntervalId: state.logIntervalId,
        workingMode: _getWorkingMode(),
        pilotChannel: state.pilotChannel,
        currentAttenuation: state.centerAttenuation,
      ),
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
      enableSubmission: _isEnableSubmission(
        location: state.location.value,
        tgcCableLength: _getTgcCableLength(),
        logIntervalId: state.logIntervalId,
        workingMode: _getWorkingMode(),
        pilotChannel: state.pilotChannel,
        currentAttenuation: state.centerAttenuation,
      ),
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
      enableSubmission: _isEnableSubmission(
        location: state.location.value,
        tgcCableLength: _getTgcCableLength(),
        logIntervalId: state.logIntervalId,
        workingMode: _getWorkingMode(),
        pilotChannel: state.pilotChannel,
        currentAttenuation: state.centerAttenuation,
      ),
    ));
  }

  void _onEditModeChanged(
    EditModeChanged event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      editMode: !state.editMode,
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

    if (state.location.value != state.initialValues[0]) {
      bool resultOfSettingLocation =
          await _dsimRepository.setLocation(state.location.value);

      print('resultOfSettingLocation: $resultOfSettingLocation');
    }

    if (tgcCableLength != state.initialValues[1]) {
      bool resultOfSettingTGCCableLength =
          await _dsimRepository.setTGCCableLength(
        currentAttenuation: state.currentAttenuation,
        tgcCableLength: tgcCableLength,
        currentPilot: state.pilotChannel,
        logIntervalId: state.logIntervalId,
      );

      print('resultOfSettingTGCCableLength: $resultOfSettingTGCCableLength');
    }

    if (state.logIntervalId != state.initialValues[2]) {
      bool resultOfSettingLogInterval = await _dsimRepository.setLogInterval(
        logIntervalID: state.logIntervalId,
      );
    }

    if (workingMode != state.initialValues[3]) {
      bool resultOfSettingWorkingMode = await _dsimRepository.setWorkingMode(
        workingMode: workingMode,
        currentAttenuation: state.currentAttenuation,
        tgcCableLength: tgcCableLength,
        currentPilot: state.pilotChannel,
        logIntervalId: state.logIntervalId,
      );
    }

    // await Future.delayed(const Duration(seconds: 2));

    // String result = await _dsimRepository.setParameters(
    //   location: state.location.value,
    //   workingMode: workingMode,
    //   currentAttenuation: state.currentAttenuation,
    //   tgcCableLength: tgcCableLength,
    //   currentPilot: state.pilotChannel,
    //   logIntervalId: state.logIntervalId,
    // );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
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

  bool _isEnableSubmission({
    required String location,
    required String tgcCableLength,
    required int logIntervalId,
    required String workingMode,
    required String pilotChannel,
    required int currentAttenuation,
  }) {
    if (pilotChannel != '' &&
        currentAttenuation.toString() != '' &&
        (location != state.initialValues[0] ||
            tgcCableLength != state.initialValues[1] ||
            logIntervalId != state.initialValues[2] ||
            workingMode != state.initialValues[3])) {
      print('true');
      return true;
    } else {
      print('false');
      return false;
    }
  }
}

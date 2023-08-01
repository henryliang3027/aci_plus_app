import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/pilot_channel.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/setting/model/location.dart';
import 'package:dsim_app/setting/model/pilot_code.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_list_view_event.dart';
part 'setting_list_view_state.dart';

class SettingListViewBloc
    extends Bloc<SettingListViewEvent, SettingListViewState> {
  SettingListViewBloc({
    required DsimRepository dsimRepository,
    // required bool isInitialized,
  })  : _dsimRepository = dsimRepository,
        // _isInitialized = isInitialized,
        super(const SettingListViewState()) {
    on<Initialized>(_onInitialized);
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

    // add(const Initialized());
  }

  final DsimRepository _dsimRepository;
  // final bool _isInitialized;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<SettingListViewState> emit,
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

    final PilotCode pilotCode = PilotCode.dirty(settingData.pilotCode);
    final PilotCode pilot2Code = PilotCode.dirty(settingData.pilot2Code);
    final List<String>? pilot = _getPilotChannelAndMode(settingData.pilotCode);
    final List<String>? pilot2 =
        _getPilotChannelAndMode(settingData.pilot2Code);

    if (event.isLoadData) {
      print('location:  $location');
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
        pilotChannel: pilot != null ? pilot[0] : '',
        pilotMode: pilot != null ? pilot[1] : '',
        pilotCode: pilotCode,
        pilot2Channel: pilot2 != null ? pilot2[0] : '',
        pilot2Mode: pilot2 != null ? pilot2[1] : '',
        pilot2Code: pilot2Code,
        maxAttenuation: maxAttenuation,
        minAttenuation: minAttenuation,
        currentAttenuation: currentAttenuation,
        centerAttenuation: centerAttenuation,
        hasDualPilot: settingData.hasDualPilot,
        isInitialize: true,
        submissionStatus: SubmissionStatus.none,
        pilotChannelStatus: pilot != null
            ? FormStatus.requestSuccess
            : FormStatus.requestFailure,
        pilot2ChannelStatus: pilot2 != null
            ? FormStatus.requestSuccess
            : FormStatus.requestFailure,
      ));
    } else {
      emit(state.copyWith(
        initialValues: const [],
        location: const Location.pure(),
        selectedTGCCableLength: const {
          '9': false,
          '18': false,
          '27': false,
        },
        selectedWorkingMode: const {
          'MGC': false,
          'AGC': false,
          'TGC': false,
        },
        logIntervalId: 0,
        pilotChannelStatus: FormStatus.none,
        pilotChannel: '',
        pilotMode: '', // IRC or DIG
        pilotCode: const PilotCode.pure(),
        pilot2ChannelStatus: FormStatus.none,
        pilot2Channel: '',
        pilot2Mode: '', // IRC or DIG
        pilot2Code: const PilotCode.pure(),
        editable: false,
        editMode: false,
        enableSubmission: false,
      ));
    }
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<SettingListViewState> emit,
  ) {
    final Location location = Location.dirty(event.location);

    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      location: location,
      enableSubmission: _isEnabledSubmission(
        location: event.location,
        tgcCableLength: _getTgcCableLength(),
        logIntervalId: state.logIntervalId,
        workingMode: _getWorkingMode(),
      ),
    ));
  }

  void _onTGCCableLengthChanged(
    TGCCableLengthChanged event,
    Emitter<SettingListViewState> emit,
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
      enableSubmission: _isEnabledSubmission(
        location: state.location.value,
        tgcCableLength: event.tgcCableLength,
        logIntervalId: state.logIntervalId,
        workingMode: _getWorkingMode(),
      ),
    ));
  }

  void _onLogIntervalChanged(
    LogIntervalChanged event,
    Emitter<SettingListViewState> emit,
  ) {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      logIntervalId: event.logIntervalId,
      enableSubmission: _isEnabledSubmission(
        location: state.location.value,
        tgcCableLength: _getTgcCableLength(),
        logIntervalId: event.logIntervalId,
        workingMode: _getWorkingMode(),
      ),
    ));
  }

  void _onWorkingModeChanged(
    WorkingModeChanged event,
    Emitter<SettingListViewState> emit,
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
      enableSubmission: _isEnabledSubmission(
        location: state.location.value,
        tgcCableLength: _getTgcCableLength(),
        logIntervalId: state.logIntervalId,
        workingMode: event.workingMode,
      ),
    ));
  }

  List<String>? _getPilotChannelAndMode(String pilotCode) {
    if (pilotCode.isEmpty) {
      return null;
    } else {
      if (pilotCode.substring(pilotCode.length - 1) != '@' &&
          pilotCode.substring(pilotCode.length - 1) != 'A') {
        // 如果最後一個字不是 A 也不是 @, return null
        return null;
      } else {
        String pilotMode = '';
        String adjustedPilotCode = pilotCode;
        if (pilotCode.substring(pilotCode.length - 1) == '@') {
          pilotMode = 'IRC';
        } else {
          pilotMode = 'DIG';
        }

        // 把最後一個字替換成 A 並查表
        if (adjustedPilotCode.substring(adjustedPilotCode.length - 1) == '@') {
          adjustedPilotCode =
              '${adjustedPilotCode.substring(0, adjustedPilotCode.length - 1)}A';
        }

        String pilotChannel = PilotChannel.channelCode.keys.firstWhere(
          (k) => PilotChannel.channelCode[k] == adjustedPilotCode,
          orElse: () => '',
        );

        if (pilotChannel == '') {
          return null;
        } else {
          return [
            pilotChannel,
            pilotMode,
          ];
        }
      }
    }
  }

  void _onPilotCodeChanged(
    PilotCodeChanged event,
    Emitter<SettingListViewState> emit,
  ) {
    final PilotCode pilotCode = PilotCode.dirty(event.pilotCode);

    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      pilotChannelStatus: FormStatus.none,
      pilot2ChannelStatus: FormStatus.none,
      pilotCode: pilotCode,
    ));
  }

  Future<void> _onPilotChannelSearched(
    PilotChannelSearched event,
    Emitter<SettingListViewState> emit,
  ) async {
    emit(state.copyWith(
        isInitialize: false,
        pilotChannelStatus: FormStatus.requestInProgress,
        pilot2ChannelStatus: FormStatus.none));

    List<String>? pilot = _getPilotChannelAndMode(state.pilotCode.value);

    if (pilot == null) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        pilotChannelStatus: FormStatus.requestFailure,
        pilotChannel: 'N/A',
        pilotMode: '',
        enableSubmission: false,
      ));
    } else {
      String pilotChannel = pilot[0];
      String pilotMode = pilot[1];
      await _dsimRepository.writePilotCode(state.pilotCode.value);

      bool enableSubmission = state.pilotCode.value.isNotEmpty &&
          state.pilot2Code.value.isNotEmpty &&
          state.pilotChannel.isNotEmpty &&
          state.pilot2Channel.isNotEmpty;

      emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        pilotChannel: pilotChannel,
        pilotMode: pilotMode,
        pilotChannelStatus: FormStatus.requestSuccess,
        enableSubmission: enableSubmission,
      ));
    }
  }

  void _onPilot2CodeChanged(
    Pilot2CodeChanged event,
    Emitter<SettingListViewState> emit,
  ) {
    final PilotCode pilot2Code = PilotCode.dirty(event.pilot2Code);

    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      pilotChannelStatus: FormStatus.none,
      pilot2ChannelStatus: FormStatus.none,
      pilot2Code: pilot2Code,
    ));
  }

  Future<void> _onPilot2ChannelSearched(
    Pilot2ChannelSearched event,
    Emitter<SettingListViewState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      pilot2ChannelStatus: FormStatus.requestInProgress,
      pilotChannelStatus: FormStatus.none,
    ));

    List<String>? pilot = _getPilotChannelAndMode(state.pilot2Code.value);

    if (pilot == null) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        pilot2ChannelStatus: FormStatus.requestFailure,
        pilot2Channel: 'N/A',
        pilot2Mode: '',
        enableSubmission: false,
      ));
    } else {
      String pilot2Channel = pilot[0];
      String pilot2Mode = pilot[1];
      await _dsimRepository.writePilot2Code(state.pilot2Code.value);

      bool enableSubmission = state.pilotCode.value.isNotEmpty &&
          state.pilot2Code.value.isNotEmpty &&
          state.pilotChannel.isNotEmpty &&
          state.pilot2Channel.isNotEmpty;

      emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        pilot2Channel: pilot2Channel,
        pilot2Mode: pilot2Mode,
        pilot2ChannelStatus: FormStatus.requestSuccess,
        enableSubmission: enableSubmission,
      ));
    }
  }

  void _onAGCPrepAttenuationChanged(
    AGCPrepAttenuationChanged event,
    Emitter<SettingListViewState> emit,
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
    Emitter<SettingListViewState> emit,
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
    Emitter<SettingListViewState> emit,
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
    Emitter<SettingListViewState> emit,
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
    Emitter<SettingListViewState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<SettingListViewState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: false,
      enableSubmission: false,
    ));
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<SettingListViewState> emit,
  ) async {
    // initialValues: [
    //   settingData.location,
    //   settingData.tgcCableLength,
    //   settingData.logIntervalId,
    //   settingData.workingMode,
    //   settingData.currentAttenuation,
    // ],

    List<dynamic> initialValues = [];
    initialValues.addAll(state.initialValues);

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

      if (resultOfSettingLocation) {
        initialValues[0] = state.location.value;
      }
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

      if (resultOfSettingTGCCableLength) {
        initialValues[1] = tgcCableLength;
      }
    }

    if (state.logIntervalId != state.initialValues[2]) {
      bool resultOfSettingLogInterval = await _dsimRepository.setLogInterval(
        logIntervalId: state.logIntervalId,
      );

      settingResult
          .add('${DataKey.logInterval.name},$resultOfSettingLogInterval');

      if (resultOfSettingLogInterval) {
        initialValues[2] = state.logIntervalId;
      }
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

      settingResult
          .add('${DataKey.workingMode.name},$resultOfSettingWorkingMode');

      if (resultOfSettingWorkingMode) {
        initialValues[3] = workingMode;
        initialValues[4] = workingMode;
      }
    }

    emit(state.copyWith(
      isInitialize: false,
      initialValues: initialValues,
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      editMode: false,
    ));
  }

  String _getWorkingMode() {
    return state.selectedWorkingMode.keys.firstWhere(
      (k) => state.selectedWorkingMode[k] == true,
      orElse: () => '',
    );
  }

  String _getTgcCableLength() {
    return state.selectedTGCCableLength.keys.firstWhere(
        (k) => state.selectedTGCCableLength[k] == true,
        orElse: () => '');
  }

  bool _isEnabledSubmission({
    required String location,
    required String tgcCableLength,
    required int logIntervalId,
    required String workingMode,
  }) {
    if (location != state.initialValues[0] ||
        tgcCableLength != state.initialValues[1] ||
        logIntervalId != state.initialValues[2] ||
        (workingMode != state.initialValues[3] &&
            state.pilotCode.isValid &&
            state.pilot2Code.isValid &&
            state.pilotChannelStatus == FormStatus.requestSuccess &&
            state.pilot2ChannelStatus == FormStatus.requestSuccess)) {
      print('true');
      return true;
    } else {
      print('false');
      return false;
    }
  }
}

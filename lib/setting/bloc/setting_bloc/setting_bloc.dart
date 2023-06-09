import 'package:dsim_app/core/pilot_channel.dart';
import 'package:dsim_app/setting/model/location.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(const SettingState()) {
    on<AllItemInitialized>(_onAllItemInitialized);
    on<GraphViewToggled>(_onGraphViewToggled);
    on<ListViewToggled>(_onListViewToggled);
    on<LocationChanged>(_onLocationChanged);
    on<LocationSubmitted>(_onLocationSubmitted);
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
  }

  void _onAllItemInitialized(
    AllItemInitialized event,
    Emitter<SettingState> emit,
  ) {
    final Location location = Location.dirty(event.location);

    final Map<String, bool> newSelectedTGCCableLength = {
      '9': false,
      '18': false,
      '27': false,
    };

    if (newSelectedTGCCableLength.containsKey(event.tgcCableLength)) {
      newSelectedTGCCableLength[event.tgcCableLength] = true;
    }

    final Map<String, bool> newSelectedWorkingMode = {
      'MGC': false,
      'AGC': false,
      'TGC': false,
    };

    if (newSelectedWorkingMode.containsKey(event.workingMode)) {
      newSelectedWorkingMode[event.workingMode] = true;
    }

    final int maxAttenuation = event.maxAttenuation.isNotEmpty
        ? int.parse(event.maxAttenuation)
        : 3000;
    final int minAttenuation =
        event.minAttenuation.isNotEmpty ? int.parse(event.minAttenuation) : 0;
    final int currentAttenuation = event.currentAttenuation.isNotEmpty
        ? int.parse(event.currentAttenuation)
        : 0;
    final int centerAttenuation = event.centerAttenuation.isNotEmpty
        ? int.parse(event.centerAttenuation)
        : 0;

    emit(state.copyWith(
      initialValues: [
        event.location,
        event.tgcCableLength,
        event.logIntervalId,
        event.workingMode,
        event.currentAttenuation,
      ],
      location: location,
      selectedTGCCableLength: newSelectedTGCCableLength,
      selectedWorkingMode: newSelectedWorkingMode,
      logIntervalId: event.logIntervalId,
      pilotChannel: event.pilotChannel,
      pilotMode: event.pilotMode,
      maxAttenuation: maxAttenuation,
      minAttenuation: minAttenuation,
      currentAttenuation: currentAttenuation,
      centerAttenuation: centerAttenuation,
    ));
  }

  void _onGraphViewToggled(
    GraphViewToggled event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isGraphType: true,
    ));
  }

  void _onListViewToggled(
    ListViewToggled event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isGraphType: false,
    ));
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<SettingState> emit,
  ) {
    final Location location = Location.dirty(event.location);

    emit(state.copyWith(
      location: location,
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
      selectedTGCCableLength: newSelectedTGCCableLength,
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
      selectedWorkingMode: newSelectedWorkingMode,
    ));
  }

  void _onLogIntervalChanged(
    LogIntervalChanged event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      logIntervalId: event.logIntervalId,
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
      pilotChannel: pilotChannel,
    ));
  }

  void _onAGCPrepAttenuationChanged(
    AGCPrepAttenuationChanged event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      currentAttenuation: event.attenuation,
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
      currentAttenuation: newAttenuation,
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
      currentAttenuation: newAttenuation,
    ));
  }

  void _onAGCPrepAttenuationCentered(
    AGCPrepAttenuationCentered event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      currentAttenuation: state.centerAttenuation,
    ));
  }

  void _onEditModeChanged(
    EditModeChanged event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      editMode: !state.editMode,
    ));
  }

  void _onLocationSubmitted(
    LocationSubmitted event,
    Emitter<SettingState> emit,
  ) {
    // 如果目前的 location 與初始的 location 不同, 代表要進行 location 設定
    if (state.location != state.initialValues[0]) {}
  }
}

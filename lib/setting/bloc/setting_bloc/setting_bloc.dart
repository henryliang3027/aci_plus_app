import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/pilot_channel.dart';
import 'package:dsim_app/setting/model/location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
  }

  void _onAllItemInitialized(
    AllItemInitialized event,
    Emitter<SettingState> emit,
  ) {
    final Location location = Location.dirty(event.location);

    Map<String, bool> newSelectedTGCCableLength = {
      '9': false,
      '18': false,
      '27': false,
    };

    newSelectedTGCCableLength[event.tgcCableLength] = true;

    Map<String, bool> newSelectedWorkingMode = {
      'MGC': false,
      'AGC': false,
      'TGC': false,
    };

    newSelectedWorkingMode[event.workingMode] = true;

    emit(state.copyWith(
      location: location,
      selectedTGCCableLength: newSelectedTGCCableLength,
      selectedWorkingMode: newSelectedWorkingMode,
      logIntervalId: event.logIntervalId,
      pilotChannel: event.pilotChannel,
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

  void _onLocationSubmitted(
    LocationSubmitted event,
    Emitter<SettingState> emit,
  ) {}
}

part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();
  @override
  List<Object> get props => [];
}

class AllItemInitialized extends SettingEvent {
  const AllItemInitialized(
    this.location,
    this.tgcCableLength,
    this.workingMode,
    this.logIntervalId,
    this.pilotChannel,
  );

  final String location;

  final String tgcCableLength;
  final String workingMode;
  final int logIntervalId;
  final String pilotChannel;

  @override
  List<Object> get props => [
        location,
        tgcCableLength,
        workingMode,
        logIntervalId,
        pilotChannel,
      ];
}

class GraphViewToggled extends SettingEvent {
  const GraphViewToggled();

  @override
  List<Object> get props => [];
}

class ListViewToggled extends SettingEvent {
  const ListViewToggled();

  @override
  List<Object> get props => [];
}

class LocationChanged extends SettingEvent {
  const LocationChanged(
    this.location,
  );

  final String location;

  @override
  List<Object> get props => [
        location,
      ];
}

class TGCCableLengthChanged extends SettingEvent {
  const TGCCableLengthChanged(
    this.tgcCableLength,
  );

  final String tgcCableLength;

  @override
  List<Object> get props => [
        tgcCableLength,
      ];
}

class WorkingModeChanged extends SettingEvent {
  const WorkingModeChanged(
    this.workingMode,
  );

  final String workingMode;

  @override
  List<Object> get props => [
        workingMode,
      ];
}

class LogIntervalChanged extends SettingEvent {
  const LogIntervalChanged(
    this.logIntervalId,
  );

  final int logIntervalId;

  @override
  List<Object> get props => [
        logIntervalId,
      ];
}

class PilotCodeChanged extends SettingEvent {
  const PilotCodeChanged(
    this.pilotCode,
  );

  final String pilotCode;

  @override
  List<Object> get props => [
        pilotCode,
      ];
}

class PilotChannelSearched extends SettingEvent {
  const PilotChannelSearched();

  @override
  List<Object> get props => [];
}

class LocationSubmitted extends SettingEvent {
  const LocationSubmitted();

  @override
  List<Object> get props => [];
}

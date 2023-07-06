part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();
  @override
  List<Object> get props => [];
}

class Initialized extends SettingEvent {
  const Initialized();

  @override
  List<Object> get props => [];
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

class Pilot2CodeChanged extends SettingEvent {
  const Pilot2CodeChanged(
    this.pilot2Code,
  );

  final String pilot2Code;

  @override
  List<Object> get props => [
        pilot2Code,
      ];
}

class Pilot2ChannelSearched extends SettingEvent {
  const Pilot2ChannelSearched();

  @override
  List<Object> get props => [];
}

class AGCPrepAttenuationChanged extends SettingEvent {
  const AGCPrepAttenuationChanged(this.attenuation);

  final int attenuation;

  @override
  List<Object> get props => [
        attenuation,
      ];
}

class AGCPrepAttenuationIncreased extends SettingEvent {
  const AGCPrepAttenuationIncreased();

  @override
  List<Object> get props => [];
}

class AGCPrepAttenuationDecreased extends SettingEvent {
  const AGCPrepAttenuationDecreased();

  @override
  List<Object> get props => [];
}

class AGCPrepAttenuationCentered extends SettingEvent {
  const AGCPrepAttenuationCentered();

  @override
  List<Object> get props => [];
}

class EditModeEnabled extends SettingEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends SettingEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends SettingEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

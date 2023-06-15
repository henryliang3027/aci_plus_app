part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();
  @override
  List<Object> get props => [];
}

class AllItemInitialized extends SettingEvent {
  const AllItemInitialized({
    required this.location,
    required this.tgcCableLength,
    required this.workingMode,
    required this.logIntervalId,
    required this.pilotChannel,
    required this.pilotMode,
    required this.maxAttenuation,
    required this.minAttenuation,
    required this.currentAttenuation,
    required this.centerAttenuation,
  });

  final String location;
  final String tgcCableLength;
  final String workingMode;
  final int logIntervalId;
  final String pilotChannel;
  final String pilotMode;
  final String maxAttenuation;
  final String minAttenuation;
  final String currentAttenuation;
  final String centerAttenuation;

  @override
  List<Object> get props => [
        location,
        tgcCableLength,
        workingMode,
        logIntervalId,
        pilotChannel,
        pilotMode,
        maxAttenuation,
        minAttenuation,
        currentAttenuation,
        centerAttenuation,
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

class EditModeChanged extends SettingEvent {
  const EditModeChanged();

  @override
  List<Object> get props => [];
}

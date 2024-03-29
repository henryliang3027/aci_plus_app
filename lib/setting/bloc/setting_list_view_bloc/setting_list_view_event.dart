part of 'setting_list_view_bloc.dart';

abstract class SettingListViewEvent extends Equatable {
  const SettingListViewEvent();
  @override
  List<Object> get props => [];
}

class Initialized extends SettingListViewEvent {
  const Initialized({
    required this.location,
    required this.tgcCableLength,
    required this.workingMode,
    required this.logIntervalId,
    required this.maxAttenuation,
    required this.minAttenuation,
    required this.currentAttenuation,
    required this.centerAttenuation,
    required this.hasDualPilot,
  });

  final String location;
  final String tgcCableLength;
  final String workingMode;
  final String logIntervalId;
  final String maxAttenuation;
  final String minAttenuation;
  final String currentAttenuation;
  final String centerAttenuation;
  final String hasDualPilot;

  @override
  List<Object> get props => [
        location,
        tgcCableLength,
        workingMode,
        logIntervalId,
        maxAttenuation,
        minAttenuation,
        currentAttenuation,
        centerAttenuation,
        hasDualPilot,
      ];
}

class LocationChanged extends SettingListViewEvent {
  const LocationChanged(
    this.location,
  );

  final String location;

  @override
  List<Object> get props => [
        location,
      ];
}

class TGCCableLengthChanged extends SettingListViewEvent {
  const TGCCableLengthChanged(
    this.tgcCableLength,
  );

  final String tgcCableLength;

  @override
  List<Object> get props => [
        tgcCableLength,
      ];
}

class WorkingModeChanged extends SettingListViewEvent {
  const WorkingModeChanged(
    this.workingMode,
  );

  final String workingMode;

  @override
  List<Object> get props => [
        workingMode,
      ];
}

class LogIntervalChanged extends SettingListViewEvent {
  const LogIntervalChanged(
    this.logIntervalId,
  );

  final String logIntervalId;

  @override
  List<Object> get props => [
        logIntervalId,
      ];
}

class PilotCodeChanged extends SettingListViewEvent {
  const PilotCodeChanged(
    this.pilotCode,
  );

  final String pilotCode;

  @override
  List<Object> get props => [
        pilotCode,
      ];
}

class PilotChannelSearched extends SettingListViewEvent {
  const PilotChannelSearched();

  @override
  List<Object> get props => [];
}

class Pilot2CodeChanged extends SettingListViewEvent {
  const Pilot2CodeChanged(
    this.pilot2Code,
  );

  final String pilot2Code;

  @override
  List<Object> get props => [
        pilot2Code,
      ];
}

class Pilot2ChannelSearched extends SettingListViewEvent {
  const Pilot2ChannelSearched();

  @override
  List<Object> get props => [];
}

class AGCPrepAttenuationChanged extends SettingListViewEvent {
  const AGCPrepAttenuationChanged(this.attenuation);

  final int attenuation;

  @override
  List<Object> get props => [
        attenuation,
      ];
}

class AGCPrepAttenuationChangeEnded extends SettingListViewEvent {
  const AGCPrepAttenuationChangeEnded();

  @override
  List<Object> get props => [];
}

class AGCPrepAttenuationIncreased extends SettingListViewEvent {
  const AGCPrepAttenuationIncreased();

  @override
  List<Object> get props => [];
}

class AGCPrepAttenuationDecreased extends SettingListViewEvent {
  const AGCPrepAttenuationDecreased();

  @override
  List<Object> get props => [];
}

class AGCPrepAttenuationCentered extends SettingListViewEvent {
  const AGCPrepAttenuationCentered();

  @override
  List<Object> get props => [];
}

class EditModeEnabled extends SettingListViewEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends SettingListViewEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends SettingListViewEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

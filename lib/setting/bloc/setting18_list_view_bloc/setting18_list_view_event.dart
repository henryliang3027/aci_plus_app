part of 'setting18_list_view_bloc.dart';

abstract class Setting18ListViewEvent extends Equatable {
  const Setting18ListViewEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18ListViewEvent {
  const Initialized(this.isLoadData);

  final bool isLoadData;

  @override
  List<Object> get props => [isLoadData];
}

class SplitOptionChanged extends Setting18ListViewEvent {
  const SplitOptionChanged(this.splitOption);

  final String splitOption;

  @override
  List<Object> get props => [splitOption];
}

class FirstChannelLoadingFrequencyChanged extends Setting18ListViewEvent {
  const FirstChannelLoadingFrequencyChanged(this.firstChannelLoadingFrequency);

  final String firstChannelLoadingFrequency;

  @override
  List<Object> get props => [firstChannelLoadingFrequency];
}

class FirstChannelLoadingLevelChanged extends Setting18ListViewEvent {
  const FirstChannelLoadingLevelChanged(this.firstChannelLoadingLevel);

  final String firstChannelLoadingLevel;

  @override
  List<Object> get props => [firstChannelLoadingLevel];
}

class LastChannelLoadingFrequencyChanged extends Setting18ListViewEvent {
  const LastChannelLoadingFrequencyChanged(this.lastChannelLoadingFrequency);

  final String lastChannelLoadingFrequency;

  @override
  List<Object> get props => [lastChannelLoadingFrequency];
}

class LastChannelLoadingLevelChanged extends Setting18ListViewEvent {
  const LastChannelLoadingLevelChanged(this.lastChannelLoadingLevel);

  final String lastChannelLoadingLevel;

  @override
  List<Object> get props => [lastChannelLoadingLevel];
}

class PilotFrequencyModeChanged extends Setting18ListViewEvent {
  const PilotFrequencyModeChanged(this.pilotFrequencyMode);

  final String pilotFrequencyMode;

  @override
  List<Object> get props => [pilotFrequencyMode];
}

class PilotFrequency1Changed extends Setting18ListViewEvent {
  const PilotFrequency1Changed(this.pilotFrequency1);

  final String pilotFrequency1;

  @override
  List<Object> get props => [pilotFrequency1];
}

class PilotFrequency2Changed extends Setting18ListViewEvent {
  const PilotFrequency2Changed(this.pilotFrequency2);

  final String pilotFrequency2;

  @override
  List<Object> get props => [pilotFrequency2];
}

class FwdAGCModeChanged extends Setting18ListViewEvent {
  const FwdAGCModeChanged(this.fwdAGCMode);

  final String fwdAGCMode;

  @override
  List<Object> get props => [fwdAGCMode];
}

class AutoLevelControlChanged extends Setting18ListViewEvent {
  const AutoLevelControlChanged(this.autoLevelControl);

  final String autoLevelControl;

  @override
  List<Object> get props => [autoLevelControl];
}

class EditModeEnabled extends Setting18ListViewEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18ListViewEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18ListViewEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

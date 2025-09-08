part of 'setting18_graph_module_bloc.dart';

abstract class Setting18GraphModuleEvent extends Equatable {
  const Setting18GraphModuleEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18GraphModuleEvent {
  const Initialized({this.useCache = true});

  final bool useCache;

  @override
  List<Object> get props => [useCache];
}

class ControlItemChanged extends Setting18GraphModuleEvent {
  const ControlItemChanged({
    required this.dataKey,
    required this.value,
  });

  final DataKey dataKey;
  final String value;
}

class FirstChannelLoadingFrequencyChanged extends Setting18GraphModuleEvent {
  const FirstChannelLoadingFrequencyChanged({
    required this.firstChannelLoadingFrequency,
    required this.currentDetectedSplitOption,
  });

  final String firstChannelLoadingFrequency;
  final String currentDetectedSplitOption;

  @override
  List<Object> get props => [
        firstChannelLoadingFrequency,
        currentDetectedSplitOption,
      ];
}

class FirstChannelLoadingLevelChanged extends Setting18GraphModuleEvent {
  const FirstChannelLoadingLevelChanged(
      {required this.firstChannelLoadingLevel});

  final String firstChannelLoadingLevel;

  @override
  List<Object> get props => [firstChannelLoadingLevel];
}

class LastChannelLoadingFrequencyChanged extends Setting18GraphModuleEvent {
  const LastChannelLoadingFrequencyChanged(
      {required this.lastChannelLoadingFrequency});

  final String lastChannelLoadingFrequency;

  @override
  List<Object> get props => [lastChannelLoadingFrequency];
}

class LastChannelLoadingLevelChanged extends Setting18GraphModuleEvent {
  const LastChannelLoadingLevelChanged({required this.lastChannelLoadingLevel});

  final String lastChannelLoadingLevel;

  @override
  List<Object> get props => [lastChannelLoadingLevel];
}

class PilotFrequencyModeChanged extends Setting18GraphModuleEvent {
  const PilotFrequencyModeChanged({required this.pilotFrequencyMode});

  final String pilotFrequencyMode;

  @override
  List<Object> get props => [pilotFrequencyMode];
}

class PilotFrequency1Changed extends Setting18GraphModuleEvent {
  const PilotFrequency1Changed({required this.pilotFrequency1});

  final String pilotFrequency1;

  @override
  List<Object> get props => [pilotFrequency1];
}

class PilotFrequency2Changed extends Setting18GraphModuleEvent {
  const PilotFrequency2Changed({required this.pilotFrequency2});

  final String pilotFrequency2;

  @override
  List<Object> get props => [pilotFrequency2];
}

class AGCModeChanged extends Setting18GraphModuleEvent {
  const AGCModeChanged(this.agcMode);

  final String agcMode;

  @override
  List<Object> get props => [agcMode];
}

class ALCModeChanged extends Setting18GraphModuleEvent {
  const ALCModeChanged(this.alcMode);

  final String alcMode;

  @override
  List<Object> get props => [alcMode];
}

class SettingSubmitted extends Setting18GraphModuleEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

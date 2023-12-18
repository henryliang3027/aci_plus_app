part of 'setting18_config_edit_bloc.dart';

sealed class Setting18ConfigEditEvent extends Equatable {
  const Setting18ConfigEditEvent();

  @override
  List<Object> get props => [];
}

class ConfigIntitialized extends Setting18ConfigEditEvent {
  const ConfigIntitialized({
    required this.partId,
  });

  final String partId;

  @override
  List<Object> get props => [partId];
}

class ConfigSaved extends Setting18ConfigEditEvent {
  const ConfigSaved();

  @override
  List<Object> get props => [];
}

class ConfigSavedAndSubmitted extends Setting18ConfigEditEvent {
  const ConfigSavedAndSubmitted();

  @override
  List<Object> get props => [];
}

class FirstChannelLoadingFrequencyChanged extends Setting18ConfigEditEvent {
  const FirstChannelLoadingFrequencyChanged(this.firstChannelLoadingFrequency);

  final String firstChannelLoadingFrequency;

  @override
  List<Object> get props => [firstChannelLoadingFrequency];
}

class FirstChannelLoadingLevelChanged extends Setting18ConfigEditEvent {
  const FirstChannelLoadingLevelChanged(this.firstChannelLoadingLevel);

  final String firstChannelLoadingLevel;

  @override
  List<Object> get props => [firstChannelLoadingLevel];
}

class LastChannelLoadingFrequencyChanged extends Setting18ConfigEditEvent {
  const LastChannelLoadingFrequencyChanged(this.lastChannelLoadingFrequency);

  final String lastChannelLoadingFrequency;

  @override
  List<Object> get props => [lastChannelLoadingFrequency];
}

class LastChannelLoadingLevelChanged extends Setting18ConfigEditEvent {
  const LastChannelLoadingLevelChanged(this.lastChannelLoadingLevel);

  final String lastChannelLoadingLevel;

  @override
  List<Object> get props => [lastChannelLoadingLevel];
}

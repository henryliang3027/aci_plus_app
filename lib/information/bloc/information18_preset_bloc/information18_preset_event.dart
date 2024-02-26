part of 'information18_preset_bloc.dart';

abstract class Information18PresetEvent extends Equatable {
  const Information18PresetEvent();

  @override
  List<Object> get props => [];
}

class DefaultConfigRequested extends Information18PresetEvent {
  const DefaultConfigRequested();

  @override
  List<Object> get props => [];
}

class ConfigExecuted extends Information18PresetEvent {
  const ConfigExecuted();

  @override
  List<Object> get props => [];
}

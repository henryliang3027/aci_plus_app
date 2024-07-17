part of 'information18_ccor_node_preset_bloc.dart';

sealed class Information18CCorNodePresetEvent extends Equatable {
  const Information18CCorNodePresetEvent();

  @override
  List<Object> get props => [];
}

class DefaultConfigRequested extends Information18CCorNodePresetEvent {
  const DefaultConfigRequested();

  @override
  List<Object> get props => [];
}

class ConfigExecuted extends Information18CCorNodePresetEvent {
  const ConfigExecuted();

  @override
  List<Object> get props => [];
}

part of 'setting18_ccor_node_config_edit_bloc.dart';

sealed class Setting18CcorNodeConfigEditEvent extends Equatable {
  const Setting18CcorNodeConfigEditEvent();

  @override
  List<Object> get props => [];
}

class ConfigIntitialized extends Setting18CcorNodeConfigEditEvent {
  const ConfigIntitialized();

  @override
  List<Object> get props => [];
}

class ConfigAdded extends Setting18CcorNodeConfigEditEvent {
  const ConfigAdded();

  @override
  List<Object> get props => [];
}

class ConfigUpdated extends Setting18CcorNodeConfigEditEvent {
  const ConfigUpdated();

  @override
  List<Object> get props => [];
}

class ConfigSubmitted extends Setting18CcorNodeConfigEditEvent {
  const ConfigSubmitted();

  @override
  List<Object> get props => [];
}

class NameChanged extends Setting18CcorNodeConfigEditEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class ForwardModeChanged extends Setting18CcorNodeConfigEditEvent {
  const ForwardModeChanged(this.forwardMode);

  final String forwardMode;

  @override
  List<Object> get props => [forwardMode];
}

class ForwardConfigChanged extends Setting18CcorNodeConfigEditEvent {
  const ForwardConfigChanged(this.forwardConfig);

  final String forwardConfig;

  @override
  List<Object> get props => [forwardConfig];
}

class SplitOptionChanged extends Setting18CcorNodeConfigEditEvent {
  const SplitOptionChanged(this.splitOption);

  final String splitOption;

  @override
  List<Object> get props => [splitOption];
}

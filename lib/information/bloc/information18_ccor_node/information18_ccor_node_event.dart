part of 'information18_ccor_node_bloc.dart';

abstract class Information18CCorNodeEvent extends Equatable {
  const Information18CCorNodeEvent();

  @override
  List<Object> get props => [];
}

class AppVersionRequested extends Information18CCorNodeEvent {
  const AppVersionRequested();

  @override
  List<Object> get props => [];
}

class ConfigLoaded extends Information18CCorNodeEvent {
  const ConfigLoaded();

  @override
  List<Object> get props => [];
}

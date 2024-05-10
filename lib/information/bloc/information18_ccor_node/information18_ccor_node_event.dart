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

class AlarmUpdated extends Information18CCorNodeEvent {
  const AlarmUpdated();

  @override
  List<Object> get props => [];
}

class AlarmPeriodicUpdateRequested extends Information18CCorNodeEvent {
  const AlarmPeriodicUpdateRequested();

  @override
  List<Object> get props => [];
}

class AlarmPeriodicUpdateCanceled extends Information18CCorNodeEvent {
  const AlarmPeriodicUpdateCanceled();

  @override
  List<Object> get props => [];
}

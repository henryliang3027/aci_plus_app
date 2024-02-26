part of 'information18_bloc.dart';

abstract class Information18Event extends Equatable {
  const Information18Event();

  @override
  List<Object> get props => [];
}

class ConfigLoaded extends Information18Event {
  const ConfigLoaded(this.partId);

  final String partId;

  @override
  List<Object> get props => [partId];
}

class AlarmUpdated extends Information18Event {
  const AlarmUpdated();

  @override
  List<Object> get props => [];
}

class AlarmPeriodicUpdateRequested extends Information18Event {
  const AlarmPeriodicUpdateRequested();

  @override
  List<Object> get props => [];
}

class AlarmPeriodicUpdateCanceled extends Information18Event {
  const AlarmPeriodicUpdateCanceled();

  @override
  List<Object> get props => [];
}

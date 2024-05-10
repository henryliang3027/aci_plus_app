part of 'information_bloc.dart';

abstract class InformationEvent extends Equatable {
  const InformationEvent();
  @override
  List<Object> get props => [];
}

class AppVersionRequested extends InformationEvent {
  const AppVersionRequested();

  @override
  List<Object> get props => [];
}

class AlarmUpdated extends InformationEvent {
  const AlarmUpdated();

  @override
  List<Object> get props => [];
}

class AlarmPeriodicUpdateRequested extends InformationEvent {
  const AlarmPeriodicUpdateRequested();

  @override
  List<Object> get props => [];
}

class AlarmPeriodicUpdateCanceled extends InformationEvent {
  const AlarmPeriodicUpdateCanceled();

  @override
  List<Object> get props => [];
}

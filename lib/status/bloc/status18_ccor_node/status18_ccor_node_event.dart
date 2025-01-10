part of 'status18_ccor_node_bloc.dart';

abstract class Status18CCorNodeEvent extends Equatable {
  const Status18CCorNodeEvent();

  @override
  List<Object> get props => [];
}

class TemperatureUnitChanged extends Status18CCorNodeEvent {
  const TemperatureUnitChanged(this.temperatureUnit);

  final TemperatureUnit temperatureUnit;

  @override
  List<Object> get props => [temperatureUnit];
}

// class StatusUpdated extends Status18CCorNodeEvent {
//   const StatusUpdated();

//   @override
//   List<Object> get props => [];
// }

// class StatusPeriodicUpdateRequested extends Status18CCorNodeEvent {
//   const StatusPeriodicUpdateRequested();

//   @override
//   List<Object> get props => [];
// }

// class StatusPeriodicUpdateCanceled extends Status18CCorNodeEvent {
//   const StatusPeriodicUpdateCanceled();

//   @override
//   List<Object> get props => [];
// }

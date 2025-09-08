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

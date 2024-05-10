part of 'status_bloc.dart';

abstract class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object> get props => [];
}

class TemperatureUnitChanged extends StatusEvent {
  const TemperatureUnitChanged(this.temperatureUnit);

  final TemperatureUnit temperatureUnit;

  @override
  List<Object> get props => [temperatureUnit];
}

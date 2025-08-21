part of 'status18_bloc.dart';

abstract class Status18Event extends Equatable {
  const Status18Event();

  @override
  List<Object> get props => [];
}

class TemperatureUnitChanged extends Status18Event {
  const TemperatureUnitChanged(this.temperatureUnit);

  final TemperatureUnit temperatureUnit;

  @override
  List<Object> get props => [temperatureUnit];
}

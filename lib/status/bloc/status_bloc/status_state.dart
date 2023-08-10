part of 'status_bloc.dart';

class StatusState extends Equatable {
  const StatusState({
    this.temperatureUnit = TemperatureUnit.fahrenheit,
  });

  final TemperatureUnit temperatureUnit;

  StatusState copyWith({
    TemperatureUnit? temperatureUnit,
  }) {
    return StatusState(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
    );
  }

  @override
  List<Object?> get props => [
        temperatureUnit,
      ];
}

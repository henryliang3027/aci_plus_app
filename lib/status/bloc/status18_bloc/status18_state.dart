part of 'status18_bloc.dart';

class Status18State extends Equatable {
  const Status18State({this.temperatureUnit = TemperatureUnit.fahrenheit});

  final TemperatureUnit temperatureUnit;

  Status18State copyWith({
    TemperatureUnit? temperatureUnit,
  }) {
    return Status18State(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
    );
  }

  @override
  List<Object> get props => [
        temperatureUnit,
      ];
}

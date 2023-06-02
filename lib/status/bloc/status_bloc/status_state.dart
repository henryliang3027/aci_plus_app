part of 'status_bloc.dart';

enum TemperatureUnit {
  fahrenheit,
  celsius,
}

class StatusState extends Equatable {
  const StatusState({
    this.temperatureUnit = TemperatureUnit.fahrenheit,
    // this.currentTemperature = '',
    // this.maxTemperature = '',
    // this.minTemperature = '',
  });

  final TemperatureUnit temperatureUnit;
  // final String currentTemperature;
  // final String maxTemperature;
  // final String minTemperature;

  StatusState copyWith({
    TemperatureUnit? temperatureUnit,
    // String? currentTemperature,
    // String? maxTemperature,
    // String? minTemperature,
  }) {
    return StatusState(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      // currentTemperature: currentTemperature ?? this.currentTemperature,
      // maxTemperature: maxTemperature ?? this.maxTemperature,
      // minTemperature: minTemperature ?? this.minTemperature,
    );
  }

  @override
  List<Object?> get props => [
        temperatureUnit,
        // currentTemperature,
        // maxTemperature,
        // minTemperature,
      ];
}

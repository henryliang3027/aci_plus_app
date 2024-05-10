part of 'status18_ccor_node_bloc.dart';

class Status18CCorNodeState extends Equatable {
  const Status18CCorNodeState({required this.temperatureUnit});

  final TemperatureUnit temperatureUnit;

  Status18CCorNodeState copyWith({
    TemperatureUnit? temperatureUnit,
  }) {
    return Status18CCorNodeState(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
    );
  }

  @override
  List<Object> get props => [
        temperatureUnit,
      ];
}

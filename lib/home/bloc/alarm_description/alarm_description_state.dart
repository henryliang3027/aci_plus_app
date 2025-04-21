part of 'alarm_description_bloc.dart';

class AlarmDescriptionState extends Equatable {
  const AlarmDescriptionState({
    this.temperatureUnit = TemperatureUnit.fahrenheit,
    this.severityIndexValueList = const <SeverityIndex>[],
  });

  final TemperatureUnit temperatureUnit;
  final List<SeverityIndex> severityIndexValueList;

  AlarmDescriptionState copyWith({
    TemperatureUnit? temperatureUnit,
    List<SeverityIndex>? severityIndexValueList,
  }) {
    return AlarmDescriptionState(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      severityIndexValueList:
          severityIndexValueList ?? this.severityIndexValueList,
    );
  }

  @override
  List<Object> get props => [
        temperatureUnit,
        severityIndexValueList,
      ];
}

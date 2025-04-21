part of 'alarm_description_bloc.dart';

class AlarmDescriptionState extends Equatable {
  const AlarmDescriptionState({
    this.temperatureUnit = TemperatureUnit.fahrenheit,
    this.severityIndexList = const <SeverityIndex>[],
  });

  final TemperatureUnit temperatureUnit;
  final List<SeverityIndex> severityIndexList;

  AlarmDescriptionState copyWith({
    TemperatureUnit? temperatureUnit,
    List<SeverityIndex>? severityIndexList,
  }) {
    return AlarmDescriptionState(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      severityIndexList: severityIndexList ?? this.severityIndexList,
    );
  }

  @override
  List<Object> get props => [
        temperatureUnit,
        severityIndexList,
      ];
}

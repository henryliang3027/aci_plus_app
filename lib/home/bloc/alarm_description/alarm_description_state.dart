part of 'alarm_description_bloc.dart';

class AlarmDescriptionState extends Equatable {
  const AlarmDescriptionState({
    this.aciDeviceType = ACIDeviceType.undefined,
    this.temperatureUnit = TemperatureUnit.fahrenheit,
    this.severityIndexValueList = const <SeverityIndex>[],
  });

  final ACIDeviceType aciDeviceType;
  final TemperatureUnit temperatureUnit;
  final List<SeverityIndex> severityIndexValueList;

  AlarmDescriptionState copyWith({
    ACIDeviceType? aciDeviceType,
    TemperatureUnit? temperatureUnit,
    List<SeverityIndex>? severityIndexValueList,
  }) {
    return AlarmDescriptionState(
      aciDeviceType: aciDeviceType ?? this.aciDeviceType,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      severityIndexValueList:
          severityIndexValueList ?? this.severityIndexValueList,
    );
  }

  @override
  List<Object> get props => [
        aciDeviceType,
        temperatureUnit,
        severityIndexValueList,
      ];
}

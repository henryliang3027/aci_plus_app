part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class SplashStateChanged extends HomeEvent {
  const SplashStateChanged();

  @override
  List<Object?> get props => [];
}

class DiscoveredDeviceChanged extends HomeEvent {
  const DiscoveredDeviceChanged(this.scanReport);

  final ScanReport scanReport;

  @override
  List<Object?> get props => [scanReport];
}

class DeviceConnectionChanged extends HomeEvent {
  const DeviceConnectionChanged(
    this.connectionReport,
  );

  final ConnectionReport connectionReport;

  @override
  List<Object?> get props => [
        connectionReport,
      ];
}

class DeviceCharacteristicChanged extends HomeEvent {
  const DeviceCharacteristicChanged(this.dataMapEntry);

  final MapEntry<DataKey, String> dataMapEntry;

  @override
  List<Object?> get props => [
        dataMapEntry,
      ];
}

class SettingResultChanged extends HomeEvent {
  const SettingResultChanged(this.resultDataMapEntry);

  final MapEntry<DataKey, String> resultDataMapEntry;

  @override
  List<Object?> get props => [
        resultDataMapEntry,
      ];
}

class ScanClosed extends HomeEvent {
  const ScanClosed();

  @override
  List<Object?> get props => [];
}

class DeviceRefreshed extends HomeEvent {
  const DeviceRefreshed();

  @override
  List<Object?> get props => [];
}

class SettingSubmitted extends HomeEvent {
  const SettingSubmitted(this.location);

  final String location;

  @override
  List<Object> get props => [
        location,
      ];
}

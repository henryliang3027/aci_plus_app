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

// test baud rate
class BaudRateTestRequested extends HomeEvent {
  const BaudRateTestRequested();

  @override
  List<Object?> get props => [];
}

// test baud rate
class BaudRateTest2Requested extends HomeEvent {
  const BaudRateTest2Requested();

  @override
  List<Object?> get props => [];
}

class DataRequested extends HomeEvent {
  const DataRequested();

  @override
  List<Object?> get props => [];
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

class DataExported extends HomeEvent {
  const DataExported();

  @override
  List<Object?> get props => [];
}

class DataShared extends HomeEvent {
  const DataShared();

  @override
  List<Object?> get props => [];
}

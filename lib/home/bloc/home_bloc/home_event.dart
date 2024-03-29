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
  const DeviceCharacteristicChanged(this.dataMap);

  final Map<DataKey, String> dataMap;

  @override
  List<Object?> get props => [
        dataMap,
      ];
}

class DataRequested extends HomeEvent {
  const DataRequested();

  @override
  List<Object?> get props => [];
}

class Data18Requested extends HomeEvent {
  const Data18Requested();

  @override
  List<Object?> get props => [];
}

class CCorNode18DataRequested extends HomeEvent {
  const CCorNode18DataRequested();

  @override
  List<Object?> get props => [];
}

class EventRequested extends HomeEvent {
  const EventRequested();

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

// class testTimeout extends HomeEvent {
//   const testTimeout();

//   @override
//   List<Object> get props => [];
// }

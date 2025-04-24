part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class TestUSB extends HomeEvent {
  const TestUSB();

  @override
  List<Object?> get props => [];
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

class DeviceSelected extends HomeEvent {
  const DeviceSelected(this.peripheral);

  final Peripheral peripheral;

  @override
  List<Object?> get props => [
        peripheral,
      ];
}

class DeviceSelectionCanceled extends HomeEvent {
  const DeviceSelectionCanceled();

  @override
  List<Object?> get props => [];
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
  const Data18Requested({
    this.isFirmwareUpdated = false,
  });

  final bool isFirmwareUpdated;

  @override
  List<Object?> get props => [isFirmwareUpdated];
}

class Data18CCorNodeRequested extends HomeEvent {
  const Data18CCorNodeRequested({
    this.isFirmwareUpdated = false,
  });

  final bool isFirmwareUpdated;

  @override
  List<Object?> get props => [isFirmwareUpdated];
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

class DevicePeriodicUpdateRequested extends HomeEvent {
  const DevicePeriodicUpdateRequested();

  @override
  List<Object> get props => [];
}

class DevicePeriodicUpdate extends HomeEvent {
  const DevicePeriodicUpdate({
    required this.partId,
  });

  final String partId;

  @override
  List<Object> get props => [partId];
}

class DevicePeriodicUpdateCanceled extends HomeEvent {
  const DevicePeriodicUpdateCanceled();

  @override
  List<Object> get props => [];
}

// class NeedsDataReloaded extends HomeEvent {
//   const NeedsDataReloaded(this.isReloadData);

//   final bool isReloadData;

//   @override
//   List<Object?> get props => [isReloadData];
// }

// class DataReloaded extends HomeEvent {
//   const DataReloaded();

//   @override
//   List<Object?> get props => [];
// }

// class testTimeout extends HomeEvent {
//   const testTimeout();

//   @override
//   List<Object> get props => [];
// }

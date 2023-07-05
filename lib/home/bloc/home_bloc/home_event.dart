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

class LoadingResultChanged extends HomeEvent {
  const LoadingResultChanged(this.loadingResultDataKey);

  final DataKey loadingResultDataKey;

  @override
  List<Object?> get props => [
        loadingResultDataKey,
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

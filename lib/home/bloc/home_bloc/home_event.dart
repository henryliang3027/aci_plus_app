part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class DiscoveredDeviceChanged extends HomeEvent {
  const DiscoveredDeviceChanged(
    this.scanReport,
  );

  final ScanReport scanReport;

  @override
  List<Object?> get props => [
        scanReport,
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

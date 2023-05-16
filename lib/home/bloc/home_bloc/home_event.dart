part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class DeviceConnected extends HomeEvent {
  const DeviceConnected();

  @override
  List<Object?> get props => [];
}

class DeviceChanged extends HomeEvent {
  const DeviceChanged(
    this.found,
    this.device,
  );

  final bool found;
  final DiscoveredDevice device;

  @override
  List<Object?> get props => [
        found,
        device,
      ];
}

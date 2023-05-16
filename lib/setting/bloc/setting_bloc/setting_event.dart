part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();
  @override
  List<Object> get props => [];
}

class DeviceDataRequested extends SettingEvent {
  const DeviceDataRequested();

  @override
  List<Object> get props => [];
}

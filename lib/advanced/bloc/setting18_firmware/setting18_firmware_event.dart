part of 'setting18_firmware_bloc.dart';

sealed class Setting18FirmwareEvent extends Equatable {
  const Setting18FirmwareEvent();

  @override
  List<Object> get props => [];
}

class BinaryDataLoaded extends Setting18FirmwareEvent {
  const BinaryDataLoaded();

  @override
  List<Object> get props => [];
}

class BootloaderStarted extends Setting18FirmwareEvent {
  const BootloaderStarted();

  @override
  List<Object> get props => [];
}

class UpdateStarted extends Setting18FirmwareEvent {
  const UpdateStarted();

  @override
  List<Object> get props => [];
}
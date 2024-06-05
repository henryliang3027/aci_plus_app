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

class BootloaderExited extends Setting18FirmwareEvent {
  const BootloaderExited();

  @override
  List<Object> get props => [];
}

class UpdateStarted extends Setting18FirmwareEvent {
  const UpdateStarted();

  @override
  List<Object> get props => [];
}

class MessageReceived extends Setting18FirmwareEvent {
  const MessageReceived({
    required this.message,
    required this.currentProgress,
  });

  final String message;
  final double currentProgress;

  @override
  List<Object> get props => [
        message,
        currentProgress,
      ];
}

class CommandWrited extends Setting18FirmwareEvent {
  const CommandWrited(this.character);

  final String character;

  @override
  List<Object> get props => [character];
}

class BinarySelected extends Setting18FirmwareEvent {
  const BinarySelected(this.selectedPartId);

  final String selectedPartId;

  @override
  List<Object> get props => [selectedPartId];
}

part of 'setting18_firmware_update_bloc.dart';

sealed class Setting18FirmwareUpdateEvent extends Equatable {
  const Setting18FirmwareUpdateEvent();

  @override
  List<Object> get props => [];
}

class BootloaderStarted extends Setting18FirmwareUpdateEvent {
  const BootloaderStarted();

  @override
  List<Object> get props => [];
}

class BootloaderExited extends Setting18FirmwareUpdateEvent {
  const BootloaderExited();

  @override
  List<Object> get props => [];
}

class BootloaderForceExited extends Setting18FirmwareUpdateEvent {
  const BootloaderForceExited({
    required this.cmd,
  });

  final String cmd;

  @override
  List<Object> get props => [cmd];
}

class UpdateStarted extends Setting18FirmwareUpdateEvent {
  const UpdateStarted();

  @override
  List<Object> get props => [];
}

class MessageReceived extends Setting18FirmwareUpdateEvent {
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

class ErrorReceived extends Setting18FirmwareUpdateEvent {
  const ErrorReceived({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object> get props => [
        errorMessage,
      ];
}

class CommandWrited extends Setting18FirmwareUpdateEvent {
  const CommandWrited(this.character);

  final String character;

  @override
  List<Object> get props => [character];
}

class BinarySelected extends Setting18FirmwareUpdateEvent {
  const BinarySelected({
    required this.partId,
  });

  final String partId;

  @override
  List<Object> get props => [partId];
}

class BinaryLoaded extends Setting18FirmwareUpdateEvent {
  const BinaryLoaded({
    required this.partId,
    required this.currentFirmwareVersion,
  });

  final String partId;
  final String currentFirmwareVersion;

  @override
  List<Object> get props => [
        partId,
        currentFirmwareVersion,
      ];
}

class BinaryCanceled extends Setting18FirmwareUpdateEvent {
  const BinaryCanceled();

  @override
  List<Object> get props => [];
}

class UpdateLogAdded extends Setting18FirmwareUpdateEvent {
  const UpdateLogAdded({required this.previousFirmwareVersion});

  final int previousFirmwareVersion;

  @override
  List<Object> get props => [previousFirmwareVersion];
}

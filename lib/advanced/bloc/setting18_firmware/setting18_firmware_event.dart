part of 'setting18_firmware_bloc.dart';

sealed class Setting18FirmwareEvent extends Equatable {
  const Setting18FirmwareEvent();

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

class BootloaderForceExited extends Setting18FirmwareEvent {
  const BootloaderForceExited({
    required this.cmd,
  });

  final String cmd;

  @override
  List<Object> get props => [cmd];
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

class ErrorReceived extends Setting18FirmwareEvent {
  const ErrorReceived({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object> get props => [
        errorMessage,
      ];
}

class CommandWrited extends Setting18FirmwareEvent {
  const CommandWrited(this.character);

  final String character;

  @override
  List<Object> get props => [character];
}

class BinarySelected extends Setting18FirmwareEvent {
  const BinarySelected(this.selectedBinary);

  final String selectedBinary;

  @override
  List<Object> get props => [selectedBinary];
}

class BinaryLoaded extends Setting18FirmwareEvent {
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

class BinaryCanceled extends Setting18FirmwareEvent {
  const BinaryCanceled();

  @override
  List<Object> get props => [];
}

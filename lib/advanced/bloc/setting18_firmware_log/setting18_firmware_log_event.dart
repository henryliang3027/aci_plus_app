part of 'setting18_firmware_log_bloc.dart';

sealed class Setting18FirmwareLogEvent extends Equatable {
  const Setting18FirmwareLogEvent();

  @override
  List<Object> get props => [];
}

class UpdateLogRequested extends Setting18FirmwareLogEvent {
  const UpdateLogRequested();

  @override
  List<Object> get props => [];
}

class TestUpdateLogRequested extends Setting18FirmwareLogEvent {
  const TestUpdateLogRequested();

  @override
  List<Object> get props => [];
}

class TestAllUpdateLogDeleted extends Setting18FirmwareLogEvent {
  const TestAllUpdateLogDeleted();

  @override
  List<Object> get props => [];
}

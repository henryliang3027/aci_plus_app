part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();
  @override
  List<Object> get props => [];
}

class GraphViewToggled extends SettingEvent {
  const GraphViewToggled();

  @override
  List<Object> get props => [];
}

class ListViewToggled extends SettingEvent {
  const ListViewToggled();

  @override
  List<Object> get props => [];
}

class LocationChanged extends SettingEvent {
  const LocationChanged(
    this.location,
  );

  final String location;

  @override
  List<Object> get props => [
        location,
      ];
}

class TGCCableLengthChanged extends SettingEvent {
  const TGCCableLengthChanged(
    this.tgcCableLength,
  );

  final String tgcCableLength;

  @override
  List<Object> get props => [
        tgcCableLength,
      ];
}

class LogIntervalChanged extends SettingEvent {
  const LogIntervalChanged(
    this.logIntervalId,
  );

  final int logIntervalId;

  @override
  List<Object> get props => [
        logIntervalId,
      ];
}

class LocationSubmitted extends SettingEvent {
  const LocationSubmitted();

  @override
  List<Object> get props => [];
}

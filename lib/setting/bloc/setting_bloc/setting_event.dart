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

part of 'setting18_list_view_bloc.dart';

abstract class Setting18ListViewEvent extends Equatable {
  const Setting18ListViewEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18ListViewEvent {
  const Initialized(this.isLoadData);

  final bool isLoadData;

  @override
  List<Object> get props => [isLoadData];
}

class EditModeEnabled extends Setting18ListViewEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18ListViewEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18ListViewEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

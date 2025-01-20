part of 'setting18_reverse_control_bloc.dart';

sealed class Setting18ReverseControlEvent extends Equatable {
  const Setting18ReverseControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18ReverseControlEvent {
  const Initialized({this.useCache = true});

  final bool useCache;

  @override
  List<Object> get props => [useCache];
}

class ControlItemChanged extends Setting18ReverseControlEvent {
  const ControlItemChanged({
    required this.dataKey,
    required this.value,
  });

  final DataKey dataKey;
  final String value;
}

class ResetReverseValuesRequested extends Setting18ReverseControlEvent {
  const ResetReverseValuesRequested();

  @override
  List<Object> get props => [];
}

class EditModeEnabled extends Setting18ReverseControlEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18ReverseControlEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18ReverseControlEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

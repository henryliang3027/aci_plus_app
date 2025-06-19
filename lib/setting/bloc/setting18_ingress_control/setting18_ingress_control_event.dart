part of 'setting18_ingress_control_bloc.dart';

sealed class Setting18IngressControlEvent extends Equatable {
  const Setting18IngressControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18IngressControlEvent {
  const Initialized({this.useCache = true});

  final bool useCache;

  @override
  List<Object> get props => [useCache];
}

class ControlItemChanged extends Setting18IngressControlEvent {
  const ControlItemChanged({
    required this.dataKey,
    required this.value,
  });

  final DataKey dataKey;
  final String value;
}

class EditModeEnabled extends Setting18IngressControlEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18IngressControlEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18IngressControlEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

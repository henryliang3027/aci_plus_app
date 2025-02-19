part of 'setting18_ccor_node_ingress_control_bloc.dart';

sealed class Setting18CCorNodeIngressControlEvent extends Equatable {
  const Setting18CCorNodeIngressControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18CCorNodeIngressControlEvent {
  const Initialized();

  @override
  List<Object> get props => [];
}

class ReturnIngressSetting1Changed
    extends Setting18CCorNodeIngressControlEvent {
  const ReturnIngressSetting1Changed(this.returnIngressSetting1);

  final String returnIngressSetting1;

  @override
  List<Object> get props => [returnIngressSetting1];
}

class ReturnIngressSetting3Changed
    extends Setting18CCorNodeIngressControlEvent {
  const ReturnIngressSetting3Changed(this.returnIngressSetting3);

  final String returnIngressSetting3;

  @override
  List<Object> get props => [returnIngressSetting3];
}

class ReturnIngressSetting4Changed
    extends Setting18CCorNodeIngressControlEvent {
  const ReturnIngressSetting4Changed(this.returnIngressSetting4);

  final String returnIngressSetting4;

  @override
  List<Object> get props => [returnIngressSetting4];
}

class ReturnIngressSetting6Changed
    extends Setting18CCorNodeIngressControlEvent {
  const ReturnIngressSetting6Changed(this.returnIngressSetting6);

  final String returnIngressSetting6;

  @override
  List<Object> get props => [returnIngressSetting6];
}

class EditModeEnabled extends Setting18CCorNodeIngressControlEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18CCorNodeIngressControlEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18CCorNodeIngressControlEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

part of 'setting18_ccor_node_reverse_control_bloc.dart';

sealed class Setting18CCorNodeReverseControlEvent extends Equatable {
  const Setting18CCorNodeReverseControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18CCorNodeReverseControlEvent {
  const Initialized();

  @override
  List<Object> get props => [];
}

class USVCA1Changed extends Setting18CCorNodeReverseControlEvent {
  const USVCA1Changed({
    required this.usVCA1,
  });

  final String usVCA1;

  @override
  List<Object> get props => [
        usVCA1,
      ];
}

class USVCA3Changed extends Setting18CCorNodeReverseControlEvent {
  const USVCA3Changed({
    required this.usVCA3,
  });

  final String usVCA3;

  @override
  List<Object> get props => [
        usVCA3,
      ];
}

class USVCA4Changed extends Setting18CCorNodeReverseControlEvent {
  const USVCA4Changed({
    required this.usVCA4,
  });

  final String usVCA4;

  @override
  List<Object> get props => [
        usVCA4,
      ];
}

class USVCA6Changed extends Setting18CCorNodeReverseControlEvent {
  const USVCA6Changed({
    required this.usVCA6,
  });

  final String usVCA6;

  @override
  List<Object> get props => [
        usVCA6,
      ];
}

class ReturnIngressSetting1Changed
    extends Setting18CCorNodeReverseControlEvent {
  const ReturnIngressSetting1Changed(this.returnIngressSetting1);

  final String returnIngressSetting1;

  @override
  List<Object> get props => [returnIngressSetting1];
}

class ReturnIngressSetting3Changed
    extends Setting18CCorNodeReverseControlEvent {
  const ReturnIngressSetting3Changed(this.returnIngressSetting3);

  final String returnIngressSetting3;

  @override
  List<Object> get props => [returnIngressSetting3];
}

class ReturnIngressSetting4Changed
    extends Setting18CCorNodeReverseControlEvent {
  const ReturnIngressSetting4Changed(this.returnIngressSetting4);

  final String returnIngressSetting4;

  @override
  List<Object> get props => [returnIngressSetting4];
}

class ReturnIngressSetting6Changed
    extends Setting18CCorNodeReverseControlEvent {
  const ReturnIngressSetting6Changed(this.returnIngressSetting6);

  final String returnIngressSetting6;

  @override
  List<Object> get props => [returnIngressSetting6];
}

class EditModeEnabled extends Setting18CCorNodeReverseControlEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18CCorNodeReverseControlEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18CCorNodeReverseControlEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

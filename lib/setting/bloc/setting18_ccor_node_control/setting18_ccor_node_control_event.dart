part of 'setting18_ccor_node_control_bloc.dart';

abstract class Setting18CCorNodeControlEvent extends Equatable {
  const Setting18CCorNodeControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18CCorNodeControlEvent {
  const Initialized();

  @override
  List<Object> get props => [];
}

class DSVVA1Changed extends Setting18CCorNodeControlEvent {
  const DSVVA1Changed(this.dsVVA1);

  final String dsVVA1;

  @override
  List<Object> get props => [dsVVA1];
}

class DSVVA1Increased extends Setting18CCorNodeControlEvent {
  const DSVVA1Increased();

  @override
  List<Object> get props => [];
}

class DSVVA1Decreased extends Setting18CCorNodeControlEvent {
  const DSVVA1Decreased();

  @override
  List<Object> get props => [];
}

class DSVVA3Changed extends Setting18CCorNodeControlEvent {
  const DSVVA3Changed(this.dsVVA3);

  final String dsVVA3;

  @override
  List<Object> get props => [dsVVA3];
}

class DSVVA3Increased extends Setting18CCorNodeControlEvent {
  const DSVVA3Increased();

  @override
  List<Object> get props => [];
}

class DSVVA3Decreased extends Setting18CCorNodeControlEvent {
  const DSVVA3Decreased();

  @override
  List<Object> get props => [];
}

class DSVVA4Changed extends Setting18CCorNodeControlEvent {
  const DSVVA4Changed(this.dsVVA4);

  final String dsVVA4;

  @override
  List<Object> get props => [dsVVA4];
}

class DSVVA4Increased extends Setting18CCorNodeControlEvent {
  const DSVVA4Increased();

  @override
  List<Object> get props => [];
}

class DSVVA4Decreased extends Setting18CCorNodeControlEvent {
  const DSVVA4Decreased();

  @override
  List<Object> get props => [];
}

class DSVVA6Changed extends Setting18CCorNodeControlEvent {
  const DSVVA6Changed(this.dsVVA6);

  final String dsVVA6;

  @override
  List<Object> get props => [dsVVA6];
}

class DSVVA6Increased extends Setting18CCorNodeControlEvent {
  const DSVVA6Increased();

  @override
  List<Object> get props => [];
}

class DSVVA6Decreased extends Setting18CCorNodeControlEvent {
  const DSVVA6Decreased();

  @override
  List<Object> get props => [];
}

class DSInSlope1Changed extends Setting18CCorNodeControlEvent {
  const DSInSlope1Changed(this.dsInSlope1);

  final String dsInSlope1;

  @override
  List<Object> get props => [dsInSlope1];
}

class DSInSlope1Increased extends Setting18CCorNodeControlEvent {
  const DSInSlope1Increased();

  @override
  List<Object> get props => [];
}

class DSInSlope1Decreased extends Setting18CCorNodeControlEvent {
  const DSInSlope1Decreased();

  @override
  List<Object> get props => [];
}

class DSInSlope3Changed extends Setting18CCorNodeControlEvent {
  const DSInSlope3Changed(this.dsInSlope3);

  final String dsInSlope3;

  @override
  List<Object> get props => [dsInSlope3];
}

class DSInSlope3Increased extends Setting18CCorNodeControlEvent {
  const DSInSlope3Increased();

  @override
  List<Object> get props => [];
}

class DSInSlope3Decreased extends Setting18CCorNodeControlEvent {
  const DSInSlope3Decreased();

  @override
  List<Object> get props => [];
}

class DSInSlope4Changed extends Setting18CCorNodeControlEvent {
  const DSInSlope4Changed(this.dsInSlope4);

  final String dsInSlope4;

  @override
  List<Object> get props => [dsInSlope4];
}

class DSInSlope4Increased extends Setting18CCorNodeControlEvent {
  const DSInSlope4Increased();

  @override
  List<Object> get props => [];
}

class DSInSlope4Decreased extends Setting18CCorNodeControlEvent {
  const DSInSlope4Decreased();

  @override
  List<Object> get props => [];
}

class DSInSlope6Changed extends Setting18CCorNodeControlEvent {
  const DSInSlope6Changed(this.dsInSlope6);

  final String dsInSlope6;

  @override
  List<Object> get props => [dsInSlope6];
}

class DSInSlope6Increased extends Setting18CCorNodeControlEvent {
  const DSInSlope6Increased();

  @override
  List<Object> get props => [];
}

class DSInSlope6Decreased extends Setting18CCorNodeControlEvent {
  const DSInSlope6Decreased();

  @override
  List<Object> get props => [];
}

class USVCA1Changed extends Setting18CCorNodeControlEvent {
  const USVCA1Changed(this.usVCA1);

  final String usVCA1;

  @override
  List<Object> get props => [usVCA1];
}

class USVCA1Increased extends Setting18CCorNodeControlEvent {
  const USVCA1Increased();

  @override
  List<Object> get props => [];
}

class USVCA1Decreased extends Setting18CCorNodeControlEvent {
  const USVCA1Decreased();

  @override
  List<Object> get props => [];
}

class USVCA3Changed extends Setting18CCorNodeControlEvent {
  const USVCA3Changed(this.usVCA3);

  final String usVCA3;

  @override
  List<Object> get props => [usVCA3];
}

class USVCA3Increased extends Setting18CCorNodeControlEvent {
  const USVCA3Increased();

  @override
  List<Object> get props => [];
}

class USVCA3Decreased extends Setting18CCorNodeControlEvent {
  const USVCA3Decreased();

  @override
  List<Object> get props => [];
}

class USVCA4Changed extends Setting18CCorNodeControlEvent {
  const USVCA4Changed(this.usVCA4);

  final String usVCA4;

  @override
  List<Object> get props => [usVCA4];
}

class USVCA4Increased extends Setting18CCorNodeControlEvent {
  const USVCA4Increased();

  @override
  List<Object> get props => [];
}

class USVCA4Decreased extends Setting18CCorNodeControlEvent {
  const USVCA4Decreased();

  @override
  List<Object> get props => [];
}

class USVCA6Changed extends Setting18CCorNodeControlEvent {
  const USVCA6Changed(this.usVCA6);

  final String usVCA6;

  @override
  List<Object> get props => [usVCA6];
}

class USVCA6Increased extends Setting18CCorNodeControlEvent {
  const USVCA6Increased();

  @override
  List<Object> get props => [];
}

class USVCA6Decreased extends Setting18CCorNodeControlEvent {
  const USVCA6Decreased();

  @override
  List<Object> get props => [];
}

class ReturnIngressSetting1Changed extends Setting18CCorNodeControlEvent {
  const ReturnIngressSetting1Changed(this.returnIngressSetting1);

  final String returnIngressSetting1;

  @override
  List<Object> get props => [returnIngressSetting1];
}

class ReturnIngressSetting3Changed extends Setting18CCorNodeControlEvent {
  const ReturnIngressSetting3Changed(this.returnIngressSetting3);

  final String returnIngressSetting3;

  @override
  List<Object> get props => [returnIngressSetting3];
}

class ReturnIngressSetting4Changed extends Setting18CCorNodeControlEvent {
  const ReturnIngressSetting4Changed(this.returnIngressSetting4);

  final String returnIngressSetting4;

  @override
  List<Object> get props => [returnIngressSetting4];
}

class ReturnIngressSetting6Changed extends Setting18CCorNodeControlEvent {
  const ReturnIngressSetting6Changed(this.returnIngressSetting6);

  final String returnIngressSetting6;

  @override
  List<Object> get props => [returnIngressSetting6];
}

class EditModeEnabled extends Setting18CCorNodeControlEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18CCorNodeControlEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18CCorNodeControlEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

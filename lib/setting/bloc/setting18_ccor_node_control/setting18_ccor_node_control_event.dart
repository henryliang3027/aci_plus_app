part of 'setting18_ccor_node_control_bloc.dart';

sealed class Setting18CCorNodeControlEvent extends Equatable {
  const Setting18CCorNodeControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18CCorNodeControlEvent {
  const Initialized({
    required this.returnInputAttenuation1,
    required this.returnInputAttenuation3,
    required this.returnInputAttenuation4,
    required this.returnInputAttenuation6,
    required this.returnIngressSetting1,
    required this.returnIngressSetting3,
    required this.returnIngressSetting4,
    required this.returnIngressSetting6,
  });

  final String returnInputAttenuation1;
  final String returnInputAttenuation3;
  final String returnInputAttenuation4;
  final String returnInputAttenuation6;
  final String returnIngressSetting1;
  final String returnIngressSetting3;
  final String returnIngressSetting4;
  final String returnIngressSetting6;

  @override
  List<Object> get props => [
        returnInputAttenuation1,
        returnInputAttenuation3,
        returnInputAttenuation4,
        returnInputAttenuation6,
        returnIngressSetting1,
        returnIngressSetting3,
        returnIngressSetting4,
        returnIngressSetting6,
      ];
}

class ReturnInputAttenuation1Changed extends Setting18CCorNodeControlEvent {
  const ReturnInputAttenuation1Changed(this.returnInputAttenuation1);

  final String returnInputAttenuation1;

  @override
  List<Object> get props => [returnInputAttenuation1];
}

class ReturnInputAttenuation1Increased extends Setting18CCorNodeControlEvent {
  const ReturnInputAttenuation1Increased();

  @override
  List<Object> get props => [];
}

class ReturnInputAttenuation1Decreased extends Setting18CCorNodeControlEvent {
  const ReturnInputAttenuation1Decreased();

  @override
  List<Object> get props => [];
}

class ReturnInputAttenuation3Changed extends Setting18CCorNodeControlEvent {
  const ReturnInputAttenuation3Changed(this.returnInputAttenuation3);

  final String returnInputAttenuation3;

  @override
  List<Object> get props => [returnInputAttenuation3];
}

class ReturnInputAttenuation3Increased extends Setting18CCorNodeControlEvent {
  const ReturnInputAttenuation3Increased();

  @override
  List<Object> get props => [];
}

class ReturnInputAttenuation3Decreased extends Setting18CCorNodeControlEvent {
  const ReturnInputAttenuation3Decreased();

  @override
  List<Object> get props => [];
}

class ReturnInputAttenuation4Changed extends Setting18CCorNodeControlEvent {
  const ReturnInputAttenuation4Changed(this.returnInputAttenuation4);

  final String returnInputAttenuation4;

  @override
  List<Object> get props => [returnInputAttenuation4];
}

class ReturnInputAttenuation4Increased extends Setting18CCorNodeControlEvent {
  const ReturnInputAttenuation4Increased();

  @override
  List<Object> get props => [];
}

class ReturnInputAttenuation4Decreased extends Setting18CCorNodeControlEvent {
  const ReturnInputAttenuation4Decreased();

  @override
  List<Object> get props => [];
}

class ReturnInputAttenuation6Changed extends Setting18CCorNodeControlEvent {
  const ReturnInputAttenuation6Changed(this.returnInputAttenuation6);

  final String returnInputAttenuation6;

  @override
  List<Object> get props => [returnInputAttenuation6];
}

class ReturnInputAttenuation6Increased extends Setting18CCorNodeControlEvent {
  const ReturnInputAttenuation6Increased();

  @override
  List<Object> get props => [];
}

class ReturnInputAttenuation6Decreased extends Setting18CCorNodeControlEvent {
  const ReturnInputAttenuation6Decreased();

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

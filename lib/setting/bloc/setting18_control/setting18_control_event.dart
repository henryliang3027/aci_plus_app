part of 'setting18_control_bloc.dart';

class Setting18ControlEvent extends Equatable {
  const Setting18ControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18ControlEvent {
  const Initialized();

  @override
  List<Object> get props => [];
}

class DSVVA1Changed extends Setting18ControlEvent {
  const DSVVA1Changed({
    required this.dsVVA1,
  });

  final String dsVVA1;

  @override
  List<Object> get props => [
        dsVVA1,
      ];
}

class DSSlope1Changed extends Setting18ControlEvent {
  const DSSlope1Changed({
    required this.dsSlope1,
  });

  final String dsSlope1;

  @override
  List<Object> get props => [
        dsSlope1,
      ];
}

class USVCA1Changed extends Setting18ControlEvent {
  const USVCA1Changed({
    required this.usVCA1,
  });

  final String usVCA1;

  @override
  List<Object> get props => [
        usVCA1,
      ];
}

class USVCA3Changed extends Setting18ControlEvent {
  const USVCA3Changed({
    required this.usVCA3,
  });

  final String usVCA3;

  @override
  List<Object> get props => [
        usVCA3,
      ];
}

class USVCA4Changed extends Setting18ControlEvent {
  const USVCA4Changed({
    required this.usVCA4,
  });

  final String usVCA4;

  @override
  List<Object> get props => [
        usVCA4,
      ];
}

class USVCA2Changed extends Setting18ControlEvent {
  const USVCA2Changed({
    required this.usVCA2,
  });

  final String usVCA2;

  @override
  List<Object> get props => [
        usVCA2,
      ];
}

class EREQChanged extends Setting18ControlEvent {
  const EREQChanged({
    required this.eREQ,
  });

  final String eREQ;

  @override
  List<Object> get props => [
        eREQ,
      ];
}

class RtnIngressSetting2Changed extends Setting18ControlEvent {
  const RtnIngressSetting2Changed(this.returnIngressSetting2);

  final String returnIngressSetting2;

  @override
  List<Object> get props => [returnIngressSetting2];
}

class RtnIngressSetting3Changed extends Setting18ControlEvent {
  const RtnIngressSetting3Changed(this.returnIngressSetting3);

  final String returnIngressSetting3;

  @override
  List<Object> get props => [returnIngressSetting3];
}

class RtnIngressSetting4Changed extends Setting18ControlEvent {
  const RtnIngressSetting4Changed(this.returnIngressSetting4);

  final String returnIngressSetting4;

  @override
  List<Object> get props => [returnIngressSetting4];
}

class TGCCableLengthChanged extends Setting18ControlEvent {
  const TGCCableLengthChanged(this.tgcCableLength);

  final String tgcCableLength;

  @override
  List<Object> get props => [tgcCableLength];
}

class DSVVA2Changed extends Setting18ControlEvent {
  const DSVVA2Changed({
    required this.dsVVA2,
  });

  final String dsVVA2;

  @override
  List<Object> get props => [
        dsVVA2,
      ];
}

class DSSlope2Changed extends Setting18ControlEvent {
  const DSSlope2Changed({
    required this.dsSlope2,
  });

  final String dsSlope2;

  @override
  List<Object> get props => [
        dsSlope2,
      ];
}

class DSSlope3Changed extends Setting18ControlEvent {
  const DSSlope3Changed({
    required this.dsSlope3,
  });

  final String dsSlope3;

  @override
  List<Object> get props => [
        dsSlope3,
      ];
}

class DSSlope4Changed extends Setting18ControlEvent {
  const DSSlope4Changed({
    required this.dsSlope4,
  });

  final String dsSlope4;

  @override
  List<Object> get props => [
        dsSlope4,
      ];
}

class DSVVA3Changed extends Setting18ControlEvent {
  const DSVVA3Changed(this.dsVVA3);

  final String dsVVA3;

  @override
  List<Object> get props => [dsVVA3];
}

class DSVVA4Changed extends Setting18ControlEvent {
  const DSVVA4Changed({
    required this.dsVVA4,
  });

  final String dsVVA4;

  @override
  List<Object> get props => [
        dsVVA4,
      ];
}

class DSVVA5Changed extends Setting18ControlEvent {
  const DSVVA5Changed({
    required this.dsVVA5,
  });

  final String dsVVA5;

  @override
  List<Object> get props => [
        dsVVA5,
      ];
}

class USTGCChanged extends Setting18ControlEvent {
  const USTGCChanged(this.usTGC);

  final String usTGC;

  @override
  List<Object> get props => [usTGC];
}

class ResetForwardValuesRequested extends Setting18ControlEvent {
  const ResetForwardValuesRequested();

  @override
  List<Object> get props => [];
}

class ResetReverseValuesRequested extends Setting18ControlEvent {
  const ResetReverseValuesRequested();

  @override
  List<Object> get props => [];
}

class EditModeEnabled extends Setting18ControlEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18ControlEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18ControlEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

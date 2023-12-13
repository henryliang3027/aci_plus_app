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

class FwdInputAttenuationChanged extends Setting18ControlEvent {
  const FwdInputAttenuationChanged(this.fwdInputAttenuation);

  final String fwdInputAttenuation;

  @override
  List<Object> get props => [fwdInputAttenuation];
}

class FwdInputAttenuationIncreased extends Setting18ControlEvent {
  const FwdInputAttenuationIncreased();

  @override
  List<Object> get props => [];
}

class FwdInputAttenuationDecreased extends Setting18ControlEvent {
  const FwdInputAttenuationDecreased();

  @override
  List<Object> get props => [];
}

class FwdInputEQChanged extends Setting18ControlEvent {
  const FwdInputEQChanged(this.fwdInputEQ);

  final String fwdInputEQ;

  @override
  List<Object> get props => [fwdInputEQ];
}

class FwdInputEQIncreased extends Setting18ControlEvent {
  const FwdInputEQIncreased();

  @override
  List<Object> get props => [];
}

class FwdInputEQDecreased extends Setting18ControlEvent {
  const FwdInputEQDecreased();

  @override
  List<Object> get props => [];
}

class RtnInputAttenuation2Changed extends Setting18ControlEvent {
  const RtnInputAttenuation2Changed(this.rtnInputAttenuation2);

  final String rtnInputAttenuation2;

  @override
  List<Object> get props => [rtnInputAttenuation2];
}

class RtnInputAttenuation2Increased extends Setting18ControlEvent {
  const RtnInputAttenuation2Increased();

  @override
  List<Object> get props => [];
}

class RtnInputAttenuation2Decreased extends Setting18ControlEvent {
  const RtnInputAttenuation2Decreased();

  @override
  List<Object> get props => [];
}

class USVCA3Changed extends Setting18ControlEvent {
  const USVCA3Changed(this.usVCA3);

  final String usVCA3;

  @override
  List<Object> get props => [usVCA3];
}

class USVCA3Increased extends Setting18ControlEvent {
  const USVCA3Increased();

  @override
  List<Object> get props => [];
}

class USVCA3Decreased extends Setting18ControlEvent {
  const USVCA3Decreased();

  @override
  List<Object> get props => [];
}

class USVCA4Changed extends Setting18ControlEvent {
  const USVCA4Changed(this.usVCA4);

  final String usVCA4;

  @override
  List<Object> get props => [usVCA4];
}

class USVCA4Increased extends Setting18ControlEvent {
  const USVCA4Increased();

  @override
  List<Object> get props => [];
}

class USVCA4Decreased extends Setting18ControlEvent {
  const USVCA4Decreased();

  @override
  List<Object> get props => [];
}

class RtnOutputLevelAttenuationChanged extends Setting18ControlEvent {
  const RtnOutputLevelAttenuationChanged(this.rtnOutputLevelAttenuation);

  final String rtnOutputLevelAttenuation;

  @override
  List<Object> get props => [rtnOutputLevelAttenuation];
}

class RtnOutputLevelAttenuationIncreased extends Setting18ControlEvent {
  const RtnOutputLevelAttenuationIncreased();

  @override
  List<Object> get props => [];
}

class RtnOutputLevelAttenuationDecreased extends Setting18ControlEvent {
  const RtnOutputLevelAttenuationDecreased();

  @override
  List<Object> get props => [];
}

class RtnOutputEQChanged extends Setting18ControlEvent {
  const RtnOutputEQChanged(this.rtnOutputEQ);

  final String rtnOutputEQ;

  @override
  List<Object> get props => [rtnOutputEQ];
}

class RtnOutputEQIncreased extends Setting18ControlEvent {
  const RtnOutputEQIncreased();

  @override
  List<Object> get props => [];
}

class RtnOutputEQDecreased extends Setting18ControlEvent {
  const RtnOutputEQDecreased();

  @override
  List<Object> get props => [];
}

class RtnIngressSetting2Changed extends Setting18ControlEvent {
  const RtnIngressSetting2Changed(this.rtnIngressSetting2);

  final String rtnIngressSetting2;

  @override
  List<Object> get props => [rtnIngressSetting2];
}

class RtnIngressSetting3Changed extends Setting18ControlEvent {
  const RtnIngressSetting3Changed(this.rtnIngressSetting3);

  final String rtnIngressSetting3;

  @override
  List<Object> get props => [rtnIngressSetting3];
}

class RtnIngressSetting4Changed extends Setting18ControlEvent {
  const RtnIngressSetting4Changed(this.rtnIngressSetting4);

  final String rtnIngressSetting4;

  @override
  List<Object> get props => [rtnIngressSetting4];
}

class TGCCableLengthChanged extends Setting18ControlEvent {
  const TGCCableLengthChanged(this.tgcCableLength);

  final String tgcCableLength;

  @override
  List<Object> get props => [tgcCableLength];
}

class DSVVA2Changed extends Setting18ControlEvent {
  const DSVVA2Changed(this.dsVVA2);

  final String dsVVA2;

  @override
  List<Object> get props => [dsVVA2];
}

class DSSlope2Changed extends Setting18ControlEvent {
  const DSSlope2Changed(this.dsSlope2);

  final String dsSlope2;

  @override
  List<Object> get props => [dsSlope2];
}

class DSSlope3Changed extends Setting18ControlEvent {
  const DSSlope3Changed(this.dsSlope3);

  final String dsSlope3;

  @override
  List<Object> get props => [dsSlope3];
}

class DSSlope3Increased extends Setting18ControlEvent {
  const DSSlope3Increased();

  @override
  List<Object> get props => [];
}

class DSSlope3Decreased extends Setting18ControlEvent {
  const DSSlope3Decreased();

  @override
  List<Object> get props => [];
}

class DSSlope4Changed extends Setting18ControlEvent {
  const DSSlope4Changed(this.dsSlope4);

  final String dsSlope4;

  @override
  List<Object> get props => [dsSlope4];
}

class DSSlope4Increased extends Setting18ControlEvent {
  const DSSlope4Increased();

  @override
  List<Object> get props => [];
}

class DSSlope4Decreased extends Setting18ControlEvent {
  const DSSlope4Decreased();

  @override
  List<Object> get props => [];
}

class DSVVA3Changed extends Setting18ControlEvent {
  const DSVVA3Changed(this.dsVVA3);

  final String dsVVA3;

  @override
  List<Object> get props => [dsVVA3];
}

class DSVVA4Changed extends Setting18ControlEvent {
  const DSVVA4Changed(this.dsVVA4);

  final String dsVVA4;

  @override
  List<Object> get props => [dsVVA4];
}

class DSVVA4Increased extends Setting18ControlEvent {
  const DSVVA4Increased();

  @override
  List<Object> get props => [];
}

class DSVVA4Decreased extends Setting18ControlEvent {
  const DSVVA4Decreased();

  @override
  List<Object> get props => [];
}

class DSVVA5Changed extends Setting18ControlEvent {
  const DSVVA5Changed(this.dsVVA5);

  final String dsVVA5;

  @override
  List<Object> get props => [dsVVA5];
}

class DSVVA5Increased extends Setting18ControlEvent {
  const DSVVA5Increased();

  @override
  List<Object> get props => [];
}

class DSVVA5Decreased extends Setting18ControlEvent {
  const DSVVA5Decreased();

  @override
  List<Object> get props => [];
}

class USTGCChanged extends Setting18ControlEvent {
  const USTGCChanged(this.usTGC);

  final String usTGC;

  @override
  List<Object> get props => [usTGC];
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

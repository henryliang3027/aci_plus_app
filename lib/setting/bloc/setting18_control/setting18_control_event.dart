part of 'setting18_control_bloc.dart';

class Setting18ControlEvent extends Equatable {
  const Setting18ControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18ControlEvent {
  const Initialized({
    required this.fwdInputAttenuation,
    required this.fwdInputEQ,
    required this.rtnInputAttenuation2,
    required this.rtnInputAttenuation3,
    required this.rtnInputAttenuation4,
    required this.rtnOutputLevelAttenuation,
    required this.rtnOutputEQ,
    required this.rtnIngressSetting2,
    required this.rtnIngressSetting3,
    required this.rtnIngressSetting4,
    required this.tgcCableLength,
    required this.dsVVA2,
    required this.dsSlope2,
    required this.dsVVA3,
    required this.dsVVA4,
    required this.usTGC,
  });

  final String fwdInputAttenuation;
  final String fwdInputEQ;
  final String rtnInputAttenuation2;
  final String rtnInputAttenuation3;
  final String rtnInputAttenuation4;
  final String rtnOutputLevelAttenuation;
  final String rtnOutputEQ;
  final String rtnIngressSetting2;
  final String rtnIngressSetting3;
  final String rtnIngressSetting4;
  final String tgcCableLength;
  final String dsVVA2;
  final String dsSlope2;
  final String dsVVA3;
  final String dsVVA4;
  final String usTGC;

  @override
  List<Object> get props => [
        fwdInputAttenuation,
        fwdInputEQ,
        rtnInputAttenuation2,
        rtnInputAttenuation3,
        rtnInputAttenuation4,
        rtnOutputLevelAttenuation,
        rtnOutputEQ,
        rtnIngressSetting2,
        rtnIngressSetting3,
        rtnIngressSetting4,
        tgcCableLength,
        dsVVA2,
        dsSlope2,
        dsVVA3,
        dsVVA4,
        usTGC,
      ];
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

class RtnInputAttenuation3Changed extends Setting18ControlEvent {
  const RtnInputAttenuation3Changed(this.rtnInputAttenuation3);

  final String rtnInputAttenuation3;

  @override
  List<Object> get props => [rtnInputAttenuation3];
}

class RtnInputAttenuation3Increased extends Setting18ControlEvent {
  const RtnInputAttenuation3Increased();

  @override
  List<Object> get props => [];
}

class RtnInputAttenuation3Decreased extends Setting18ControlEvent {
  const RtnInputAttenuation3Decreased();

  @override
  List<Object> get props => [];
}

class RtnInputAttenuation4Changed extends Setting18ControlEvent {
  const RtnInputAttenuation4Changed(this.rtnInputAttenuation4);

  final String rtnInputAttenuation4;

  @override
  List<Object> get props => [rtnInputAttenuation4];
}

class RtnInputAttenuation4Increased extends Setting18ControlEvent {
  const RtnInputAttenuation4Increased();

  @override
  List<Object> get props => [];
}

class RtnInputAttenuation4Decreased extends Setting18ControlEvent {
  const RtnInputAttenuation4Decreased();

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

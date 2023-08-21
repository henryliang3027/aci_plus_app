part of 'setting18_control_bloc.dart';

class Setting18ControlEvent extends Equatable {
  const Setting18ControlEvent();

  @override
  List<Object> get props => [];
}

class FwdInputAttenuationChanged extends Setting18ControlEvent {
  const FwdInputAttenuationChanged(this.fwdInputAttenuation);

  final double fwdInputAttenuation;

  @override
  List<Object> get props => [fwdInputAttenuation];
}

class FwdInputEQChanged extends Setting18ControlEvent {
  const FwdInputEQChanged(this.fwdInputEQ);

  final double fwdInputEQ;

  @override
  List<Object> get props => [fwdInputEQ];
}

class RtnInputAttenuation2Changed extends Setting18ControlEvent {
  const RtnInputAttenuation2Changed(this.rtnInputAttenuation2);

  final double rtnInputAttenuation2;

  @override
  List<Object> get props => [rtnInputAttenuation2];
}

class RtnInputAttenuation3Changed extends Setting18ControlEvent {
  const RtnInputAttenuation3Changed(this.rtnInputAttenuation3);

  final double rtnInputAttenuation3;

  @override
  List<Object> get props => [rtnInputAttenuation3];
}

class RtnInputAttenuation4Changed extends Setting18ControlEvent {
  const RtnInputAttenuation4Changed(this.rtnInputAttenuation4);

  final double rtnInputAttenuation4;

  @override
  List<Object> get props => [rtnInputAttenuation4];
}

class RtnOutputLevelAttenuationChanged extends Setting18ControlEvent {
  const RtnOutputLevelAttenuationChanged(this.rtnOutputLevelAttenuation);

  final double rtnOutputLevelAttenuation;

  @override
  List<Object> get props => [rtnOutputLevelAttenuation];
}

class RtnOutputEQChanged extends Setting18ControlEvent {
  const RtnOutputEQChanged(this.rtnOutputEQ);

  final double rtnOutputEQ;

  @override
  List<Object> get props => [rtnOutputEQ];
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

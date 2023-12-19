part of 'setting18_graph_module_bloc.dart';

abstract class Setting18GraphModuleEvent extends Equatable {
  const Setting18GraphModuleEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18GraphModuleEvent {
  const Initialized();

  @override
  List<Object> get props => [];
}

class DSVVA1Changed extends Setting18GraphModuleEvent {
  const DSVVA1Changed(this.dsVVA1);

  final String dsVVA1;

  @override
  List<Object> get props => [dsVVA1];
}

class DSVVA1Increased extends Setting18GraphModuleEvent {
  const DSVVA1Increased();

  @override
  List<Object> get props => [];
}

class DSVVA1Decreased extends Setting18GraphModuleEvent {
  const DSVVA1Decreased();

  @override
  List<Object> get props => [];
}

class DSSlope1Changed extends Setting18GraphModuleEvent {
  const DSSlope1Changed(this.dsSlope1);

  final String dsSlope1;

  @override
  List<Object> get props => [dsSlope1];
}

class DSSlope1Increased extends Setting18GraphModuleEvent {
  const DSSlope1Increased();

  @override
  List<Object> get props => [];
}

class DSSlope1Decreased extends Setting18GraphModuleEvent {
  const DSSlope1Decreased();

  @override
  List<Object> get props => [];
}

class USVCA1Changed extends Setting18GraphModuleEvent {
  const USVCA1Changed(this.usVCA1);

  final String usVCA1;

  @override
  List<Object> get props => [usVCA1];
}

class USVCA1Increased extends Setting18GraphModuleEvent {
  const USVCA1Increased();

  @override
  List<Object> get props => [];
}

class USVCA1Decreased extends Setting18GraphModuleEvent {
  const USVCA1Decreased();

  @override
  List<Object> get props => [];
}

class RtnInputAttenuation3Changed extends Setting18GraphModuleEvent {
  const RtnInputAttenuation3Changed(this.returnInputAttenuation3);

  final String returnInputAttenuation3;

  @override
  List<Object> get props => [returnInputAttenuation3];
}

class RtnInputAttenuation3Increased extends Setting18GraphModuleEvent {
  const RtnInputAttenuation3Increased();

  @override
  List<Object> get props => [];
}

class RtnInputAttenuation3Decreased extends Setting18GraphModuleEvent {
  const RtnInputAttenuation3Decreased();

  @override
  List<Object> get props => [];
}

class RtnInputAttenuation4Changed extends Setting18GraphModuleEvent {
  const RtnInputAttenuation4Changed(this.returnInputAttenuation4);

  final String returnInputAttenuation4;

  @override
  List<Object> get props => [returnInputAttenuation4];
}

class RtnInputAttenuation4Increased extends Setting18GraphModuleEvent {
  const RtnInputAttenuation4Increased();

  @override
  List<Object> get props => [];
}

class RtnInputAttenuation4Decreased extends Setting18GraphModuleEvent {
  const RtnInputAttenuation4Decreased();

  @override
  List<Object> get props => [];
}

class USVCA2Changed extends Setting18GraphModuleEvent {
  const USVCA2Changed(this.usVCA2);

  final String usVCA2;

  @override
  List<Object> get props => [usVCA2];
}

class USVCA2Increased extends Setting18GraphModuleEvent {
  const USVCA2Increased();

  @override
  List<Object> get props => [];
}

class USVCA2Decreased extends Setting18GraphModuleEvent {
  const USVCA2Decreased();

  @override
  List<Object> get props => [];
}

class EREQChanged extends Setting18GraphModuleEvent {
  const EREQChanged(this.eREQ);

  final String eREQ;

  @override
  List<Object> get props => [eREQ];
}

class EREQIncreased extends Setting18GraphModuleEvent {
  const EREQIncreased();

  @override
  List<Object> get props => [];
}

class EREQDecreased extends Setting18GraphModuleEvent {
  const EREQDecreased();

  @override
  List<Object> get props => [];
}

class RtnIngressSetting2Changed extends Setting18GraphModuleEvent {
  const RtnIngressSetting2Changed(this.returnIngressSetting2);

  final String returnIngressSetting2;

  @override
  List<Object> get props => [returnIngressSetting2];
}

class RtnIngressSetting3Changed extends Setting18GraphModuleEvent {
  const RtnIngressSetting3Changed(this.returnIngressSetting3);

  final String returnIngressSetting3;

  @override
  List<Object> get props => [returnIngressSetting3];
}

class RtnIngressSetting4Changed extends Setting18GraphModuleEvent {
  const RtnIngressSetting4Changed(this.returnIngressSetting4);

  final String returnIngressSetting4;

  @override
  List<Object> get props => [returnIngressSetting4];
}

class TGCCableLengthChanged extends Setting18GraphModuleEvent {
  const TGCCableLengthChanged(this.tgcCableLength);

  final String tgcCableLength;

  @override
  List<Object> get props => [tgcCableLength];
}

class DSVVA2Changed extends Setting18GraphModuleEvent {
  const DSVVA2Changed(this.dsVVA2);

  final String dsVVA2;

  @override
  List<Object> get props => [dsVVA2];
}

class DSSlope2Changed extends Setting18GraphModuleEvent {
  const DSSlope2Changed(this.dsSlope2);

  final String dsSlope2;

  @override
  List<Object> get props => [dsSlope2];
}

class DSVVA3Changed extends Setting18GraphModuleEvent {
  const DSVVA3Changed(this.dsVVA3);

  final String dsVVA3;

  @override
  List<Object> get props => [dsVVA3];
}

class DSVVA4Changed extends Setting18GraphModuleEvent {
  const DSVVA4Changed(this.dsVVA4);

  final String dsVVA4;

  @override
  List<Object> get props => [dsVVA4];
}

// class USTGCChanged extends Setting18GraphModuleEvent {
//   const USTGCChanged(this.usTGC);

//   final String usTGC;

//   @override
//   List<Object> get props => [usTGC];
// }

class SplitOptionChanged extends Setting18GraphModuleEvent {
  const SplitOptionChanged(this.splitOption);

  final String splitOption;

  @override
  List<Object> get props => [splitOption];
}

class FirstChannelLoadingFrequencyChanged extends Setting18GraphModuleEvent {
  const FirstChannelLoadingFrequencyChanged(this.firstChannelLoadingFrequency);

  final String firstChannelLoadingFrequency;

  @override
  List<Object> get props => [firstChannelLoadingFrequency];
}

class FirstChannelLoadingLevelChanged extends Setting18GraphModuleEvent {
  const FirstChannelLoadingLevelChanged(this.firstChannelLoadingLevel);

  final String firstChannelLoadingLevel;

  @override
  List<Object> get props => [firstChannelLoadingLevel];
}

class LastChannelLoadingFrequencyChanged extends Setting18GraphModuleEvent {
  const LastChannelLoadingFrequencyChanged(this.lastChannelLoadingFrequency);

  final String lastChannelLoadingFrequency;

  @override
  List<Object> get props => [lastChannelLoadingFrequency];
}

class LastChannelLoadingLevelChanged extends Setting18GraphModuleEvent {
  const LastChannelLoadingLevelChanged(this.lastChannelLoadingLevel);

  final String lastChannelLoadingLevel;

  @override
  List<Object> get props => [lastChannelLoadingLevel];
}

class PilotFrequencyModeChanged extends Setting18GraphModuleEvent {
  const PilotFrequencyModeChanged(this.pilotFrequencyMode);

  final String pilotFrequencyMode;

  @override
  List<Object> get props => [pilotFrequencyMode];
}

class PilotFrequency1Changed extends Setting18GraphModuleEvent {
  const PilotFrequency1Changed(this.pilotFrequency1);

  final String pilotFrequency1;

  @override
  List<Object> get props => [pilotFrequency1];
}

class PilotFrequency2Changed extends Setting18GraphModuleEvent {
  const PilotFrequency2Changed(this.pilotFrequency2);

  final String pilotFrequency2;

  @override
  List<Object> get props => [pilotFrequency2];
}

class SettingSubmitted extends Setting18GraphModuleEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

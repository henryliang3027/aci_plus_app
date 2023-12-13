part of 'setting18_graph_module_bloc.dart';

abstract class Setting18GraphModuleEvent extends Equatable {
  const Setting18GraphModuleEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18GraphModuleEvent {
  const Initialized(
      // {
      // required this.fwdInputAttenuation,
      // required this.fwdInputEQ,
      // required this.rtnInputAttenuation2,
      // required this.rtnInputAttenuation3,
      // required this.rtnInputAttenuation4,
      // required this.rtnOutputLevelAttenuation,
      // required this.rtnOutputEQ,
      // required this.rtnIngressSetting2,
      // required this.rtnIngressSetting3,
      // required this.rtnIngressSetting4,
      // required this.tgcCableLength,
      // required this.dsVVA2,
      // required this.dsSlope2,
      // required this.dsVVA3,
      // required this.dsVVA4,
      // required this.usTGC,
      // required this.splitOption,
      // required this.firstChannelLoadingFrequency,
      // required this.firstChannelLoadingLevel,
      // required this.lastChannelLoadingFrequency,
      // required this.lastChannelLoadingLevel,
      // required this.pilotFrequencyMode,
      // required this.pilotFrequency1,
      // required this.pilotFrequency2,
      // required this.manualModePilot1RFOutputPower,
      // required this.manualModePilot2RFOutputPower,
      // }
      );

  // final String fwdInputAttenuation;
  // final String fwdInputEQ;
  // final String rtnInputAttenuation2;
  // final String rtnInputAttenuation3;
  // final String rtnInputAttenuation4;
  // final String rtnOutputLevelAttenuation;
  // final String rtnOutputEQ;
  // final String rtnIngressSetting2;
  // final String rtnIngressSetting3;
  // final String rtnIngressSetting4;
  // final String tgcCableLength;
  // final String dsVVA2;
  // final String dsSlope2;
  // final String dsVVA3;
  // final String dsVVA4;
  // final String usTGC;
  // final String splitOption;
  // final String firstChannelLoadingFrequency;
  // final String firstChannelLoadingLevel;
  // final String lastChannelLoadingFrequency;
  // final String lastChannelLoadingLevel;
  // final String pilotFrequencyMode;
  // final String pilotFrequency1;
  // final String pilotFrequency2;
  // final String manualModePilot1RFOutputPower;
  // final String manualModePilot2RFOutputPower;

  @override
  List<Object> get props => [
        // fwdInputAttenuation,
        // fwdInputEQ,
        // rtnInputAttenuation2,
        // rtnInputAttenuation3,
        // rtnInputAttenuation4,
        // rtnOutputLevelAttenuation,
        // rtnOutputEQ,
        // rtnIngressSetting2,
        // rtnIngressSetting3,
        // rtnIngressSetting4,
        // tgcCableLength,
        // dsVVA2,
        // dsSlope2,
        // dsVVA3,
        // dsVVA4,
        // usTGC,
        // splitOption,
        // firstChannelLoadingFrequency,
        // firstChannelLoadingLevel,
        // lastChannelLoadingFrequency,
        // lastChannelLoadingLevel,
        // pilotFrequencyMode,
        // pilotFrequency1,
        // pilotFrequency2,
        // manualModePilot1RFOutputPower,
        // manualModePilot2RFOutputPower,
      ];
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

class FwdInputEQChanged extends Setting18GraphModuleEvent {
  const FwdInputEQChanged(this.fwdInputEQ);

  final String fwdInputEQ;

  @override
  List<Object> get props => [fwdInputEQ];
}

class FwdInputEQIncreased extends Setting18GraphModuleEvent {
  const FwdInputEQIncreased();

  @override
  List<Object> get props => [];
}

class FwdInputEQDecreased extends Setting18GraphModuleEvent {
  const FwdInputEQDecreased();

  @override
  List<Object> get props => [];
}

class RtnInputAttenuation2Changed extends Setting18GraphModuleEvent {
  const RtnInputAttenuation2Changed(this.rtnInputAttenuation2);

  final String rtnInputAttenuation2;

  @override
  List<Object> get props => [rtnInputAttenuation2];
}

class RtnInputAttenuation2Increased extends Setting18GraphModuleEvent {
  const RtnInputAttenuation2Increased();

  @override
  List<Object> get props => [];
}

class RtnInputAttenuation2Decreased extends Setting18GraphModuleEvent {
  const RtnInputAttenuation2Decreased();

  @override
  List<Object> get props => [];
}

class RtnInputAttenuation3Changed extends Setting18GraphModuleEvent {
  const RtnInputAttenuation3Changed(this.rtnInputAttenuation3);

  final String rtnInputAttenuation3;

  @override
  List<Object> get props => [rtnInputAttenuation3];
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
  const RtnInputAttenuation4Changed(this.rtnInputAttenuation4);

  final String rtnInputAttenuation4;

  @override
  List<Object> get props => [rtnInputAttenuation4];
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

class RtnOutputLevelAttenuationChanged extends Setting18GraphModuleEvent {
  const RtnOutputLevelAttenuationChanged(this.rtnOutputLevelAttenuation);

  final String rtnOutputLevelAttenuation;

  @override
  List<Object> get props => [rtnOutputLevelAttenuation];
}

class RtnOutputLevelAttenuationIncreased extends Setting18GraphModuleEvent {
  const RtnOutputLevelAttenuationIncreased();

  @override
  List<Object> get props => [];
}

class RtnOutputLevelAttenuationDecreased extends Setting18GraphModuleEvent {
  const RtnOutputLevelAttenuationDecreased();

  @override
  List<Object> get props => [];
}

class RtnOutputEQChanged extends Setting18GraphModuleEvent {
  const RtnOutputEQChanged(this.rtnOutputEQ);

  final String rtnOutputEQ;

  @override
  List<Object> get props => [rtnOutputEQ];
}

class RtnOutputEQIncreased extends Setting18GraphModuleEvent {
  const RtnOutputEQIncreased();

  @override
  List<Object> get props => [];
}

class RtnOutputEQDecreased extends Setting18GraphModuleEvent {
  const RtnOutputEQDecreased();

  @override
  List<Object> get props => [];
}

class RtnIngressSetting2Changed extends Setting18GraphModuleEvent {
  const RtnIngressSetting2Changed(this.rtnIngressSetting2);

  final String rtnIngressSetting2;

  @override
  List<Object> get props => [rtnIngressSetting2];
}

class RtnIngressSetting3Changed extends Setting18GraphModuleEvent {
  const RtnIngressSetting3Changed(this.rtnIngressSetting3);

  final String rtnIngressSetting3;

  @override
  List<Object> get props => [rtnIngressSetting3];
}

class RtnIngressSetting4Changed extends Setting18GraphModuleEvent {
  const RtnIngressSetting4Changed(this.rtnIngressSetting4);

  final String rtnIngressSetting4;

  @override
  List<Object> get props => [rtnIngressSetting4];
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

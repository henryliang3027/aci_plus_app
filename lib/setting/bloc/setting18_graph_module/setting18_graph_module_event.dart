part of 'setting18_graph_module_bloc.dart';

abstract class Setting18GraphModuleEvent extends Equatable {
  const Setting18GraphModuleEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18GraphModuleEvent {
  const Initialized({this.useCache = true});

  final bool useCache;

  @override
  List<Object> get props => [useCache];
}

class ControlItemChanged extends Setting18GraphModuleEvent {
  const ControlItemChanged({
    required this.dataKey,
    required this.value,
  });

  final DataKey dataKey;
  final String value;
}

// class DSVVA1Changed extends Setting18GraphModuleEvent {
//   const DSVVA1Changed({required this.dsVVA1});

//   final String dsVVA1;

//   @override
//   List<Object> get props => [dsVVA1];
// }

// class DSVVA4Changed extends Setting18GraphModuleEvent {
//   const DSVVA4Changed({required this.dsVVA4});

//   final String dsVVA4;

//   @override
//   List<Object> get props => [dsVVA4];
// }

// class DSVVA5Changed extends Setting18GraphModuleEvent {
//   const DSVVA5Changed({required this.dsVVA5});

//   final String dsVVA5;

//   @override
//   List<Object> get props => [dsVVA5];
// }

// class DSSlope1Changed extends Setting18GraphModuleEvent {
//   const DSSlope1Changed({required this.dsSlope1});

//   final String dsSlope1;

//   @override
//   List<Object> get props => [dsSlope1];
// }

// class DSSlope3Changed extends Setting18GraphModuleEvent {
//   const DSSlope3Changed({required this.dsSlope3});

//   final String dsSlope3;

//   @override
//   List<Object> get props => [dsSlope3];
// }

// class DSSlope4Changed extends Setting18GraphModuleEvent {
//   const DSSlope4Changed({required this.dsSlope4});

//   final String dsSlope4;

//   @override
//   List<Object> get props => [dsSlope4];
// }

// class USVCA1Changed extends Setting18GraphModuleEvent {
//   const USVCA1Changed({required this.usVCA1});

//   final String usVCA1;

//   @override
//   List<Object> get props => [usVCA1];
// }

// class USVCA2Changed extends Setting18GraphModuleEvent {
//   const USVCA2Changed({required this.usVCA2});

//   final String usVCA2;

//   @override
//   List<Object> get props => [usVCA2];
// }

// class USVCA3Changed extends Setting18GraphModuleEvent {
//   const USVCA3Changed({required this.usVCA3});

//   final String usVCA3;

//   @override
//   List<Object> get props => [usVCA3];
// }

// class USVCA4Changed extends Setting18GraphModuleEvent {
//   const USVCA4Changed({required this.usVCA4});

//   final String usVCA4;

//   @override
//   List<Object> get props => [usVCA4];
// }

// class EREQChanged extends Setting18GraphModuleEvent {
//   const EREQChanged({required this.eREQ});

//   final String eREQ;

//   @override
//   List<Object> get props => [eREQ];
// }

// class RtnIngressSetting2Changed extends Setting18GraphModuleEvent {
//   const RtnIngressSetting2Changed({required this.returnIngressSetting2});

//   final String returnIngressSetting2;

//   @override
//   List<Object> get props => [returnIngressSetting2];
// }

// class RtnIngressSetting3Changed extends Setting18GraphModuleEvent {
//   const RtnIngressSetting3Changed({required this.returnIngressSetting3});

//   final String returnIngressSetting3;

//   @override
//   List<Object> get props => [returnIngressSetting3];
// }

// class RtnIngressSetting4Changed extends Setting18GraphModuleEvent {
//   const RtnIngressSetting4Changed({required this.returnIngressSetting4});

//   final String returnIngressSetting4;

//   @override
//   List<Object> get props => [returnIngressSetting4];
// }

// class TGCCableLengthChanged extends Setting18GraphModuleEvent {
//   const TGCCableLengthChanged({required this.tgcCableLength});

//   final String tgcCableLength;

//   @override
//   List<Object> get props => [tgcCableLength];
// }

// class USTGCChanged extends Setting18GraphModuleEvent {
//   const USTGCChanged(this.usTGC);

//   final String usTGC;

//   @override
//   List<Object> get props => [usTGC];
// }

// class SplitOptionChanged extends Setting18GraphModuleEvent {
//   const SplitOptionChanged({required this.splitOption});

//   final String splitOption;

//   @override
//   List<Object> get props => [splitOption];
// }

class FirstChannelLoadingFrequencyChanged extends Setting18GraphModuleEvent {
  const FirstChannelLoadingFrequencyChanged({
    required this.firstChannelLoadingFrequency,
    required this.currentDetectedSplitOption,
  });

  final String firstChannelLoadingFrequency;
  final String currentDetectedSplitOption;

  @override
  List<Object> get props => [
        firstChannelLoadingFrequency,
        currentDetectedSplitOption,
      ];
}

class FirstChannelLoadingLevelChanged extends Setting18GraphModuleEvent {
  const FirstChannelLoadingLevelChanged(
      {required this.firstChannelLoadingLevel});

  final String firstChannelLoadingLevel;

  @override
  List<Object> get props => [firstChannelLoadingLevel];
}

class LastChannelLoadingFrequencyChanged extends Setting18GraphModuleEvent {
  const LastChannelLoadingFrequencyChanged(
      {required this.lastChannelLoadingFrequency});

  final String lastChannelLoadingFrequency;

  @override
  List<Object> get props => [lastChannelLoadingFrequency];
}

class LastChannelLoadingLevelChanged extends Setting18GraphModuleEvent {
  const LastChannelLoadingLevelChanged({required this.lastChannelLoadingLevel});

  final String lastChannelLoadingLevel;

  @override
  List<Object> get props => [lastChannelLoadingLevel];
}

class PilotFrequencyModeChanged extends Setting18GraphModuleEvent {
  const PilotFrequencyModeChanged({required this.pilotFrequencyMode});

  final String pilotFrequencyMode;

  @override
  List<Object> get props => [pilotFrequencyMode];
}

class PilotFrequency1Changed extends Setting18GraphModuleEvent {
  const PilotFrequency1Changed({required this.pilotFrequency1});

  final String pilotFrequency1;

  @override
  List<Object> get props => [pilotFrequency1];
}

class PilotFrequency2Changed extends Setting18GraphModuleEvent {
  const PilotFrequency2Changed({required this.pilotFrequency2});

  final String pilotFrequency2;

  @override
  List<Object> get props => [pilotFrequency2];
}

class AGCModeChanged extends Setting18GraphModuleEvent {
  const AGCModeChanged(this.agcMode);

  final String agcMode;

  @override
  List<Object> get props => [agcMode];
}

class ALCModeChanged extends Setting18GraphModuleEvent {
  const ALCModeChanged(this.alcMode);

  final String alcMode;

  @override
  List<Object> get props => [alcMode];
}

class SettingSubmitted extends Setting18GraphModuleEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

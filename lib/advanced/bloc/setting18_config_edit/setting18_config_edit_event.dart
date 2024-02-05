part of 'setting18_config_edit_bloc.dart';

abstract class Setting18ConfigEditEvent extends Equatable {
  const Setting18ConfigEditEvent();

  @override
  List<Object> get props => [];
}

class ConfigIntitialized extends Setting18ConfigEditEvent {
  const ConfigIntitialized();

  @override
  List<Object> get props => [];
}

class ConfigSaved extends Setting18ConfigEditEvent {
  const ConfigSaved();

  @override
  List<Object> get props => [];
}

class ConfigSavedAndSubmitted extends Setting18ConfigEditEvent {
  const ConfigSavedAndSubmitted();

  @override
  List<Object> get props => [];
}

// class QRCodeDataScanned extends Setting18ConfigEditEvent {
//   const QRCodeDataScanned({required this.rawData});

//   final String rawData;

//   @override
//   List<Object> get props => [
//         rawData,
//       ];
// }

// class QRCodeDataGenerated extends Setting18ConfigEditEvent {
//   const QRCodeDataGenerated();

//   @override
//   List<Object> get props => [];
// }

class FirstChannelLoadingFrequencyChanged extends Setting18ConfigEditEvent {
  const FirstChannelLoadingFrequencyChanged({
    required this.firstChannelLoadingFrequency,
    required this.currentDetectedSplitOption,
  });

  final String firstChannelLoadingFrequency;
  final int currentDetectedSplitOption;

  @override
  List<Object> get props => [
        firstChannelLoadingFrequency,
        currentDetectedSplitOption,
      ];
}

class FirstChannelLoadingLevelChanged extends Setting18ConfigEditEvent {
  const FirstChannelLoadingLevelChanged(this.firstChannelLoadingLevel);

  final String firstChannelLoadingLevel;

  @override
  List<Object> get props => [firstChannelLoadingLevel];
}

class LastChannelLoadingFrequencyChanged extends Setting18ConfigEditEvent {
  const LastChannelLoadingFrequencyChanged(this.lastChannelLoadingFrequency);

  final String lastChannelLoadingFrequency;

  @override
  List<Object> get props => [lastChannelLoadingFrequency];
}

class LastChannelLoadingLevelChanged extends Setting18ConfigEditEvent {
  const LastChannelLoadingLevelChanged(this.lastChannelLoadingLevel);

  final String lastChannelLoadingLevel;

  @override
  List<Object> get props => [lastChannelLoadingLevel];
}

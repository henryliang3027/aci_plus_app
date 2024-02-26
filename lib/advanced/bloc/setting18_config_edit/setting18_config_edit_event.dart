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

class ConfigAdded extends Setting18ConfigEditEvent {
  const ConfigAdded();

  @override
  List<Object> get props => [];
}

class ConfigUpdated extends Setting18ConfigEditEvent {
  const ConfigUpdated();

  @override
  List<Object> get props => [];
}

class ConfigSubmitted extends Setting18ConfigEditEvent {
  const ConfigSubmitted();

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

class NameChanged extends Setting18ConfigEditEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class SplitOptionChanged extends Setting18ConfigEditEvent {
  const SplitOptionChanged(this.splitOption);

  final String splitOption;

  @override
  List<Object> get props => [splitOption];
}

class FirstChannelLoadingFrequencyChanged extends Setting18ConfigEditEvent {
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

part of 'setting18_forward_control_bloc.dart';

sealed class Setting18ForwardControlEvent extends Equatable {
  const Setting18ForwardControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18ForwardControlEvent {
  const Initialized({this.useCache = true});

  final bool useCache;

  @override
  List<Object> get props => [useCache];
}

class ResetForwardValuesRequested extends Setting18ForwardControlEvent {
  const ResetForwardValuesRequested();

  @override
  List<Object> get props => [];
}

class ControlItemChanged extends Setting18ForwardControlEvent {
  const ControlItemChanged({
    required this.dataKey,
    required this.value,
  });

  final DataKey dataKey;
  final String value;
}

// class FirstChannelLoadingFrequencyChanged extends Setting18ForwardControlEvent {
//   const FirstChannelLoadingFrequencyChanged({
//     required this.firstChannelLoadingFrequency,
//     required this.currentDetectedSplitOption,
//   });

//   final String firstChannelLoadingFrequency;
//   final String currentDetectedSplitOption;

//   @override
//   List<Object> get props => [
//         firstChannelLoadingFrequency,
//         currentDetectedSplitOption,
//       ];
// }

class FirstChannelLoadingLevelChanged extends Setting18ForwardControlEvent {
  const FirstChannelLoadingLevelChanged(this.firstChannelLoadingLevel);

  final String firstChannelLoadingLevel;

  @override
  List<Object> get props => [firstChannelLoadingLevel];
}

// class LastChannelLoadingFrequencyChanged extends Setting18ForwardControlEvent {
//   const LastChannelLoadingFrequencyChanged(this.lastChannelLoadingFrequency);

//   final String lastChannelLoadingFrequency;

//   @override
//   List<Object> get props => [lastChannelLoadingFrequency];
// }

class LastChannelLoadingLevelChanged extends Setting18ForwardControlEvent {
  const LastChannelLoadingLevelChanged(this.lastChannelLoadingLevel);

  final String lastChannelLoadingLevel;

  @override
  List<Object> get props => [lastChannelLoadingLevel];
}

class EditModeEnabled extends Setting18ForwardControlEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18ForwardControlEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18ForwardControlEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

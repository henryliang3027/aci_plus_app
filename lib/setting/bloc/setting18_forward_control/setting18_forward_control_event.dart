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

class DSVVA1Changed extends Setting18ForwardControlEvent {
  const DSVVA1Changed({
    required this.dsVVA1,
  });

  final String dsVVA1;

  @override
  List<Object> get props => [
        dsVVA1,
      ];
}

class DSVVA2Changed extends Setting18ForwardControlEvent {
  const DSVVA2Changed({
    required this.dsVVA2,
  });

  final String dsVVA2;

  @override
  List<Object> get props => [
        dsVVA2,
      ];
}

class DSVVA3Changed extends Setting18ForwardControlEvent {
  const DSVVA3Changed(this.dsVVA3);

  final String dsVVA3;

  @override
  List<Object> get props => [dsVVA3];
}

class DSVVA4Changed extends Setting18ForwardControlEvent {
  const DSVVA4Changed({
    required this.dsVVA4,
  });

  final String dsVVA4;

  @override
  List<Object> get props => [
        dsVVA4,
      ];
}

class DSVVA5Changed extends Setting18ForwardControlEvent {
  const DSVVA5Changed({
    required this.dsVVA5,
  });

  final String dsVVA5;

  @override
  List<Object> get props => [
        dsVVA5,
      ];
}

class DSSlope1Changed extends Setting18ForwardControlEvent {
  const DSSlope1Changed({
    required this.dsSlope1,
  });

  final String dsSlope1;

  @override
  List<Object> get props => [
        dsSlope1,
      ];
}

class DSSlope2Changed extends Setting18ForwardControlEvent {
  const DSSlope2Changed({
    required this.dsSlope2,
  });

  final String dsSlope2;

  @override
  List<Object> get props => [
        dsSlope2,
      ];
}

class DSSlope3Changed extends Setting18ForwardControlEvent {
  const DSSlope3Changed({
    required this.dsSlope3,
  });

  final String dsSlope3;

  @override
  List<Object> get props => [
        dsSlope3,
      ];
}

class DSSlope4Changed extends Setting18ForwardControlEvent {
  const DSSlope4Changed({
    required this.dsSlope4,
  });

  final String dsSlope4;

  @override
  List<Object> get props => [
        dsSlope4,
      ];
}

class TGCCableLengthChanged extends Setting18ForwardControlEvent {
  const TGCCableLengthChanged(this.tgcCableLength);

  final String tgcCableLength;

  @override
  List<Object> get props => [tgcCableLength];
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

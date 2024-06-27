part of 'setting18_ccor_node_forward_control_bloc.dart';

sealed class Setting18CCorNodeForwardControlEvent extends Equatable {
  const Setting18CCorNodeForwardControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18CCorNodeForwardControlEvent {
  const Initialized();

  @override
  List<Object> get props => [];
}

class DSVVA1Changed extends Setting18CCorNodeForwardControlEvent {
  const DSVVA1Changed({
    required this.dsVVA1,
  });

  final String dsVVA1;
  @override
  List<Object> get props => [
        dsVVA1,
      ];
}

class DSVVA3Changed extends Setting18CCorNodeForwardControlEvent {
  const DSVVA3Changed({
    required this.dsVVA3,
  });

  final String dsVVA3;

  @override
  List<Object> get props => [
        dsVVA3,
      ];
}

class DSVVA4Changed extends Setting18CCorNodeForwardControlEvent {
  const DSVVA4Changed({
    required this.dsVVA4,
  });

  final String dsVVA4;

  @override
  List<Object> get props => [
        dsVVA4,
      ];
}

class DSVVA6Changed extends Setting18CCorNodeForwardControlEvent {
  const DSVVA6Changed({
    required this.dsVVA6,
  });

  final String dsVVA6;

  @override
  List<Object> get props => [
        dsVVA6,
      ];
}

class DSInSlope1Changed extends Setting18CCorNodeForwardControlEvent {
  const DSInSlope1Changed({
    required this.dsInSlope1,
  });

  final String dsInSlope1;

  @override
  List<Object> get props => [
        dsInSlope1,
      ];
}

class DSInSlope3Changed extends Setting18CCorNodeForwardControlEvent {
  const DSInSlope3Changed({
    required this.dsInSlope3,
  });

  final String dsInSlope3;

  @override
  List<Object> get props => [
        dsInSlope3,
      ];
}

class DSInSlope4Changed extends Setting18CCorNodeForwardControlEvent {
  const DSInSlope4Changed({
    required this.dsInSlope4,
  });

  final String dsInSlope4;

  @override
  List<Object> get props => [
        dsInSlope4,
      ];
}

class DSInSlope6Changed extends Setting18CCorNodeForwardControlEvent {
  const DSInSlope6Changed({
    required this.dsInSlope6,
  });

  final String dsInSlope6;

  @override
  List<Object> get props => [
        dsInSlope6,
      ];
}

class DSOutSlope1Changed extends Setting18CCorNodeForwardControlEvent {
  const DSOutSlope1Changed({
    required this.dsOutSlope1,
  });

  final String dsOutSlope1;

  @override
  List<Object> get props => [
        dsOutSlope1,
      ];
}

class DSOutSlope3Changed extends Setting18CCorNodeForwardControlEvent {
  const DSOutSlope3Changed({
    required this.dsOutSlope3,
  });

  final String dsOutSlope3;

  @override
  List<Object> get props => [
        dsOutSlope3,
      ];
}

class DSOutSlope4Changed extends Setting18CCorNodeForwardControlEvent {
  const DSOutSlope4Changed({
    required this.dsOutSlope4,
  });

  final String dsOutSlope4;

  @override
  List<Object> get props => [
        dsOutSlope4,
      ];
}

class DSOutSlope6Changed extends Setting18CCorNodeForwardControlEvent {
  const DSOutSlope6Changed({
    required this.dsOutSlope6,
  });

  final String dsOutSlope6;

  @override
  List<Object> get props => [
        dsOutSlope6,
      ];
}

class BiasCurrent1Changed extends Setting18CCorNodeForwardControlEvent {
  const BiasCurrent1Changed({
    required this.biasCurrent1,
    required this.maxValue,
    required this.minValue,
  });

  final String biasCurrent1;
  final double maxValue;
  final double minValue;

  @override
  List<Object> get props => [
        biasCurrent1,
        maxValue,
        minValue,
      ];
}

class BiasCurrent3Changed extends Setting18CCorNodeForwardControlEvent {
  const BiasCurrent3Changed({
    required this.biasCurrent3,
    required this.maxValue,
    required this.minValue,
  });

  final String biasCurrent3;
  final double maxValue;
  final double minValue;

  @override
  List<Object> get props => [
        biasCurrent3,
        maxValue,
        minValue,
      ];
}

class BiasCurrent4Changed extends Setting18CCorNodeForwardControlEvent {
  const BiasCurrent4Changed({
    required this.biasCurrent4,
    required this.maxValue,
    required this.minValue,
  });

  final String biasCurrent4;
  final double maxValue;
  final double minValue;

  @override
  List<Object> get props => [
        biasCurrent4,
        maxValue,
        minValue,
      ];
}

class BiasCurrent6Changed extends Setting18CCorNodeForwardControlEvent {
  const BiasCurrent6Changed({
    required this.biasCurrent6,
    required this.maxValue,
    required this.minValue,
  });

  final String biasCurrent6;
  final double maxValue;
  final double minValue;

  @override
  List<Object> get props => [
        biasCurrent6,
        maxValue,
        minValue,
      ];
}

class EditModeEnabled extends Setting18CCorNodeForwardControlEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18CCorNodeForwardControlEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18CCorNodeForwardControlEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

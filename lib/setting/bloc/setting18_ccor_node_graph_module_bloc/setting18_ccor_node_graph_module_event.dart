part of 'setting18_ccor_node_graph_module_bloc.dart';

abstract class Setting18CCorNodeGraphModuleEvent extends Equatable {
  const Setting18CCorNodeGraphModuleEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18CCorNodeGraphModuleEvent {
  const Initialized();

  @override
  List<Object> get props => [];
}

class DSVVA1Changed extends Setting18CCorNodeGraphModuleEvent {
  const DSVVA1Changed({
    required this.dsVVA1,
  });

  final String dsVVA1;
  @override
  List<Object> get props => [
        dsVVA1,
      ];
}

class DSVVA3Changed extends Setting18CCorNodeGraphModuleEvent {
  const DSVVA3Changed({
    required this.dsVVA3,
  });

  final String dsVVA3;

  @override
  List<Object> get props => [
        dsVVA3,
      ];
}

class DSVVA4Changed extends Setting18CCorNodeGraphModuleEvent {
  const DSVVA4Changed({
    required this.dsVVA4,
  });

  final String dsVVA4;

  @override
  List<Object> get props => [
        dsVVA4,
      ];
}

class DSVVA6Changed extends Setting18CCorNodeGraphModuleEvent {
  const DSVVA6Changed({
    required this.dsVVA6,
  });

  final String dsVVA6;

  @override
  List<Object> get props => [
        dsVVA6,
      ];
}

class DSInSlope1Changed extends Setting18CCorNodeGraphModuleEvent {
  const DSInSlope1Changed({
    required this.dsInSlope1,
  });

  final String dsInSlope1;

  @override
  List<Object> get props => [
        dsInSlope1,
      ];
}

class DSInSlope3Changed extends Setting18CCorNodeGraphModuleEvent {
  const DSInSlope3Changed({
    required this.dsInSlope3,
  });

  final String dsInSlope3;

  @override
  List<Object> get props => [
        dsInSlope3,
      ];
}

class DSInSlope4Changed extends Setting18CCorNodeGraphModuleEvent {
  const DSInSlope4Changed({
    required this.dsInSlope4,
  });

  final String dsInSlope4;

  @override
  List<Object> get props => [
        dsInSlope4,
      ];
}

class DSInSlope6Changed extends Setting18CCorNodeGraphModuleEvent {
  const DSInSlope6Changed({
    required this.dsInSlope6,
  });

  final String dsInSlope6;

  @override
  List<Object> get props => [
        dsInSlope6,
      ];
}

class DSOutSlope1Changed extends Setting18CCorNodeGraphModuleEvent {
  const DSOutSlope1Changed({
    required this.dsOutSlope1,
  });

  final String dsOutSlope1;

  @override
  List<Object> get props => [
        dsOutSlope1,
      ];
}

class DSOutSlope3Changed extends Setting18CCorNodeGraphModuleEvent {
  const DSOutSlope3Changed({
    required this.dsOutSlope3,
  });

  final String dsOutSlope3;

  @override
  List<Object> get props => [
        dsOutSlope3,
      ];
}

class DSOutSlope4Changed extends Setting18CCorNodeGraphModuleEvent {
  const DSOutSlope4Changed({
    required this.dsOutSlope4,
  });

  final String dsOutSlope4;

  @override
  List<Object> get props => [
        dsOutSlope4,
      ];
}

class DSOutSlope6Changed extends Setting18CCorNodeGraphModuleEvent {
  const DSOutSlope6Changed({
    required this.dsOutSlope6,
  });

  final String dsOutSlope6;

  @override
  List<Object> get props => [
        dsOutSlope6,
      ];
}

class BiasCurrent1Changed extends Setting18CCorNodeGraphModuleEvent {
  const BiasCurrent1Changed({
    required this.biasCurrent1,
  });

  final String biasCurrent1;

  @override
  List<Object> get props => [
        biasCurrent1,
      ];
}

class BiasCurrent3Changed extends Setting18CCorNodeGraphModuleEvent {
  const BiasCurrent3Changed({
    required this.biasCurrent3,
  });

  final String biasCurrent3;

  @override
  List<Object> get props => [
        biasCurrent3,
      ];
}

class BiasCurrent4Changed extends Setting18CCorNodeGraphModuleEvent {
  const BiasCurrent4Changed({
    required this.biasCurrent4,
  });

  final String biasCurrent4;

  @override
  List<Object> get props => [
        biasCurrent4,
      ];
}

class BiasCurrent6Changed extends Setting18CCorNodeGraphModuleEvent {
  const BiasCurrent6Changed({
    required this.biasCurrent6,
  });

  final String biasCurrent6;

  @override
  List<Object> get props => [
        biasCurrent6,
      ];
}

class USVCA1Changed extends Setting18CCorNodeGraphModuleEvent {
  const USVCA1Changed({
    required this.usVCA1,
  });

  final String usVCA1;

  @override
  List<Object> get props => [
        usVCA1,
      ];
}

class USVCA3Changed extends Setting18CCorNodeGraphModuleEvent {
  const USVCA3Changed({
    required this.usVCA3,
  });

  final String usVCA3;

  @override
  List<Object> get props => [
        usVCA3,
      ];
}

class USVCA4Changed extends Setting18CCorNodeGraphModuleEvent {
  const USVCA4Changed({
    required this.usVCA4,
  });

  final String usVCA4;

  @override
  List<Object> get props => [
        usVCA4,
      ];
}

class USVCA6Changed extends Setting18CCorNodeGraphModuleEvent {
  const USVCA6Changed({
    required this.usVCA6,
  });

  final String usVCA6;

  @override
  List<Object> get props => [
        usVCA6,
      ];
}

class ReturnIngressSetting1Changed extends Setting18CCorNodeGraphModuleEvent {
  const ReturnIngressSetting1Changed(this.returnIngressSetting1);

  final String returnIngressSetting1;

  @override
  List<Object> get props => [returnIngressSetting1];
}

class ReturnIngressSetting3Changed extends Setting18CCorNodeGraphModuleEvent {
  const ReturnIngressSetting3Changed(this.returnIngressSetting3);

  final String returnIngressSetting3;

  @override
  List<Object> get props => [returnIngressSetting3];
}

class ReturnIngressSetting4Changed extends Setting18CCorNodeGraphModuleEvent {
  const ReturnIngressSetting4Changed(this.returnIngressSetting4);

  final String returnIngressSetting4;

  @override
  List<Object> get props => [returnIngressSetting4];
}

class ReturnIngressSetting6Changed extends Setting18CCorNodeGraphModuleEvent {
  const ReturnIngressSetting6Changed(this.returnIngressSetting6);

  final String returnIngressSetting6;

  @override
  List<Object> get props => [returnIngressSetting6];
}

class SettingSubmitted extends Setting18CCorNodeGraphModuleEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

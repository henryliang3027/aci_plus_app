part of 'setting18_ccor_node_control_bloc.dart';

abstract class Setting18CCorNodeControlEvent extends Equatable {
  const Setting18CCorNodeControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18CCorNodeControlEvent {
  const Initialized();

  @override
  List<Object> get props => [];
}

class DSVVA1Changed extends Setting18CCorNodeControlEvent {
  const DSVVA1Changed({
    required this.dsVVA1,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsVVA1;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsVVA1,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSVVA1Increased extends Setting18CCorNodeControlEvent {
  const DSVVA1Increased({
    required this.maxValue,
    required this.textEditingController,
  });

  final double maxValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        maxValue,
        textEditingController,
      ];
}

class DSVVA1Decreased extends Setting18CCorNodeControlEvent {
  const DSVVA1Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        minValue,
        textEditingController,
      ];
}

class DSVVA3Changed extends Setting18CCorNodeControlEvent {
  const DSVVA3Changed({
    required this.dsVVA3,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsVVA3;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsVVA3,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSVVA3Increased extends Setting18CCorNodeControlEvent {
  const DSVVA3Increased({
    required this.maxValue,
    required this.textEditingController,
  });

  final double maxValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        maxValue,
        textEditingController,
      ];
}

class DSVVA3Decreased extends Setting18CCorNodeControlEvent {
  const DSVVA3Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        minValue,
        textEditingController,
      ];
}

class DSVVA4Changed extends Setting18CCorNodeControlEvent {
  const DSVVA4Changed({
    required this.dsVVA4,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsVVA4;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsVVA4,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSVVA4Increased extends Setting18CCorNodeControlEvent {
  const DSVVA4Increased({
    required this.maxValue,
    required this.textEditingController,
  });

  final double maxValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        maxValue,
        textEditingController,
      ];
}

class DSVVA4Decreased extends Setting18CCorNodeControlEvent {
  const DSVVA4Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        minValue,
        textEditingController,
      ];
}

class DSVVA6Changed extends Setting18CCorNodeControlEvent {
  const DSVVA6Changed({
    required this.dsVVA6,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsVVA6;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsVVA6,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSVVA6Increased extends Setting18CCorNodeControlEvent {
  const DSVVA6Increased({
    required this.maxValue,
    required this.textEditingController,
  });

  final double maxValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        maxValue,
        textEditingController,
      ];
}

class DSVVA6Decreased extends Setting18CCorNodeControlEvent {
  const DSVVA6Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        minValue,
        textEditingController,
      ];
}

class DSInSlope1Changed extends Setting18CCorNodeControlEvent {
  const DSInSlope1Changed({
    required this.dsInSlope1,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsInSlope1;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsInSlope1,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSInSlope1Increased extends Setting18CCorNodeControlEvent {
  const DSInSlope1Increased({
    required this.maxValue,
    required this.textEditingController,
  });

  final double maxValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        maxValue,
        textEditingController,
      ];
}

class DSInSlope1Decreased extends Setting18CCorNodeControlEvent {
  const DSInSlope1Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        minValue,
        textEditingController,
      ];
}

class DSInSlope3Changed extends Setting18CCorNodeControlEvent {
  const DSInSlope3Changed({
    required this.dsInSlope3,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsInSlope3;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsInSlope3,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSInSlope3Increased extends Setting18CCorNodeControlEvent {
  const DSInSlope3Increased({
    required this.maxValue,
    required this.textEditingController,
  });

  final double maxValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        maxValue,
        textEditingController,
      ];
}

class DSInSlope3Decreased extends Setting18CCorNodeControlEvent {
  const DSInSlope3Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        minValue,
        textEditingController,
      ];
}

class DSInSlope4Changed extends Setting18CCorNodeControlEvent {
  const DSInSlope4Changed({
    required this.dsInSlope4,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsInSlope4;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsInSlope4,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSInSlope4Increased extends Setting18CCorNodeControlEvent {
  const DSInSlope4Increased({
    required this.maxValue,
    required this.textEditingController,
  });

  final double maxValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        maxValue,
        textEditingController,
      ];
}

class DSInSlope4Decreased extends Setting18CCorNodeControlEvent {
  const DSInSlope4Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        minValue,
        textEditingController,
      ];
}

class DSInSlope6Changed extends Setting18CCorNodeControlEvent {
  const DSInSlope6Changed({
    required this.dsInSlope6,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsInSlope6;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsInSlope6,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSInSlope6Increased extends Setting18CCorNodeControlEvent {
  const DSInSlope6Increased({
    required this.maxValue,
    required this.textEditingController,
  });

  final double maxValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        maxValue,
        textEditingController,
      ];
}

class DSInSlope6Decreased extends Setting18CCorNodeControlEvent {
  const DSInSlope6Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        minValue,
        textEditingController,
      ];
}

class USVCA1Changed extends Setting18CCorNodeControlEvent {
  const USVCA1Changed({
    required this.usVCA1,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String usVCA1;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        usVCA1,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class USVCA1Increased extends Setting18CCorNodeControlEvent {
  const USVCA1Increased({
    required this.maxValue,
    required this.textEditingController,
  });

  final double maxValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        maxValue,
        textEditingController,
      ];
}

class USVCA1Decreased extends Setting18CCorNodeControlEvent {
  const USVCA1Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        minValue,
        textEditingController,
      ];
}

class USVCA3Changed extends Setting18CCorNodeControlEvent {
  const USVCA3Changed({
    required this.usVCA3,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String usVCA3;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        usVCA3,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class USVCA3Increased extends Setting18CCorNodeControlEvent {
  const USVCA3Increased({
    required this.maxValue,
    required this.textEditingController,
  });

  final double maxValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        maxValue,
        textEditingController,
      ];
}

class USVCA3Decreased extends Setting18CCorNodeControlEvent {
  const USVCA3Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        minValue,
        textEditingController,
      ];
}

class USVCA4Changed extends Setting18CCorNodeControlEvent {
  const USVCA4Changed({
    required this.usVCA4,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String usVCA4;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        usVCA4,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class USVCA4Increased extends Setting18CCorNodeControlEvent {
  const USVCA4Increased({
    required this.maxValue,
    required this.textEditingController,
  });

  final double maxValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        maxValue,
        textEditingController,
      ];
}

class USVCA4Decreased extends Setting18CCorNodeControlEvent {
  const USVCA4Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        minValue,
        textEditingController,
      ];
}

class USVCA6Changed extends Setting18CCorNodeControlEvent {
  const USVCA6Changed({
    required this.usVCA6,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String usVCA6;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        usVCA6,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class USVCA6Increased extends Setting18CCorNodeControlEvent {
  const USVCA6Increased({
    required this.maxValue,
    required this.textEditingController,
  });

  final double maxValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        maxValue,
        textEditingController,
      ];
}

class USVCA6Decreased extends Setting18CCorNodeControlEvent {
  const USVCA6Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [
        minValue,
        textEditingController,
      ];
}

class ReturnIngressSetting1Changed extends Setting18CCorNodeControlEvent {
  const ReturnIngressSetting1Changed(this.returnIngressSetting1);

  final String returnIngressSetting1;

  @override
  List<Object> get props => [returnIngressSetting1];
}

class ReturnIngressSetting3Changed extends Setting18CCorNodeControlEvent {
  const ReturnIngressSetting3Changed(this.returnIngressSetting3);

  final String returnIngressSetting3;

  @override
  List<Object> get props => [returnIngressSetting3];
}

class ReturnIngressSetting4Changed extends Setting18CCorNodeControlEvent {
  const ReturnIngressSetting4Changed(this.returnIngressSetting4);

  final String returnIngressSetting4;

  @override
  List<Object> get props => [returnIngressSetting4];
}

class ReturnIngressSetting6Changed extends Setting18CCorNodeControlEvent {
  const ReturnIngressSetting6Changed(this.returnIngressSetting6);

  final String returnIngressSetting6;

  @override
  List<Object> get props => [returnIngressSetting6];
}

class EditModeEnabled extends Setting18CCorNodeControlEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18CCorNodeControlEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18CCorNodeControlEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

part of 'setting18_control_bloc.dart';

class Setting18ControlEvent extends Equatable {
  const Setting18ControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18ControlEvent {
  const Initialized();

  @override
  List<Object> get props => [];
}

class DSVVA1Changed extends Setting18ControlEvent {
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

class DSVVA1Increased extends Setting18ControlEvent {
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

class DSVVA1Decreased extends Setting18ControlEvent {
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

class DSSlope1Changed extends Setting18ControlEvent {
  const DSSlope1Changed({
    required this.dsSlope1,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsSlope1;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsSlope1,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSSlope1Increased extends Setting18ControlEvent {
  const DSSlope1Increased({
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

class DSSlope1Decreased extends Setting18ControlEvent {
  const DSSlope1Decreased({
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

class USVCA1Changed extends Setting18ControlEvent {
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

class USVCA1Increased extends Setting18ControlEvent {
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

class USVCA1Decreased extends Setting18ControlEvent {
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

class USVCA3Changed extends Setting18ControlEvent {
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

class USVCA3Increased extends Setting18ControlEvent {
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

class USVCA3Decreased extends Setting18ControlEvent {
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

class USVCA4Changed extends Setting18ControlEvent {
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

class USVCA4Increased extends Setting18ControlEvent {
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

class USVCA4Decreased extends Setting18ControlEvent {
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

class USVCA2Changed extends Setting18ControlEvent {
  const USVCA2Changed({
    required this.usVCA2,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String usVCA2;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        usVCA2,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class USVCA2Increased extends Setting18ControlEvent {
  const USVCA2Increased({
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

class USVCA2Decreased extends Setting18ControlEvent {
  const USVCA2Decreased({
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

class EREQChanged extends Setting18ControlEvent {
  const EREQChanged({
    required this.eREQ,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String eREQ;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        eREQ,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class EREQIncreased extends Setting18ControlEvent {
  const EREQIncreased({
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

class EREQDecreased extends Setting18ControlEvent {
  const EREQDecreased({
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

class RtnIngressSetting2Changed extends Setting18ControlEvent {
  const RtnIngressSetting2Changed(this.returnIngressSetting2);

  final String returnIngressSetting2;

  @override
  List<Object> get props => [returnIngressSetting2];
}

class RtnIngressSetting3Changed extends Setting18ControlEvent {
  const RtnIngressSetting3Changed(this.returnIngressSetting3);

  final String returnIngressSetting3;

  @override
  List<Object> get props => [returnIngressSetting3];
}

class RtnIngressSetting4Changed extends Setting18ControlEvent {
  const RtnIngressSetting4Changed(this.returnIngressSetting4);

  final String returnIngressSetting4;

  @override
  List<Object> get props => [returnIngressSetting4];
}

class TGCCableLengthChanged extends Setting18ControlEvent {
  const TGCCableLengthChanged(this.tgcCableLength);

  final String tgcCableLength;

  @override
  List<Object> get props => [tgcCableLength];
}

class DSVVA2Changed extends Setting18ControlEvent {
  const DSVVA2Changed({
    required this.dsVVA2,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsVVA2;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsVVA2,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSSlope2Changed extends Setting18ControlEvent {
  const DSSlope2Changed({
    required this.dsSlope2,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsSlope2;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsSlope2,
        textEditingController,
        isFromTextField,
      ];
}

class DSSlope3Changed extends Setting18ControlEvent {
  const DSSlope3Changed({
    required this.dsSlope3,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsSlope3;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsSlope3,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSSlope3Increased extends Setting18ControlEvent {
  const DSSlope3Increased({
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

class DSSlope3Decreased extends Setting18ControlEvent {
  const DSSlope3Decreased({
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

class DSSlope4Changed extends Setting18ControlEvent {
  const DSSlope4Changed({
    required this.dsSlope4,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsSlope4;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsSlope4,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSSlope4Increased extends Setting18ControlEvent {
  const DSSlope4Increased({
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

class DSSlope4Decreased extends Setting18ControlEvent {
  const DSSlope4Decreased({
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

class DSVVA3Changed extends Setting18ControlEvent {
  const DSVVA3Changed(this.dsVVA3);

  final String dsVVA3;

  @override
  List<Object> get props => [dsVVA3];
}

class DSVVA4Changed extends Setting18ControlEvent {
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

class DSVVA4Increased extends Setting18ControlEvent {
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

class DSVVA4Decreased extends Setting18ControlEvent {
  const DSVVA4Decreased({
    required this.minValue,
    required this.textEditingController,
  });

  final double minValue;
  final TextEditingController textEditingController;

  @override
  List<Object> get props => [minValue, textEditingController];
}

class DSVVA5Changed extends Setting18ControlEvent {
  const DSVVA5Changed({
    required this.dsVVA5,
    required this.maxValue,
    required this.minValue,
    required this.textEditingController,
    required this.isFromTextField,
  });

  final String dsVVA5;
  final double maxValue;
  final double minValue;
  final TextEditingController textEditingController;
  final bool isFromTextField;

  @override
  List<Object> get props => [
        dsVVA5,
        maxValue,
        minValue,
        textEditingController,
        isFromTextField,
      ];
}

class DSVVA5Increased extends Setting18ControlEvent {
  const DSVVA5Increased({
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

class DSVVA5Decreased extends Setting18ControlEvent {
  const DSVVA5Decreased({
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

class USTGCChanged extends Setting18ControlEvent {
  const USTGCChanged(this.usTGC);

  final String usTGC;

  @override
  List<Object> get props => [usTGC];
}

class ResetForwardValuesRequested extends Setting18ControlEvent {
  const ResetForwardValuesRequested();

  @override
  List<Object> get props => [];
}

class ResetReverseValuesRequested extends Setting18ControlEvent {
  const ResetReverseValuesRequested();

  @override
  List<Object> get props => [];
}

class EditModeEnabled extends Setting18ControlEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18ControlEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18ControlEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

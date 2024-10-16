part of 'setting18_reverse_control_bloc.dart';

sealed class Setting18ReverseControlEvent extends Equatable {
  const Setting18ReverseControlEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18ReverseControlEvent {
  const Initialized({this.useCache = true});

  final bool useCache;

  @override
  List<Object> get props => [useCache];
}

class USVCA1Changed extends Setting18ReverseControlEvent {
  const USVCA1Changed({
    required this.usVCA1,
  });

  final String usVCA1;

  @override
  List<Object> get props => [
        usVCA1,
      ];
}

class USVCA2Changed extends Setting18ReverseControlEvent {
  const USVCA2Changed({
    required this.usVCA2,
  });

  final String usVCA2;

  @override
  List<Object> get props => [
        usVCA2,
      ];
}

class USVCA3Changed extends Setting18ReverseControlEvent {
  const USVCA3Changed({
    required this.usVCA3,
  });

  final String usVCA3;

  @override
  List<Object> get props => [
        usVCA3,
      ];
}

class USVCA4Changed extends Setting18ReverseControlEvent {
  const USVCA4Changed({
    required this.usVCA4,
  });

  final String usVCA4;

  @override
  List<Object> get props => [
        usVCA4,
      ];
}

class EREQChanged extends Setting18ReverseControlEvent {
  const EREQChanged({
    required this.eREQ,
  });

  final String eREQ;

  @override
  List<Object> get props => [
        eREQ,
      ];
}

class RtnIngressSetting2Changed extends Setting18ReverseControlEvent {
  const RtnIngressSetting2Changed(this.returnIngressSetting2);

  final String returnIngressSetting2;

  @override
  List<Object> get props => [returnIngressSetting2];
}

class RtnIngressSetting3Changed extends Setting18ReverseControlEvent {
  const RtnIngressSetting3Changed(this.returnIngressSetting3);

  final String returnIngressSetting3;

  @override
  List<Object> get props => [returnIngressSetting3];
}

class RtnIngressSetting4Changed extends Setting18ReverseControlEvent {
  const RtnIngressSetting4Changed(this.returnIngressSetting4);

  final String returnIngressSetting4;

  @override
  List<Object> get props => [returnIngressSetting4];
}

class ResetReverseValuesRequested extends Setting18ReverseControlEvent {
  const ResetReverseValuesRequested();

  @override
  List<Object> get props => [];
}

class EditModeEnabled extends Setting18ReverseControlEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18ReverseControlEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18ReverseControlEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}

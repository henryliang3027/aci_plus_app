part of 'mode_input_bloc.dart';

abstract class ModeInputEvent extends Equatable {
  const ModeInputEvent();

  @override
  List<Object?> get props => [];
}

class CodeRequested extends ModeInputEvent {
  const CodeRequested();

  @override
  List<Object?> get props => [];
}

class CodeChanged extends ModeInputEvent {
  const CodeChanged({required this.code});

  final String code;

  @override
  List<Object?> get props => [code];
}

class CodeConfirmed extends ModeInputEvent {
  const CodeConfirmed();

  @override
  List<Object?> get props => [];
}

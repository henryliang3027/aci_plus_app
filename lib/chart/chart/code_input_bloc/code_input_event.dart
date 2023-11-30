part of 'code_input_bloc.dart';

abstract class CodeInputEvent extends Equatable {
  const CodeInputEvent();
}

class CodeRequested extends CodeInputEvent {
  const CodeRequested();

  @override
  List<Object?> get props => [];
}

class CodeChanged extends CodeInputEvent {
  const CodeChanged({required this.code});

  final String code;

  @override
  List<Object?> get props => [code];
}

class CodeConfirmed extends CodeInputEvent {
  const CodeConfirmed();

  @override
  List<Object?> get props => [];
}

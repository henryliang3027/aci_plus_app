part of 'delay_input_bloc.dart';

abstract class DelayInputEvent extends Equatable {
  const DelayInputEvent();
}

class DelayRequested extends DelayInputEvent {
  const DelayRequested();

  @override
  List<Object?> get props => [];
}

class DelayChanged extends DelayInputEvent {
  const DelayChanged({required this.delay});

  final String delay;

  @override
  List<Object?> get props => [delay];
}

class DelayConfirmed extends DelayInputEvent {
  const DelayConfirmed();

  @override
  List<Object?> get props => [];
}

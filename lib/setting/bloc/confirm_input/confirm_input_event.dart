part of 'confirm_input_bloc.dart';

abstract class ConfirmInputEvent extends Equatable {
  const ConfirmInputEvent();
}

class TextChanged extends ConfirmInputEvent {
  const TextChanged({required this.text});

  final String text;

  @override
  List<Object?> get props => [text];
}

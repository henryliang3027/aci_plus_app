part of 'confirm_input_bloc.dart';

class ConfirmInputState extends Equatable {
  const ConfirmInputState({
    this.text = '',
    this.isMatch = false,
  });

  final String text;
  final bool isMatch;

  ConfirmInputState copyWith({
    String? text,
    bool? isMatch,
  }) {
    return ConfirmInputState(
      text: text ?? this.text,
      isMatch: isMatch ?? this.isMatch,
    );
  }

  @override
  List<Object> get props => [
        text,
        isMatch,
      ];
}

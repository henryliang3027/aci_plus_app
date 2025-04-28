part of 'mode_input_bloc.dart';

class ModeInputState extends Equatable {
  const ModeInputState({
    this.isInitialize = false,
    this.code = '',
    this.isMatched = false,
  });

  final bool isInitialize;
  final String code;
  final bool isMatched;

  ModeInputState copyWith({
    bool? isInitialize,
    String? code,
    bool? isMatched,
  }) {
    return ModeInputState(
      isInitialize: isInitialize ?? this.isInitialize,
      code: code ?? this.code,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  @override
  List<Object> get props => [
        isInitialize,
        code,
        isMatched,
      ];
}

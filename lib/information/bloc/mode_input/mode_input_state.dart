part of 'mode_input_bloc.dart';

class ModeInputState extends Equatable {
  const ModeInputState({
    this.isInitialize = false,
    this.code = '',
    this.isMatched = false,
    this.targetMode = Mode.basic,
  });

  final bool isInitialize;
  final String code;
  final bool isMatched;
  final Mode targetMode;

  ModeInputState copyWith({
    bool? isInitialize,
    String? code,
    bool? isMatched,
    Mode? targetMode,
  }) {
    return ModeInputState(
      isInitialize: isInitialize ?? this.isInitialize,
      code: code ?? this.code,
      isMatched: isMatched ?? this.isMatched,
      targetMode: targetMode ?? this.targetMode,
    );
  }

  @override
  List<Object> get props => [
        isInitialize,
        code,
        isMatched,
        targetMode,
      ];
}

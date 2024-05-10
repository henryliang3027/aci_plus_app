part of 'code_input_bloc.dart';

class CodeInputState extends Equatable {
  const CodeInputState({
    this.isInitialize = false,
    this.code = '',
  });

  final bool isInitialize;
  final String code;

  CodeInputState copyWith({
    bool? isInitialize,
    String? code,
  }) {
    return CodeInputState(
      isInitialize: isInitialize ?? this.isInitialize,
      code: code ?? this.code,
    );
  }

  @override
  List<Object> get props => [
        isInitialize,
        code,
      ];
}

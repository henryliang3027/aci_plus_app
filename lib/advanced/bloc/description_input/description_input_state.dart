part of 'description_input_bloc.dart';

class DescriptionInputState extends Equatable {
  const DescriptionInputState({
    this.isInitialize = false,
    this.initialDescription = '',
    this.description = '',
  });

  final bool isInitialize;
  final String initialDescription;
  final String description;

  DescriptionInputState copyWith({
    bool? isInitialize,
    String? initialDescription,
    String? description,
  }) {
    return DescriptionInputState(
      isInitialize: isInitialize ?? this.isInitialize,
      initialDescription: initialDescription ?? this.initialDescription,
      description: description ?? this.description,
    );
  }

  @override
  List<Object> get props => [
        isInitialize,
        initialDescription,
        description,
      ];
}

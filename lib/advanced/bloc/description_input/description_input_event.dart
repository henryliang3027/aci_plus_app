part of 'description_input_bloc.dart';

abstract class DescriptionInputEvent extends Equatable {
  const DescriptionInputEvent();
}

class DescriptionInitialized extends DescriptionInputEvent {
  const DescriptionInitialized();

  @override
  List<Object?> get props => [];
}

class DescriptionChanged extends DescriptionInputEvent {
  const DescriptionChanged({required this.description});

  final String description;

  @override
  List<Object?> get props => [description];
}

class DescriptionConfirmed extends DescriptionInputEvent {
  const DescriptionConfirmed();

  @override
  List<Object?> get props => [];
}

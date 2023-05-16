part of 'information_bloc.dart';

class InformationState extends Equatable {
  const InformationState({
    this.status = FormStatus.none,
  });

  final FormStatus status;

  InformationState copyWith({
    FormStatus? status,
  }) {
    return InformationState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [];
}

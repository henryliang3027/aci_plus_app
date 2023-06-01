part of 'chart_bloc.dart';

class ChartState extends Equatable {
  const ChartState({
    this.status = FormStatus.none,
  });

  final FormStatus status;

  ChartState copyWith({
    FormStatus? status,
  }) {
    return ChartState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
      ];
}

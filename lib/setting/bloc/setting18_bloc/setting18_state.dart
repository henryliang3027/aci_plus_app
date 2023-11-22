part of 'setting18_bloc.dart';

class Setting18State extends Equatable {
  const Setting18State({
    this.isGraphType = false,
  });

  final bool isGraphType;

  Setting18State copyWith({
    bool? isGraphType,
  }) {
    return Setting18State(
      isGraphType: isGraphType ?? this.isGraphType,
    );
  }

  @override
  List<Object?> get props => [
        isGraphType,
      ];
}

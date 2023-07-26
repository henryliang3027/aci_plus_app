part of 'setting_bloc.dart';

class SettingState extends Equatable {
  const SettingState({
    this.isGraphType = false,
  });

  final bool isGraphType;

  SettingState copyWith({
    bool? isGraphType,
  }) {
    return SettingState(
      isGraphType: isGraphType ?? this.isGraphType,
    );
  }

  @override
  List<Object?> get props => [
        isGraphType,
      ];
}

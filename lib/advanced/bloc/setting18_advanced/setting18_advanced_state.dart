part of 'setting18_advanced_bloc.dart';

class Setting18AdvancedState extends Equatable {
  const Setting18AdvancedState({
    this.enableButtonsTap = true,
  });

  final bool enableButtonsTap;

  Setting18AdvancedState copyWith({
    bool? enableButtonsTap,
  }) {
    return Setting18AdvancedState(
      enableButtonsTap: enableButtonsTap ?? this.enableButtonsTap,
    );
  }

  @override
  List<Object> get props => [
        enableButtonsTap,
      ];
}

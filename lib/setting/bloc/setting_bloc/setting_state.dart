part of 'setting_bloc.dart';

class SettingState extends Equatable {
  const SettingState({
    this.status = FormStatus.none,
  });

  final FormStatus status;

  SettingState copyWith({
    FormStatus? status,
  }) {
    return SettingState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [];
}

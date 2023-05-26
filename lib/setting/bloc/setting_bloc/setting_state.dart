part of 'setting_bloc.dart';

class SettingState extends Equatable {
  const SettingState({
    this.status = FormStatus.none,
    this.location = const Location.pure(),
  });

  final FormStatus status;
  final Location location;

  SettingState copyWith({
    FormStatus? status,
    Location? location,
  }) {
    return SettingState(
      status: status ?? this.status,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [
        status,
        location,
      ];
}

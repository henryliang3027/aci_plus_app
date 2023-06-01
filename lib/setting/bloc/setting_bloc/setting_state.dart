part of 'setting_bloc.dart';

class SettingState extends Equatable {
  const SettingState({
    this.status = FormStatus.none,
    this.location = const Location.pure(),
    this.isGraphType = false,
  });

  final FormStatus status;
  final Location location;
  final bool isGraphType;

  SettingState copyWith({
    FormStatus? status,
    Location? location,
    bool? isGraphType,
  }) {
    return SettingState(
      status: status ?? this.status,
      location: location ?? this.location,
      isGraphType: isGraphType ?? this.isGraphType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        location,
        isGraphType,
      ];
}

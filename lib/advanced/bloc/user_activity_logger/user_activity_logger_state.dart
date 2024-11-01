part of 'user_activity_logger_bloc.dart';

class UserActivityLoggerState extends Equatable {
  const UserActivityLoggerState({
    this.formStatus = FormStatus.none,
  });

  final FormStatus formStatus;

  UserActivityLoggerState copyWith({
    FormStatus? formStatus,
  }) {
    return UserActivityLoggerState(
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object> get props => [];
}

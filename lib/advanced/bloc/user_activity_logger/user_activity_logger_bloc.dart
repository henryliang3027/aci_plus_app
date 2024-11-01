import 'package:aci_plus_app/core/form_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_activity_logger_event.dart';
part 'user_activity_logger_state.dart';

class UserActivityLoggerBloc
    extends Bloc<UserActivityLoggerEvent, UserActivityLoggerState> {
  UserActivityLoggerBloc() : super(const UserActivityLoggerState()) {
    on<UserActivityLoggerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

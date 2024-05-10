import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'confirm_input_event.dart';
part 'confirm_input_state.dart';

class ConfirmInputBloc extends Bloc<ConfirmInputEvent, ConfirmInputState> {
  ConfirmInputBloc() : super(const ConfirmInputState()) {
    on<TextChanged>(_onTextChanged);
  }

  void _onTextChanged(
    TextChanged event,
    Emitter<ConfirmInputState> emit,
  ) {
    emit(state.copyWith(
      text: event.text,
      isMatch: event.text == 'confirm',
    ));
  }
}

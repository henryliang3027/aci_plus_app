import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'description_input_event.dart';
part 'description_input_state.dart';

class DescriptionInputBloc
    extends Bloc<DescriptionInputEvent, DescriptionInputState> {
  DescriptionInputBloc() : super(const DescriptionInputState()) {
    on<DescriptionInitialized>(_onDescriptionInitialized);
    on<DescriptionChanged>(_onDescriptionChanged);

    add(const DescriptionInitialized());
  }

  Future<void> _onDescriptionInitialized(
    DescriptionInitialized event,
    Emitter<DescriptionInputState> emit,
  ) async {
    String timeStamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String description = 'QR_Code_$timeStamp';

    emit(state.copyWith(
      isInitialize: true,
      initialDescription: description,
      description: description,
    ));
  }

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<DescriptionInputState> emit,
  ) {
    emit(state.copyWith(
      isInitialize: false,
      description: event.description,
    ));
  }
}

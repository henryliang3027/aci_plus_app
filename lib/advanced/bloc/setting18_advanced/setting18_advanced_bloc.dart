import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_advanced_event.dart';
part 'setting18_advanced_state.dart';

class Setting18AdvancedBloc
    extends Bloc<Setting18AdvancedEvent, Setting18AdvancedState> {
  Setting18AdvancedBloc() : super(const Setting18AdvancedState()) {
    on<AllButtonsEnabled>(_onAllButtonsEnabled);
    on<AllButtonsDisabled>(_onAllButtonsDisabled);
  }

  void _onAllButtonsEnabled(
    AllButtonsEnabled event,
    Emitter<Setting18AdvancedState> emit,
  ) async {
    emit(state.copyWith(
      enableButtonsTap: true,
    ));
  }

  void _onAllButtonsDisabled(
    AllButtonsDisabled event,
    Emitter<Setting18AdvancedState> emit,
  ) async {
    emit(state.copyWith(
      enableButtonsTap: false,
    ));
  }
}

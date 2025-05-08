import 'package:aci_plus_app/env_config.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mode_input_event.dart';
part 'mode_input_state.dart';

class ModeInputBloc extends Bloc<ModeInputEvent, ModeInputState> {
  ModeInputBloc() : super(const ModeInputState()) {
    on<CodeRequested>(_onCodeRequested);
    on<CodeChanged>(_onCodeChanged);
    on<CodeConfirmed>(_onCodeConfirmed);

    // add(const CodeRequested());
  }

  Future<void> _onCodeRequested(
    CodeRequested event,
    Emitter<ModeInputState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: true,
      code: EnvConfig.expertModePassword,
      isMatched: true,
    ));
  }

  void _onCodeChanged(
    CodeChanged event,
    Emitter<ModeInputState> emit,
  ) {
    bool isMatched = false;
    if (event.code == EnvConfig.expertModePassword ||
        event.code == EnvConfig.expertModeDeveloperPassword) {
      isMatched = true;
    } else {
      isMatched = false;
    }

    emit(state.copyWith(
      isInitialize: false,
      code: event.code,
      isMatched: isMatched,
    ));
  }

  Future<void> _onCodeConfirmed(
    CodeConfirmed event,
    Emitter<ModeInputState> emit,
  ) async {
    // emit(state.copyWith(
    // ));
    // await _codeRepository.writeUserCode(state.code);
  }
}

import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/env_config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'mode_input_event.dart';
part 'mode_input_state.dart';

class ModeInputBloc extends Bloc<ModeInputEvent, ModeInputState> {
  ModeInputBloc({
    required Mode targetMode,
  }) : super(ModeInputState(targetMode: targetMode)) {
    on<CodeRequested>(_onCodeRequested);
    on<CodeChanged>(_onCodeChanged);
    on<CodeConfirmed>(_onCodeConfirmed);
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
    if (state.targetMode == Mode.expert) {
      isMatched = event.code == EnvConfig.expertModePassword;
      print('Expert mode password: $isMatched');
    } else {
      // Basic mode 不使用密碼
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
    // 不記憶輸入的員工號碼到手機資料庫
    // emit(state.copyWith(
    // ));
    // await _codeRepository.writeUserCode(state.code);
  }
}

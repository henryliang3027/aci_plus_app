import 'package:aci_plus_app/core/shared_preference_key.dart';
import 'package:aci_plus_app/repositories/code_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'code_input_event.dart';
part 'code_input_state.dart';

class CodeInputBloc extends Bloc<CodeInputEvent, CodeInputState> {
  CodeInputBloc({
    required CodeRepository codeRepository,
  })  : _codeRepository = codeRepository,
        super(const CodeInputState()) {
    on<CodeRequested>(_onCodeRequested);
    on<CodeChanged>(_onCodeChanged);
    on<CodeConfirmed>(_onCodeConfirmed);

    add(const CodeRequested());
  }

  final CodeRepository _codeRepository;

  Future<void> _onCodeRequested(
    CodeRequested event,
    Emitter<CodeInputState> emit,
  ) async {
    // 2025/04/03 不讀取人員代碼
    // String code = await _codeRepository.readUserCode();

    emit(state.copyWith(
      isInitialize: true,
      code: '',
    ));
  }

  void _onCodeChanged(
    CodeChanged event,
    Emitter<CodeInputState> emit,
  ) {
    emit(state.copyWith(
      isInitialize: false,
      code: event.code,
    ));
  }

  Future<void> _onCodeConfirmed(
    CodeConfirmed event,
    Emitter<CodeInputState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
    ));

    // 2025/04/03 記錄人員代碼, 但是不在輸入框中顯示之前輸入的代碼,
    // 仍然需要記錄, 因為寫入 firmeaware update log 時需要用到
    await _codeRepository.writeUserCode(state.code);
  }
}

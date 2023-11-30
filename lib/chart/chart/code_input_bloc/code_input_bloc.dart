import 'package:aci_plus_app/core/shared_preference_key.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'code_input_event.dart';
part 'code_input_state.dart';

class CodeInputBloc extends Bloc<CodeInputEvent, CodeInputState> {
  CodeInputBloc() : super(const CodeInputState()) {
    on<CodeRequested>(_onCodeRequested);
    on<CodeChanged>(_onCodeChanged);
    on<CodeConfirmed>(_onCodeConfirmed);

    add(const CodeRequested());
  }

  Future<void> _onCodeRequested(
    CodeRequested event,
    Emitter<CodeInputState> emit,
  ) async {
    String code = await readUserCode();

    emit(state.copyWith(
      isInitialize: true,
      code: code,
    ));
  }

  Future<void> _onCodeChanged(
    CodeChanged event,
    Emitter<CodeInputState> emit,
  ) async {
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

    bool result = await writeUserCode(state.code);
  }

  Future<bool> writeUserCode(String userCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result =
        await prefs.setString(SharedPreferenceKey.userCode.name, userCode);
    return result;
  }

  Future<String> readUserCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userCode = prefs.getString(SharedPreferenceKey.userCode.name) ?? '';
    return userCode;
  }
}

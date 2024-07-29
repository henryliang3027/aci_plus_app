import 'package:aci_plus_app/core/form_status.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeRequested>(_onThemeRequested);
    on<ThemeChanged>(_onThemeChanged);

    add(const ThemeRequested());
  }

  Future<void> _onThemeRequested(
    ThemeRequested event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
    ));

    final AdaptiveThemeMode savedAdaptiveThemeMode =
        await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;

    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
      theme: savedAdaptiveThemeMode.name,
    ));
  }

  void _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(
      theme: event.theme,
    ));
  }
}

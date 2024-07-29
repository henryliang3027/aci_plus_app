part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeRequested extends ThemeEvent {
  const ThemeRequested();

  @override
  List<Object> get props => [];
}

class ThemeChanged extends ThemeEvent {
  const ThemeChanged(this.theme);

  final String theme;

  @override
  List<Object> get props => [theme];
}

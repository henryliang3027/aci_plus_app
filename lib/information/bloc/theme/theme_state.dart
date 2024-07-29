part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({
    this.formStatus = FormStatus.none,
    this.theme = '',
  });

  final FormStatus formStatus;
  final String theme;

  ThemeState copyWith({
    FormStatus? formStatus,
    String? theme,
  }) {
    return ThemeState(
      formStatus: formStatus ?? this.formStatus,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        theme,
      ];
}

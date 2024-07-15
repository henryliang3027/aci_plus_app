part of 'setting18_base_config_bloc.dart';

class Setting18BaseConfigState extends Equatable {
  const Setting18BaseConfigState({
    this.formStatus = FormStatus.none,
    this.configs = const [],
  });

  final FormStatus formStatus;
  final List<Config> configs;

  Setting18BaseConfigState copyWith({
    FormStatus? formStatus,
    List<Config>? configs,
  }) {
    return Setting18BaseConfigState(
      formStatus: formStatus ?? this.formStatus,
      configs: configs ?? this.configs,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        configs,
      ];
}

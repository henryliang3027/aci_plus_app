part of 'setting18_config_bloc.dart';

sealed class Setting18ConfigEvent extends Equatable {
  const Setting18ConfigEvent();

  @override
  List<Object> get props => [];
}

class ConfigsInitialized extends Setting18ConfigEvent {
  const ConfigsInitialized();
}

part of 'setting18_base_config_bloc.dart';

class Setting18BaseConfigEvent extends Equatable {
  const Setting18BaseConfigEvent();

  @override
  List<Object> get props => [];
}

class ConfigsRequested extends Setting18BaseConfigEvent {
  const ConfigsRequested();

  @override
  List<Object> get props => [];
}

class ConfigDeleted extends Setting18BaseConfigEvent {
  const ConfigDeleted({
    required this.id,
    required this.groupId,
  });

  final int id;
  final String groupId;

  @override
  List<Object> get props => [
        id,
        groupId,
      ];
}

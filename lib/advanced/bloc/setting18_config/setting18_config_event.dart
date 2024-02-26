part of 'setting18_config_bloc.dart';

sealed class Setting18ConfigEvent extends Equatable {
  const Setting18ConfigEvent();

  @override
  List<Object> get props => [];
}

class ConfigsRequested extends Setting18ConfigEvent {
  const ConfigsRequested();

  @override
  List<Object> get props => [];
}

class ConfigDeleted extends Setting18ConfigEvent {
  const ConfigDeleted(this.id);

  final int id;

  @override
  List<Object> get props => [id];
}

class DefaultConfigChanged extends Setting18ConfigEvent {
  const DefaultConfigChanged({
    required this.groupId,
    required this.id,
  });

  final String groupId;
  final int id;

  @override
  List<Object> get props => [
        groupId,
        id,
      ];
}

class QRDataGenerated extends Setting18ConfigEvent {
  const QRDataGenerated(this.selectedPartId);

  final String selectedPartId;

  @override
  List<Object> get props => [];
}

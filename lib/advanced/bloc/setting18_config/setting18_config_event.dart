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

class QRDataGenerated extends Setting18ConfigEvent {
  const QRDataGenerated();

  @override
  List<Object> get props => [];
}

class QRDataScanned extends Setting18ConfigEvent {
  const QRDataScanned(this.rawData);

  final String rawData;

  @override
  List<Object> get props => [rawData];
}

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

class QRImageRead extends Setting18ConfigEvent {
  const QRImageRead();

  @override
  List<Object> get props => [];
}

class QRImagePicked extends Setting18ConfigEvent {
  const QRImagePicked();

  @override
  List<Object> get props => [];
}

// 只用於 Windows 平台, 檢查是否有 Camera
class CameraAvailabilityChecked extends Setting18ConfigEvent {
  const CameraAvailabilityChecked();

  @override
  List<Object> get props => [];
}

part of 'setting18_config_bloc.dart';

sealed class Setting18ConfigEvent extends Equatable {
  const Setting18ConfigEvent();

  @override
  List<Object> get props => [];
}

class QRDataGenerated extends Setting18ConfigEvent {
  const QRDataGenerated(this.selectedPartId);

  final String selectedPartId;

  @override
  List<Object> get props => [];
}

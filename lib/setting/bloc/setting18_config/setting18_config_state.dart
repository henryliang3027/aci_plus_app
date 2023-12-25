part of 'setting18_config_bloc.dart';

class Setting18ConfigState extends Equatable {
  const Setting18ConfigState({
    this.formStatus = FormStatus.none,
    this.partIds = const [
      '3', // MOTO MB
      '2', // MOTO BLE
      '5', // C-Cor TR
      '6', // C-Cor BR
      '7', // C-Cor LE
    ],
  });

  final FormStatus formStatus;
  final List<String> partIds;

  @override
  List<Object> get props => [
        formStatus,
        partIds,
      ];
}

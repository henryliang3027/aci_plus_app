part of 'setting18_config_bloc.dart';

class Setting18ConfigState extends Equatable {
  const Setting18ConfigState({
    this.formStatus = FormStatus.none,
    this.encodeStaus = FormStatus.none,
    this.partIds = const [
      '3', // MOTO MB
      '2', // MOTO BLE
      '5', // C-Cor TR
      '6', // C-Cor BR
      '7', // C-Cor LE
    ],
    this.encodedData = '',
  });

  final FormStatus formStatus;
  final FormStatus encodeStaus;
  final List<String> partIds;
  final String encodedData;

  Setting18ConfigState copyWith({
    FormStatus? formStatus,
    FormStatus? encodeStaus,
    List<String>? partIds,
    String? encodedData,
  }) {
    return Setting18ConfigState(
      formStatus: formStatus ?? this.formStatus,
      encodeStaus: encodeStaus ?? this.encodeStaus,
      partIds: partIds ?? this.partIds,
      encodedData: encodedData ?? this.encodedData,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        encodeStaus,
        partIds,
        encodedData,
      ];
}

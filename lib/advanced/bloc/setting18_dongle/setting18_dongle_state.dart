part of 'setting18_dongle_bloc.dart';

class Setting18DongleState extends Equatable {
  const Setting18DongleState({
    this.formStatus = FormStatus.none,
    this.partIds = const [
      'd', // DSIM
      '3', // MOTO MB
      '2', // MOTO BLE
      '5', // C-Cor TR
      '6', // C-Cor BR
      '7', // C-Cor LE
    ],
  });

  final FormStatus formStatus;
  final List<String> partIds;

  Setting18DongleState copyWith({
    List<String>? partIds,
  }) {
    return Setting18DongleState(
      partIds: partIds ?? this.partIds,
    );
  }

  @override
  List<Object> get props => [
        partIds,
      ];
}

part of 'qr_code_generator_bloc.dart';

abstract class QRCodeGeneratorEvent extends Equatable {
  const QRCodeGeneratorEvent();

  @override
  List<Object> get props => [];
}

class QRCodeSaved extends QRCodeGeneratorEvent {
  const QRCodeSaved(this.byteData);

  final ByteData byteData;

  @override
  List<Object> get props => [byteData];
}

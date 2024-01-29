part of 'qr_code_generator_bloc.dart';

abstract class QRCodeGeneratorEvent extends Equatable {
  const QRCodeGeneratorEvent();

  @override
  List<Object> get props => [];
}

class QRCodeShared extends QRCodeGeneratorEvent {
  const QRCodeShared(this.rawImage);

  final Uint8List rawImage;

  @override
  List<Object> get props => [rawImage];
}

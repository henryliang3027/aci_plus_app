part of 'qr_code_generator_bloc.dart';

class QRCodeGeneratorState extends Equatable {
  const QRCodeGeneratorState({
    this.imageSaveStatus = FormStatus.none,
    this.imageFileName = '',
    this.imageFilePath = '',
  });

  final FormStatus imageSaveStatus;
  final String imageFileName;
  final String imageFilePath;

  QRCodeGeneratorState copyWith({
    FormStatus? imageSaveStatus,
    String? imageFileName,
    String? imageFilePath,
  }) {
    return QRCodeGeneratorState(
      imageSaveStatus: imageSaveStatus ?? this.imageSaveStatus,
      imageFileName: imageFileName ?? this.imageFileName,
      imageFilePath: imageFilePath ?? this.imageFilePath,
    );
  }

  @override
  List<Object> get props => [
        imageSaveStatus,
        imageFileName,
        imageFilePath,
      ];
}

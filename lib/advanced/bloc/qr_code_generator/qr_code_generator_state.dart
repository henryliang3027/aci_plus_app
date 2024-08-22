part of 'qr_code_generator_bloc.dart';

class QRCodeGeneratorState extends Equatable {
  const QRCodeGeneratorState({
    this.encodedData = '',
    this.description = '',
    this.imageSaveStatus = FormStatus.none,
    this.imageFileName = '',
    this.imageFilePath = '',
  });

  final String encodedData;
  final String description;
  final FormStatus imageSaveStatus;
  final String imageFileName;
  final String imageFilePath;

  QRCodeGeneratorState copyWith({
    String? encodedData,
    String? description,
    FormStatus? imageSaveStatus,
    String? imageFileName,
    String? imageFilePath,
  }) {
    return QRCodeGeneratorState(
      encodedData: encodedData ?? this.encodedData,
      description: description ?? this.description,
      imageSaveStatus: imageSaveStatus ?? this.imageSaveStatus,
      imageFileName: imageFileName ?? this.imageFileName,
      imageFilePath: imageFilePath ?? this.imageFilePath,
    );
  }

  @override
  List<Object> get props => [
        encodedData,
        description,
        imageSaveStatus,
        imageFileName,
        imageFilePath,
      ];
}

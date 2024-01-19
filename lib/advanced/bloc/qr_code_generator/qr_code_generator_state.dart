part of 'qr_code_generator_bloc.dart';

class QRCodeGeneratorState extends Equatable {
  const QRCodeGeneratorState({
    this.shareStatus = FormStatus.none,
  });

  final FormStatus shareStatus;

  QRCodeGeneratorState copyWith({
    FormStatus? shareStatus,
  }) {
    return QRCodeGeneratorState(
      shareStatus: shareStatus ?? this.shareStatus,
    );
  }

  @override
  List<Object> get props => [
        shareStatus,
      ];
}

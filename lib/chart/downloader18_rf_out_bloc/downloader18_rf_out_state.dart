part of 'downloader18_rf_out_bloc.dart';

class Downloader18RFOutState extends Equatable {
  const Downloader18RFOutState({
    this.status = FormStatus.none,
    this.currentProgress = 0,
    this.rfOutputLog1p8Gs = const [],
    this.errorMessage = '',
  });

  final FormStatus status;
  final int currentProgress;
  final List<RFOutputLog> rfOutputLog1p8Gs;
  final String errorMessage;

  Downloader18RFOutState copyWith({
    FormStatus? status,
    int? currentProgress,
    List<RFOutputLog>? rfOutputLog1p8Gs,
    String? errorMessage,
  }) {
    return Downloader18RFOutState(
      status: status ?? this.status,
      currentProgress: currentProgress ?? this.currentProgress,
      rfOutputLog1p8Gs: rfOutputLog1p8Gs ?? this.rfOutputLog1p8Gs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
        currentProgress,
        rfOutputLog1p8Gs,
        errorMessage,
      ];
}

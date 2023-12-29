part of 'downloader_bloc.dart';

class DownloaderState extends Equatable {
  const DownloaderState({
    this.status = FormStatus.none,
    this.currentProgress = 0,
    this.log1p8Gs = const [],
    this.errorMessage = '',
  });

  final FormStatus status;
  final int currentProgress;
  final List<Log1p8G> log1p8Gs;
  final String errorMessage;

  DownloaderState copyWith({
    FormStatus? status,
    int? currentProgress,
    List<Log1p8G>? log1p8Gs,
    String? errorMessage,
  }) {
    return DownloaderState(
      status: status ?? this.status,
      currentProgress: currentProgress ?? this.currentProgress,
      log1p8Gs: log1p8Gs ?? this.log1p8Gs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
        currentProgress,
        log1p8Gs,
        errorMessage,
      ];
}

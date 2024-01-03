part of 'downloader18_ccor_node_bloc.dart';

class Downloader18CCorNodeState extends Equatable {
  const Downloader18CCorNodeState({
    this.status = FormStatus.none,
    this.currentProgress = 0,
    this.log1p8Gs = const [],
    this.errorMessage = '',
  });

  final FormStatus status;
  final int currentProgress;
  final List<Log1p8GCCorNode> log1p8Gs;
  final String errorMessage;

  Downloader18CCorNodeState copyWith({
    FormStatus? status,
    int? currentProgress,
    List<Log1p8GCCorNode>? log1p8Gs,
    String? errorMessage,
  }) {
    return Downloader18CCorNodeState(
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

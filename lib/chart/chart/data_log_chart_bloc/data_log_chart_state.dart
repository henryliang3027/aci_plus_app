part of 'data_log_chart_bloc.dart';

class DataLogChartState extends Equatable {
  const DataLogChartState({
    this.dataRequestStatus = FormStatus.none,
    this.chunckIndex = 0,
    this.hasNextChunk = false,
    this.log1p8Gs = const [],
  });

  final FormStatus dataRequestStatus;
  final int chunckIndex;
  final bool hasNextChunk;
  final List<Log1p8G> log1p8Gs;

  DataLogChartState copyWith(
    FormStatus? dataRequestStatus,
    int? chunckIndex,
    bool? hasNextChunk,
    List<Log1p8G>? log1p8Gs,
  ) {
    return DataLogChartState(
      dataRequestStatus: dataRequestStatus ?? this.dataRequestStatus,
      chunckIndex: chunckIndex ?? this.chunckIndex,
      hasNextChunk: hasNextChunk ?? this.hasNextChunk,
      log1p8Gs: log1p8Gs ?? this.log1p8Gs,
    );
  }

  @override
  List<Object> get props => [
        dataRequestStatus,
        chunckIndex,
        hasNextChunk,
        log1p8Gs,
      ];
}

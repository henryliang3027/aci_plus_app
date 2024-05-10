part of 'data_log_chart_bloc.dart';

class DataLogChartState extends Equatable {
  const DataLogChartState({
    this.logRequestStatus = FormStatus.none,
    this.eventRequestStatus = FormStatus.none,
    this.chunkIndex = 0,
    this.hasNextChunk = false,
    this.event1p8Gs = const [],
    this.log1p8Gs = const [],
    this.dateValueCollectionOfLog = const [[], [], [], [], []],
    this.exportFileName = '',
    this.dataExportPath = '',
    this.errorMessage = '',
  });

  final FormStatus logRequestStatus;
  final FormStatus eventRequestStatus;
  final int chunkIndex;
  final bool hasNextChunk;
  final List<Event1p8G> event1p8Gs;
  final List<Log1p8G> log1p8Gs;
  final List<List<ValuePair>> dateValueCollectionOfLog;
  final String exportFileName;
  final String dataExportPath;
  final String errorMessage;

  DataLogChartState copyWith({
    FormStatus? logRequestStatus,
    FormStatus? eventRequestStatus,
    int? chunkIndex,
    bool? hasNextChunk,
    List<Event1p8G>? event1p8Gs,
    List<Log1p8G>? log1p8Gs,
    List<List<ValuePair>>? dateValueCollectionOfLog,
    String? exportFileName,
    String? dataExportPath,
    String? errorMessage,
  }) {
    return DataLogChartState(
      logRequestStatus: logRequestStatus ?? this.logRequestStatus,
      eventRequestStatus: eventRequestStatus ?? this.eventRequestStatus,
      chunkIndex: chunkIndex ?? this.chunkIndex,
      hasNextChunk: hasNextChunk ?? this.hasNextChunk,
      event1p8Gs: event1p8Gs ?? this.event1p8Gs,
      log1p8Gs: log1p8Gs ?? this.log1p8Gs,
      dateValueCollectionOfLog:
          dateValueCollectionOfLog ?? this.dateValueCollectionOfLog,
      exportFileName: exportFileName ?? this.exportFileName,
      dataExportPath: dataExportPath ?? this.dataExportPath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        logRequestStatus,
        eventRequestStatus,
        chunkIndex,
        hasNextChunk,
        event1p8Gs,
        log1p8Gs,
        dateValueCollectionOfLog,
        exportFileName,
        dataExportPath,
        errorMessage,
      ];
}

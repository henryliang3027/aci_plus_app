part of 'chart18_ccor_node_bloc.dart';

class Chart18CCorNodeState extends Equatable {
  const Chart18CCorNodeState({
    this.formStatus = FormStatus.none,
    this.moreLogRequestStatus = FormStatus.none,
    this.dataShareStatus = FormStatus.none,
    this.dataExportStatus = FormStatus.none,
    this.allDataExportStatus = FormStatus.none,
    this.chunkIndex = 0,
    this.hasNextChunk = false,
    this.event1p8Gs = const [],
    this.log1p8Gs = const [],
    this.dateValueCollectionOfLog = const [[], [], [], [], []],
    this.exportFileName = '',
    this.dataExportPath = '',
    this.errorMessage = '',
  });

  final FormStatus formStatus;
  final FormStatus moreLogRequestStatus;
  final FormStatus dataShareStatus;
  final FormStatus dataExportStatus;
  final FormStatus allDataExportStatus;
  final int chunkIndex;
  final bool hasNextChunk;
  final List<Event1p8GCCorNode> event1p8Gs;
  final List<Log1p8GCCorNode> log1p8Gs;
  final List<List<ValuePair>> dateValueCollectionOfLog;
  final String exportFileName;
  final String dataExportPath;
  final String errorMessage;

  Chart18CCorNodeState copyWith({
    FormStatus? formStatus,
    FormStatus? moreLogRequestStatus,
    FormStatus? dataShareStatus,
    FormStatus? dataExportStatus,
    FormStatus? allDataExportStatus,
    int? chunkIndex,
    bool? hasNextChunk,
    List<Event1p8GCCorNode>? event1p8Gs,
    List<Log1p8GCCorNode>? log1p8Gs,
    List<List<ValuePair>>? dateValueCollectionOfLog,
    String? exportFileName,
    String? dataExportPath,
    String? errorMessage,
  }) {
    return Chart18CCorNodeState(
      formStatus: formStatus ?? this.formStatus,
      moreLogRequestStatus: moreLogRequestStatus ?? this.moreLogRequestStatus,
      dataShareStatus: dataShareStatus ?? this.dataShareStatus,
      dataExportStatus: dataExportStatus ?? this.dataExportStatus,
      allDataExportStatus: allDataExportStatus ?? this.allDataExportStatus,
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
        formStatus,
        moreLogRequestStatus,
        dataShareStatus,
        dataExportStatus,
        allDataExportStatus,
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

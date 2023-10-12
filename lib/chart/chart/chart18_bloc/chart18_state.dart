part of 'chart18_bloc.dart';

class Chart18State extends Equatable {
  const Chart18State({
    this.dataRequestStatus = FormStatus.none,
    this.rfDataRequestStatus = FormStatus.none,
    this.dataExportStatus = FormStatus.none,
    this.dataShareStatus = FormStatus.none,
    this.allDataDownloadStatus = FormStatus.none,
    this.chunckIndex = 0,
    this.hasNextChunk = false,
    this.log1p8Gs = const [],
    this.event1p8Gs = const [],
    this.dateValueCollectionOfLog = const [[], [], [], [], []],
    this.rfInOuts = const [],
    this.valueCollectionOfRFInOut = const [[], []],
    this.exportFileName = '',
    this.dataExportPath = '',
    this.errorMessage = '',
  });

  final FormStatus dataRequestStatus;
  final FormStatus rfDataRequestStatus;
  final FormStatus dataExportStatus;
  final FormStatus dataShareStatus;
  final FormStatus allDataDownloadStatus;
  final int chunckIndex;
  final bool hasNextChunk;
  final List<Log1p8G> log1p8Gs;
  final List<List<ValuePair>> dateValueCollectionOfLog;
  final List<RFInOut> rfInOuts;
  final List<List<ValuePair>> valueCollectionOfRFInOut;
  final List<Event1p8G> event1p8Gs;
  final String exportFileName;
  final String dataExportPath;
  final String errorMessage;

  Chart18State copyWith({
    FormStatus? dataRequestStatus,
    FormStatus? rfDataRequestStatus,
    FormStatus? dataExportStatus,
    FormStatus? dataShareStatus,
    FormStatus? allDataDownloadStatus,
    int? chunckIndex,
    bool? hasNextChunk,
    List<Log1p8G>? log1p8Gs,
    List<List<ValuePair>>? dateValueCollectionOfLog,
    List<RFInOut>? rfInOuts,
    List<List<ValuePair>>? valueCollectionOfRFInOut,
    List<Event1p8G>? event1p8Gs,
    String? exportFileName,
    String? dataExportPath,
    String? errorMessage,
  }) {
    return Chart18State(
      dataRequestStatus: dataRequestStatus ?? this.dataRequestStatus,
      rfDataRequestStatus: rfDataRequestStatus ?? this.rfDataRequestStatus,
      dataExportStatus: dataExportStatus ?? this.dataExportStatus,
      dataShareStatus: dataShareStatus ?? this.dataExportStatus,
      allDataDownloadStatus:
          allDataDownloadStatus ?? this.allDataDownloadStatus,
      chunckIndex: chunckIndex ?? this.chunckIndex,
      hasNextChunk: hasNextChunk ?? this.hasNextChunk,
      log1p8Gs: log1p8Gs ?? this.log1p8Gs,
      dateValueCollectionOfLog:
          dateValueCollectionOfLog ?? this.dateValueCollectionOfLog,
      rfInOuts: rfInOuts ?? this.rfInOuts,
      event1p8Gs: event1p8Gs ?? this.event1p8Gs,
      valueCollectionOfRFInOut:
          valueCollectionOfRFInOut ?? this.valueCollectionOfRFInOut,
      exportFileName: exportFileName ?? this.exportFileName,
      dataExportPath: dataExportPath ?? this.dataExportPath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        dataRequestStatus,
        rfDataRequestStatus,
        dataExportStatus,
        dataShareStatus,
        allDataDownloadStatus,
        chunckIndex,
        hasNextChunk,
        log1p8Gs,
        dateValueCollectionOfLog,
        rfInOuts,
        valueCollectionOfRFInOut,
        event1p8Gs,
        exportFileName,
        dataExportPath,
        errorMessage,
      ];
}

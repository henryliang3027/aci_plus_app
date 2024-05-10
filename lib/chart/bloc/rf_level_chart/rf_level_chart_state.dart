part of 'rf_level_chart_bloc.dart';

class RFLevelChartState extends Equatable {
  const RFLevelChartState({
    this.rfInOutRequestStatus = FormStatus.none,
    this.valueCollectionOfRFInOut = const [[], []],
    this.rfInOuts = const [],
    this.exportFileName = '',
    this.dataExportPath = '',
    this.errorMessage = '',
  });

  final FormStatus rfInOutRequestStatus;
  final List<RFInOut> rfInOuts;
  final List<List<ValuePair>> valueCollectionOfRFInOut;
  final String exportFileName;
  final String dataExportPath;
  final String errorMessage;

  RFLevelChartState copyWith({
    FormStatus? rfInOutRequestStatus,
    List<RFInOut>? rfInOuts,
    List<List<ValuePair>>? valueCollectionOfRFInOut,
    String? exportFileName,
    String? dataExportPath,
    String? errorMessage,
  }) {
    return RFLevelChartState(
      rfInOutRequestStatus: rfInOutRequestStatus ?? this.rfInOutRequestStatus,
      rfInOuts: rfInOuts ?? this.rfInOuts,
      valueCollectionOfRFInOut:
          valueCollectionOfRFInOut ?? this.valueCollectionOfRFInOut,
      exportFileName: exportFileName ?? this.exportFileName,
      dataExportPath: dataExportPath ?? this.exportFileName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        rfInOutRequestStatus,
        rfInOuts,
        valueCollectionOfRFInOut,
        exportFileName,
        dataExportPath,
        errorMessage,
      ];
}

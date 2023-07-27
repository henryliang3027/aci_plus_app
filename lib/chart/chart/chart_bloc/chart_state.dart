part of 'chart_bloc.dart';

class ChartState extends Equatable {
  const ChartState({
    this.dataExportStatus = FormStatus.none,
    this.dataShareStatus = FormStatus.none,
    this.exportFileName = '',
    this.dataExportPath = '',
    this.errorMessage = '',
  });

  final FormStatus dataExportStatus;
  final FormStatus dataShareStatus;
  final String exportFileName;
  final String dataExportPath;
  final String errorMessage;

  ChartState copyWith({
    FormStatus? dataExportStatus,
    FormStatus? dataShareStatus,
    String? exportFileName,
    String? dataExportPath,
    String? errorMessage,
  }) {
    return ChartState(
      dataExportStatus: dataExportStatus ?? this.dataExportStatus,
      dataShareStatus: dataShareStatus ?? this.dataExportStatus,
      exportFileName: exportFileName ?? this.exportFileName,
      dataExportPath: dataExportPath ?? this.dataExportPath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        dataExportStatus,
        dataShareStatus,
        exportFileName,
        dataExportPath,
        errorMessage,
      ];
}

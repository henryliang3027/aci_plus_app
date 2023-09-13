part of 'chart18_bloc.dart';

class Chart18State extends Equatable {
  const Chart18State({
    this.dataExportStatus = FormStatus.none,
    this.dataShareStatus = FormStatus.none,
    this.allDataDownloadStatus = FormStatus.none,
    this.exportFileName = '',
    this.dataExportPath = '',
    this.errorMessage = '',
  });

  final FormStatus dataExportStatus;
  final FormStatus dataShareStatus;
  final FormStatus allDataDownloadStatus;
  final String exportFileName;
  final String dataExportPath;
  final String errorMessage;

  Chart18State copyWith({
    FormStatus? dataExportStatus,
    FormStatus? dataShareStatus,
    FormStatus? allDataExportStatus,
    String? exportFileName,
    String? dataExportPath,
    String? errorMessage,
  }) {
    return Chart18State(
      dataExportStatus: dataExportStatus ?? this.dataExportStatus,
      dataShareStatus: dataShareStatus ?? this.dataExportStatus,
      allDataDownloadStatus:
          allDataDownloadStatus ?? this.allDataDownloadStatus,
      exportFileName: exportFileName ?? this.exportFileName,
      dataExportPath: dataExportPath ?? this.dataExportPath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        dataExportStatus,
        dataShareStatus,
        allDataDownloadStatus,
        exportFileName,
        dataExportPath,
        errorMessage,
      ];
}

part of 'chart18_bloc.dart';

class Chart18State extends Equatable {
  const Chart18State({
    this.dataShareStatus = FormStatus.none,
    this.dataExportStatus = FormStatus.none,
    this.allDataExportStatus = FormStatus.none,
    this.rfLevelShareStatus = FormStatus.none,
    this.rfLevelExportStatus = FormStatus.none,
    this.exportFileName = '',
    this.dataExportPath = '',
    this.errorMessage = '',
    this.enableTabChange = true,
  });

  final bool enableTabChange;
  final FormStatus dataShareStatus;
  final FormStatus dataExportStatus;
  final FormStatus allDataExportStatus;
  final FormStatus rfLevelShareStatus;
  final FormStatus rfLevelExportStatus;
  final String exportFileName;
  final String dataExportPath;
  final String errorMessage;

  Chart18State copyWith({
    FormStatus? dataShareStatus,
    FormStatus? dataExportStatus,
    FormStatus? allDataExportStatus,
    FormStatus? rfLevelShareStatus,
    FormStatus? rfLevelExportStatus,
    String? exportFileName,
    String? dataExportPath,
    String? errorMessage,
    bool? enableTabChange,
  }) {
    return Chart18State(
      dataShareStatus: dataShareStatus ?? this.dataShareStatus,
      dataExportStatus: dataExportStatus ?? this.dataExportStatus,
      allDataExportStatus: allDataExportStatus ?? this.allDataExportStatus,
      rfLevelExportStatus: rfLevelExportStatus ?? this.rfLevelExportStatus,
      rfLevelShareStatus: rfLevelShareStatus ?? this.rfLevelShareStatus,
      exportFileName: exportFileName ?? this.exportFileName,
      dataExportPath: dataExportPath ?? this.dataExportPath,
      errorMessage: errorMessage ?? this.errorMessage,
      enableTabChange: enableTabChange ?? this.enableTabChange,
    );
  }

  @override
  List<Object> get props => [
        dataShareStatus,
        dataExportStatus,
        allDataExportStatus,
        rfLevelShareStatus,
        rfLevelExportStatus,
        exportFileName,
        dataExportPath,
        errorMessage,
        enableTabChange,
      ];
}

part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.scanStatus = FormStatus.none,
    this.connectionStatus = FormStatus.none,
    this.loadingStatus = FormStatus.none,
    this.dataExportStatus = FormStatus.none,
    this.dataShareStatus = FormStatus.none,
    this.showSplash = true,
    this.device,
    this.characteristicData = const {},
    this.errorMassage = '',
    this.dataExportPath = '',
    this.exportFileName = '',
    this.dateValueCollectionOfLog = const [],
  });

  final FormStatus scanStatus;
  final FormStatus connectionStatus;
  final FormStatus loadingStatus;
  final FormStatus dataExportStatus;
  final FormStatus dataShareStatus;
  final bool showSplash;
  final DiscoveredDevice? device;
  final Map<DataKey, String> characteristicData;
  final String errorMassage;
  final String dataExportPath;
  final String exportFileName;
  final List<List<DateValuePair>> dateValueCollectionOfLog;

  HomeState copyWith({
    FormStatus? scanStatus,
    FormStatus? connectionStatus,
    FormStatus? loadingStatus,
    FormStatus? dataExportStatus,
    FormStatus? dataShareStatus,
    bool? showSplash,
    DiscoveredDevice? device,
    Map<DataKey, String>? characteristicData,
    String? errorMassage,
    String? dataExportPath,
    String? exportFileName,
    List<List<DateValuePair>>? dateValueCollectionOfLog,
  }) {
    return HomeState(
      scanStatus: scanStatus ?? this.scanStatus,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      dataExportStatus: dataExportStatus ?? this.dataExportStatus,
      dataShareStatus: dataShareStatus ?? this.dataShareStatus,
      showSplash: showSplash ?? this.showSplash,
      device: device ?? this.device,
      characteristicData: characteristicData ?? this.characteristicData,
      errorMassage: errorMassage ?? this.errorMassage,
      dataExportPath: dataExportPath ?? this.dataExportPath,
      exportFileName: exportFileName ?? this.exportFileName,
      dateValueCollectionOfLog:
          dateValueCollectionOfLog ?? this.dateValueCollectionOfLog,
    );
  }

  @override
  List<Object?> get props => [
        scanStatus,
        connectionStatus,
        loadingStatus,
        dataExportStatus,
        dataShareStatus,
        showSplash,
        device,
        characteristicData,
        errorMassage,
        dataExportPath,
        exportFileName,
        dateValueCollectionOfLog,
      ];
}

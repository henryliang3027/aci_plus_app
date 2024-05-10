part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.scanStatus = FormStatus.none,
    this.connectionStatus = FormStatus.none,
    this.loadingStatus = FormStatus.none,
    this.eventLoadingStatus = FormStatus.none,
    this.dataExportStatus = FormStatus.none,
    this.dataShareStatus = FormStatus.none,
    this.showSplash = true,
    this.aciDeviceType = ACIDeviceType.undefined,
    this.device,
    this.characteristicData = const {},
    this.errorMassage = '',
    this.dateValueCollectionOfLog = const [],
  });

  final FormStatus scanStatus;
  final FormStatus connectionStatus;
  final FormStatus loadingStatus;
  final FormStatus eventLoadingStatus;
  final FormStatus dataExportStatus;
  final FormStatus dataShareStatus;

  final bool showSplash;
  final ACIDeviceType aciDeviceType;
  final Perigheral? device;
  final Map<DataKey, String> characteristicData;
  final String errorMassage;
  final List<List<ValuePair>> dateValueCollectionOfLog;

  HomeState copyWith({
    FormStatus? scanStatus,
    FormStatus? connectionStatus,
    FormStatus? loadingStatus,
    FormStatus? eventLoadingStatus,
    FormStatus? dataExportStatus,
    FormStatus? dataShareStatus,
    bool? showSplash,
    ACIDeviceType? aciDeviceType,
    Perigheral? device,
    Map<DataKey, String>? characteristicData,
    String? errorMassage,
    List<List<ValuePair>>? dateValueCollectionOfLog,
  }) {
    return HomeState(
      scanStatus: scanStatus ?? this.scanStatus,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      eventLoadingStatus: eventLoadingStatus ?? this.eventLoadingStatus,
      dataExportStatus: dataExportStatus ?? this.dataExportStatus,
      dataShareStatus: dataShareStatus ?? this.dataShareStatus,
      showSplash: showSplash ?? this.showSplash,
      aciDeviceType: aciDeviceType ?? this.aciDeviceType,
      device: device ?? this.device,
      characteristicData: characteristicData != null
          ? Map<DataKey, String>.from(characteristicData)
          : this.characteristicData,
      errorMassage: errorMassage ?? this.errorMassage,
      dateValueCollectionOfLog:
          dateValueCollectionOfLog ?? this.dateValueCollectionOfLog,
    );
  }

  @override
  List<Object?> get props => [
        scanStatus,
        connectionStatus,
        loadingStatus,
        eventLoadingStatus,
        dataExportStatus,
        dataShareStatus,
        showSplash,
        aciDeviceType,
        device,
        characteristicData,
        errorMassage,
        dateValueCollectionOfLog,
      ];
}

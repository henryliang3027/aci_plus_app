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
    this.mtu = 0,
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
  final int mtu;
  final DiscoveredDevice? device;
  final Map<DataKey, String> characteristicData;
  final String errorMassage;
  final List<List<DateValuePair>> dateValueCollectionOfLog;

  HomeState copyWith({
    FormStatus? scanStatus,
    FormStatus? connectionStatus,
    FormStatus? loadingStatus,
    FormStatus? eventLoadingStatus,
    FormStatus? dataExportStatus,
    FormStatus? dataShareStatus,
    bool? showSplash,
    int? mtu,
    DiscoveredDevice? device,
    Map<DataKey, String>? characteristicData,
    String? errorMassage,
    List<List<DateValuePair>>? dateValueCollectionOfLog,
  }) {
    return HomeState(
      scanStatus: scanStatus ?? this.scanStatus,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      eventLoadingStatus: eventLoadingStatus ?? this.eventLoadingStatus,
      dataExportStatus: dataExportStatus ?? this.dataExportStatus,
      dataShareStatus: dataShareStatus ?? this.dataShareStatus,
      showSplash: showSplash ?? this.showSplash,
      mtu: mtu ?? this.mtu,
      device: device ?? this.device,
      characteristicData: characteristicData ?? this.characteristicData,
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
        mtu,
        device,
        characteristicData,
        errorMassage,
        dateValueCollectionOfLog,
      ];
}

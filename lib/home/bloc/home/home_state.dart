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
    this.periodicUpdateEnabled = false,
    this.ceqStatus = CEQStatus.none,
    this.aciDeviceType = ACIDeviceType.undefined,
    this.peripherals = const [],
    this.device = const Peripheral.empty(),
    this.characteristicData = const {},
    this.errorMassage = '',
    this.dateValueCollectionOfLog = const [],

    // this.isReloadData = false,
  });

  final FormStatus scanStatus;
  final FormStatus connectionStatus;
  final FormStatus loadingStatus;
  final FormStatus eventLoadingStatus;
  final FormStatus dataExportStatus;
  final FormStatus dataShareStatus;
  final bool showSplash;
  final bool periodicUpdateEnabled;
  final CEQStatus ceqStatus;
  final ACIDeviceType aciDeviceType;
  final List<Peripheral> peripherals;
  final Peripheral device;
  final Map<DataKey, String> characteristicData;
  final String errorMassage;
  final List<List<ValuePair>> dateValueCollectionOfLog;

  // final bool isReloadData;

  HomeState copyWith({
    FormStatus? scanStatus,
    FormStatus? connectionStatus,
    FormStatus? loadingStatus,
    FormStatus? eventLoadingStatus,
    FormStatus? dataExportStatus,
    FormStatus? dataShareStatus,
    bool? showSplash,
    bool? periodicUpdateEnabled,
    CEQStatus? ceqStatus,
    ACIDeviceType? aciDeviceType,
    List<Peripheral>? peripherals,
    Peripheral? device,
    Map<DataKey, String>? characteristicData,
    String? errorMassage,
    List<List<ValuePair>>? dateValueCollectionOfLog,
    // bool? isReloadData,
  }) {
    return HomeState(
      scanStatus: scanStatus ?? this.scanStatus,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      eventLoadingStatus: eventLoadingStatus ?? this.eventLoadingStatus,
      dataExportStatus: dataExportStatus ?? this.dataExportStatus,
      dataShareStatus: dataShareStatus ?? this.dataShareStatus,
      showSplash: showSplash ?? this.showSplash,
      periodicUpdateEnabled:
          periodicUpdateEnabled ?? this.periodicUpdateEnabled,
      ceqStatus: ceqStatus ?? this.ceqStatus,
      aciDeviceType: aciDeviceType ?? this.aciDeviceType,
      peripherals: peripherals ?? this.peripherals,
      device: device ?? this.device,
      characteristicData: characteristicData != null
          ? Map<DataKey, String>.from(characteristicData)
          : this.characteristicData,
      errorMassage: errorMassage ?? this.errorMassage,
      dateValueCollectionOfLog:
          dateValueCollectionOfLog ?? this.dateValueCollectionOfLog,
      // isReloadData: isReloadData ?? this.isReloadData,
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
        periodicUpdateEnabled,
        ceqStatus,
        aciDeviceType,
        peripherals,
        device,
        characteristicData,
        errorMassage,
        dateValueCollectionOfLog,
        // isReloadData,
      ];
}

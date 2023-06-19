part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.scanStatus = FormStatus.none,
    this.connectionStatus = FormStatus.none,
    this.submissionStatus = SubmissionStatus.none,
    this.showSplash = true,
    this.device,
    this.characteristicData = const {},
    this.settingResultData = const {
      DataKey.locationSet: '-1',
      DataKey.tgcCableLengthSet: '-1',
      DataKey.logIntervalSet: '-1',
    },
    this.errorMassage = '',
  });

  final FormStatus scanStatus;
  final FormStatus connectionStatus;
  final SubmissionStatus submissionStatus;
  final bool showSplash;
  final DiscoveredDevice? device;
  final Map<DataKey, String> characteristicData;
  final Map<DataKey, String> settingResultData;
  final String errorMassage;

  HomeState copyWith({
    FormStatus? scanStatus,
    FormStatus? connectionStatus,
    SubmissionStatus? submissionStatus,
    bool? showSplash,
    DiscoveredDevice? device,
    Map<DataKey, String>? characteristicData,
    Map<DataKey, String>? settingResultData,
    String? errorMassage,
  }) {
    return HomeState(
      scanStatus: scanStatus ?? this.scanStatus,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      showSplash: showSplash ?? this.showSplash,
      device: device ?? this.device,
      characteristicData: characteristicData ?? this.characteristicData,
      settingResultData: settingResultData ?? this.settingResultData,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props => [
        scanStatus,
        connectionStatus,
        submissionStatus,
        showSplash,
        device,
        characteristicData,
        settingResultData,
        errorMassage,
      ];
}

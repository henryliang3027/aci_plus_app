part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = FormStatus.none,
    this.connectionStatus = FormStatus.none,
    this.showSplash = true,
    this.device,
    this.characteristicData = const {},
    this.errorMassage = '',
  });

  final FormStatus status;
  final FormStatus connectionStatus;
  final bool showSplash;
  final DiscoveredDevice? device;
  final Map<DataKey, String> characteristicData;
  final String errorMassage;

  HomeState copyWith({
    FormStatus? status,
    FormStatus? connectionStatus,
    bool? showSplash,
    DiscoveredDevice? device,
    Map<DataKey, String>? characteristicData,
    String? errorMassage,
  }) {
    return HomeState(
      status: status ?? this.status,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      showSplash: showSplash ?? this.showSplash,
      device: device ?? this.device,
      characteristicData: characteristicData ?? this.characteristicData,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        connectionStatus,
        showSplash,
        device,
        characteristicData,
        errorMassage,
      ];
}

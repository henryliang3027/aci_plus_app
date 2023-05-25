part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = FormStatus.none,
    this.connectionStatus = FormStatus.none,
    this.device,
    this.characteristicData = const {},
    this.errorMassage = '',
  });

  final FormStatus status;
  final FormStatus connectionStatus;
  final DiscoveredDevice? device;
  final Map<DataKey, String> characteristicData;
  final String errorMassage;

  HomeState copyWith({
    FormStatus? status,
    FormStatus? connectionStatus,
    DiscoveredDevice? device,
    Map<DataKey, String>? characteristicData,
    String? errorMassage,
  }) {
    return HomeState(
      status: status ?? this.status,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      device: device ?? this.device,
      characteristicData: characteristicData ?? this.characteristicData,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        connectionStatus,
        device,
        characteristicData,
        errorMassage,
      ];
}

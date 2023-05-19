part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = FormStatus.none,
    this.connectionStatus = FormStatus.none,
    this.device,
    this.typeNo = '',
    this.partNo = '',
    this.location = '',
    this.dsimMode = '',
    this.currentPilot = '',
    this.logInterval = '',
    this.errorMassage = '',
  });

  final FormStatus status;
  final FormStatus connectionStatus;
  final DiscoveredDevice? device;
  final String typeNo;
  final String partNo;
  final String location;
  final String dsimMode;
  final String currentPilot;
  final String logInterval;
  final String errorMassage;

  HomeState copyWith({
    FormStatus? status,
    FormStatus? connectionStatus,
    DiscoveredDevice? device,
    String? typeNo,
    String? partNo,
    String? location,
    String? dsimMode,
    String? currentPilot,
    String? logInterval,
    String? errorMassage,
  }) {
    return HomeState(
      status: status ?? this.status,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      device: device ?? this.device,
      typeNo: typeNo ?? this.typeNo,
      partNo: partNo ?? this.partNo,
      location: location ?? this.location,
      dsimMode: dsimMode ?? this.dsimMode,
      currentPilot: currentPilot ?? this.currentPilot,
      logInterval: logInterval ?? this.logInterval,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        connectionStatus,
        device,
        typeNo,
        partNo,
        location,
        dsimMode,
        currentPilot,
        logInterval,
        errorMassage,
      ];
}

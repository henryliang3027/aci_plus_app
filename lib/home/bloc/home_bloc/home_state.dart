part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = FormStatus.none,
    this.device,
  });

  final FormStatus status;
  final DiscoveredDevice? device;

  HomeState copyWith({
    FormStatus? status,
    DiscoveredDevice? device,
  }) {
    return HomeState(
      status: status ?? this.status,
      device: device ?? this.device,
    );
  }

  @override
  List<Object?> get props => [
        status,
        device,
      ];
}

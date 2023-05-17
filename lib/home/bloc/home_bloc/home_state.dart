part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = FormStatus.none,
    this.device,
    this.errorMassage = '',
  });

  final FormStatus status;
  final DiscoveredDevice? device;
  final String errorMassage;

  HomeState copyWith({
    FormStatus? status,
    DiscoveredDevice? device,
    String? errorMassage,
  }) {
    return HomeState(
      status: status ?? this.status,
      device: device ?? this.device,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        device,
        errorMassage,
      ];
}

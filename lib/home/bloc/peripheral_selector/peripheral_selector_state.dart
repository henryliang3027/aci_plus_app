part of 'peripheral_selector_bloc.dart';

class PeripheralSelectorState extends Equatable {
  const PeripheralSelectorState({
    this.peripherals = const [],
  });

  final List<Peripheral> peripherals;

  PeripheralSelectorState copyWith({
    List<Peripheral>? peripherals,
  }) {
    return PeripheralSelectorState(
      peripherals: peripherals ?? this.peripherals,
    );
  }

  @override
  List<Object> get props => [peripherals];
}

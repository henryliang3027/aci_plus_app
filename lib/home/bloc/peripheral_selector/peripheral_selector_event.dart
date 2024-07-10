part of 'peripheral_selector_bloc.dart';

sealed class PeripheralSelectorEvent extends Equatable {
  const PeripheralSelectorEvent();

  @override
  List<Object> get props => [];
}

class PeripheralChanged extends PeripheralSelectorEvent {
  const PeripheralChanged(this.peripherals);

  final List<Peripheral> peripherals;

  @override
  List<Object> get props => [peripherals];
}

import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'peripheral_selector_event.dart';
part 'peripheral_selector_state.dart';

class PeripheralSelectorBloc
    extends Bloc<PeripheralSelectorEvent, PeripheralSelectorState> {
  PeripheralSelectorBloc({
    required ACIDeviceRepository aciDeviceRepository,
  })  : _aciDeviceRepository = aciDeviceRepository,
        super(const PeripheralSelectorState()) {
    on<PeripheralChanged>(_onPeripheralChanged);
  }

  final ACIDeviceRepository _aciDeviceRepository;

  void _onPeripheralChanged(
    PeripheralChanged event,
    Emitter<PeripheralSelectorState> emit,
  ) {
    emit(state.copyWith(peripherals: event.peripherals));
  }
}

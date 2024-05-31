import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_firmware_event.dart';
part 'setting18_firmware_state.dart';

class Setting18FirmwareBloc
    extends Bloc<Setting18FirmwareEvent, Setting18FirmwareState> {
  Setting18FirmwareBloc({
    required FirmwareRepository firmwareRepository,
  })  : _firmwareRepository = firmwareRepository,
        super(const Setting18FirmwareState()) {
    on<BinaryDataLoaded>(_onBinaryDataLoaded);
    on<BootloaderStarted>(_onBootloaderStarted);
    on<UpdateStarted>(_onUpdateStarted);

    print('BinaryDataLoaded');

    add(const BinaryDataLoaded());
  }

  final FirmwareRepository _firmwareRepository;

  Future<void> _onBinaryDataLoaded(
    BinaryDataLoaded event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    List<dynamic> result = await _firmwareRepository.calculateCheckSum();
  }

  void _onUpdateStarted(
    UpdateStarted event,
    Emitter<Setting18FirmwareState> emit,
  ) {}

  Future<void> _onBootloaderStarted(
    BootloaderStarted event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    var result = await _firmwareRepository.exitBootloader();

    print('enter bootloader result $result');
  }
}

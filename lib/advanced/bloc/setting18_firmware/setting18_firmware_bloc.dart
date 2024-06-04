import 'dart:async';

import 'package:aci_plus_app/core/firmware_file_table.dart';
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
    on<BootloaderExited>(_onBootloaderExited);
    on<UpdateStarted>(_onUpdateStarted);
    on<CommandWrited>(_onCommandWrited);
    on<MessageReceived>(_onMessageReceived);
    on<BinarySelected>(_onBinarySelected);

    print('BinaryDataLoaded');

    _updateReportStreamSubscription =
        _firmwareRepository.updateReport.listen((data) {
      String message = String.fromCharCodes(data);

      if (message.startsWith('Write AP2')) {
        _firmwareRepository.updateFirmware(binary: state.binary);
      }

      add(MessageReceived(message));
    });

    add(BinarySelected(state.selectedBinary));
  }

  final FirmwareRepository _firmwareRepository;
  StreamSubscription<List<int>>? _updateReportStreamSubscription;

  Future<void> _onBinaryDataLoaded(
    BinaryDataLoaded event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    // List<dynamic> result = await _firmwareRepository.calculateCheckSum();

    // if (result[0]) {
    //   int sum = result[1];
    //   List<int> binary = result[2];

    //   emit(state.copyWith(
    //     formStatus: FormStatus.requestSuccess,
    //     sum: sum,
    //     binary: binary,
    //   ));
    // } else {
    //   emit(state.copyWith(
    //     formStatus: FormStatus.requestFailure,
    //   ));
    // }
  }

  void _onMessageReceived(
    MessageReceived event,
    Emitter<Setting18FirmwareState> emit,
  ) {
    emit(state.copyWith(
      updateMessage: event.message,
    ));
  }

  Future<void> _onUpdateStarted(
    UpdateStarted event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    _firmwareRepository.updateFirmware(binary: state.binary);
  }

  Future<void> _onBootloaderStarted(
    BootloaderStarted event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    _firmwareRepository.enterBootloader();
  }

  Future<void> _onBootloaderExited(
    BootloaderExited event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    _firmwareRepository.exitBootloader();

    emit(state.copyWith(updateMessage: 'Main'));
  }

  Future<void> _onCommandWrited(
    CommandWrited event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    List<int> cmd = event.character.codeUnits;

    _firmwareRepository.writeCommand(cmd);
  }

  Future<void> _onBinarySelected(
    BinarySelected event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    String binaryPath =
        FirmwareFileTable.filePathMap[event.selectedPartId] ?? '';

    List<dynamic> result =
        await _firmwareRepository.calculateCheckSum(binaryPath: binaryPath);

    if (result[0]) {
      int sum = result[1];
      List<int> binary = result[2];

      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        sum: sum,
        binary: binary,
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
      ));
    }

    emit(state.copyWith(selectedBinary: event.selectedPartId));
  }

  @override
  Future<void> close() {
    _updateReportStreamSubscription?.cancel();
    return super.close();
  }
}

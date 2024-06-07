import 'dart:async';
import 'dart:convert';

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
    on<BootloaderStarted>(_onBootloaderStarted);
    on<BootloaderExited>(_onBootloaderExited);
    on<UpdateStarted>(_onUpdateStarted);
    on<CommandWrited>(_onCommandWrited);
    on<MessageReceived>(_onMessageReceived);
    on<ErrorReceived>(_onErrorReceived);
    on<BinarySelected>(_onBinarySelected);

    add(BinarySelected(state.selectedBinary));
  }

  final FirmwareRepository _firmwareRepository;
  StreamSubscription<String>? _updateReportStreamSubscription;
  Timer? _enterBootloaderTimer;

  void _listenUpdateReport() {
    _updateReportStreamSubscription =
        _firmwareRepository.updateReport.listen((message) {
      double currentProgress = 0.0;

      if (message.startsWith('Bootloader')) {
        if (_enterBootloaderTimer != null) {
          _enterBootloaderTimer!.cancel();
        }

        if (!state.updateCanceled) {
          // 正常流程
          // write 'C'
          print('===============C==================');
          _firmwareRepository.writeCommand([0x43]);
        } else {
          // 出錯之後, 使用者取消更新,
          // write 'N'
          print('===============N==================');
          _firmwareRepository.writeCommand([0x4E]);

          // 暫停 stream 來重置 timeout 的 countdown
          _updateReportStreamSubscription?.pause();
        }

        currentProgress = 0.1;
      } else if (message.startsWith('Write AP2')) {
        currentProgress = 0.2;
        _firmwareRepository.updateFirmware(binary: state.binary);
      } else if (message.startsWith('Sending')) {
        List<String> splitted = message.split(' ');
        currentProgress = 1.0;
        int indexOfChunk = int.parse(splitted[1]);
        int chunkLength = int.parse(splitted[2]);

        currentProgress =
            _roundToSecondDecimalPlace(0.3 + indexOfChunk / chunkLength * 0.4);
        print(
            'round cp: ${_roundToSecondDecimalPlace(0.3 + indexOfChunk / chunkLength * 0.4)}');

        message = '$indexOfChunk / $chunkLength';
      } else if (message.contains('Wait "Y"')) {
        LineSplitter lineSplitter = const LineSplitter();
        List<String> splitted = lineSplitter.convert(message);

        String receivedHexSum = splitted[0];
        String receivedHexBinaryLength = splitted[1];

        String hexSum = state.sum.toRadixString(16);

        // receivedHexSum 是大寫字母, 所以轉成大寫來比較
        String targetHexSum =
            hexSum.substring(hexSum.length - 4, hexSum.length).toUpperCase();
        String targetHexBinaryLength =
            state.binary.length.toRadixString(16).toUpperCase();

        print('$receivedHexSum : $targetHexSum');
        print('$receivedHexBinaryLength : $targetHexBinaryLength');

        if (receivedHexSum == targetHexSum &&
            receivedHexBinaryLength == targetHexBinaryLength) {
          // write 'Y'
          print('===============Y==================');
          _firmwareRepository.writeCommand([0x59]);
        } else {
          // 發出 Error event, 由使用者決定重試或取消
          add(const ErrorReceived(errorMessage: 'Checksum mismatch'));
        }
      } else if (message.startsWith('Clean AP1')) {
        currentProgress = 0.8;
      } else if (message.startsWith('Write AP1')) {
        currentProgress = 0.9;
      } else if (message.startsWith('Run AP1')) {
        currentProgress = 1.0;
      } else {
        currentProgress = state.currentProgress;
      }
      add(MessageReceived(message: message, currentProgress: currentProgress));
    }, onError: (error) {
      print('onError: $error');
      add(ErrorReceived(errorMessage: error));
    });
  }

  double _roundToSecondDecimalPlace(double value) {
    num mod = 100;
    return ((value * mod).round().toDouble() / mod);
  }

  void _onMessageReceived(
    MessageReceived event,
    Emitter<Setting18FirmwareState> emit,
  ) {
    if (event.message.startsWith('Run AP1')) {
      _updateReportStreamSubscription?.cancel();
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionSuccess,
        updateMessage: event.message,
        currentProgress: event.currentProgress,
      ));
    } else {
      emit(state.copyWith(
        updateMessage: event.message,
        currentProgress: event.currentProgress,
      ));
    }
  }

  void _onErrorReceived(
    ErrorReceived event,
    Emitter<Setting18FirmwareState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionFailure,
      errorMessage: event.errorMessage,
    ));
  }

  // 在 Bootloader 模式下重新傳遞 binary
  void _onUpdateStarted(
    UpdateStarted event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    // 暫停 stream 來重置 timeout 的 countdown
    _updateReportStreamSubscription?.pause();

    // 恢復 stream
    _updateReportStreamSubscription?.resume();

    //開始傳遞 binary
    _firmwareRepository.updateFirmware(binary: state.binary);
  }

  // 使用者觸發 Start 後, 嘗試進入 Bootloader
  Future<void> _onBootloaderStarted(
    BootloaderStarted event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    _listenUpdateReport();

    _enterBootloaderTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      print('write enter bootloader cmd: ${timer.tick}');
      _firmwareRepository.enterBootloader();
    });
  }

  // 更新過程失敗, 取消重試後退出 Bootloader
  Future<void> _onBootloaderExited(
    BootloaderExited event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
    ));

    emit(state.copyWith(
      updateCanceled: true,
    ));

    // Write N
    _firmwareRepository.writeCommand([0x4E]);

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

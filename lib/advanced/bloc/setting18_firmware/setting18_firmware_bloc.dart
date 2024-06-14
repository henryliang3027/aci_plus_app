import 'dart:async';
import 'dart:convert';

import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/firmware_file_table.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'setting18_firmware_event.dart';
part 'setting18_firmware_state.dart';

class Setting18FirmwareBloc
    extends Bloc<Setting18FirmwareEvent, Setting18FirmwareState> {
  Setting18FirmwareBloc({
    required FirmwareRepository firmwareRepository,
    required AppLocalizations appLocalizations,
  })  : _firmwareRepository = firmwareRepository,
        _appLocalizations = appLocalizations,
        super(const Setting18FirmwareState()) {
    on<BootloaderStarted>(_onBootloaderStarted);
    on<BootloaderExited>(_onBootloaderExited);
    on<BootloaderForceExited>(_onBootloaderForceExited);
    on<UpdateStarted>(_onUpdateStarted);
    on<CommandWrited>(_onCommandWrited);
    on<MessageReceived>(_onMessageReceived);
    on<ErrorReceived>(_onErrorReceived);
    on<BinarySelected>(_onBinarySelected);

    add(BinarySelected(state.selectedBinary));
  }

  final FirmwareRepository _firmwareRepository;
  final AppLocalizations _appLocalizations;
  StreamSubscription<String>? _updateReportStreamSubscription;
  Timer? _enterBootloaderTimer;
  final Stopwatch _stopwatch = Stopwatch();

  // 檢查是否收到 checksum 的 flag
  bool _isReceivedChecksum = false;

  final int _chunkSize = 244;

  void _listenUpdateReport() {
    _updateReportStreamSubscription =
        _firmwareRepository.updateReport.listen((message) {
      double currentProgress = 0.0;
      String displayMessage = '';

      if (message.startsWith('Bootloader')) {
        _cancelEnterBootloaderTimer(); // 成功進入 Bootloader, 停止 timer

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
        displayMessage = _appLocalizations.readyToSend;
      } else if (message.startsWith('Write AP2')) {
        _transferBinary(); // 開始傳送 binary
        currentProgress = 0.2;
        displayMessage = _appLocalizations.readyToSend;
      } else if (message.startsWith('Sent')) {
        List<String> splitted = message.split(' ');
        int indexOfChunk = int.parse(splitted[1]);

        int currentSize = indexOfChunk * _chunkSize;
        int totalSize = state.binary.length;

        currentProgress =
            _roundToSecondDecimalPlace(0.3 + currentSize / totalSize * 0.4);
        // print(
        //     'round cp: ${_roundToSecondDecimalPlace(0.3 + indexOfChunk / chunkLength * 0.4)}');

        displayMessage =
            '${_appLocalizations.sendingBinary} $currentSize ${CustomStyle.bytes} / $totalSize ${CustomStyle.bytes}';
      } else if (message.contains('Wait "Y"')) {
        _isReceivedChecksum = true; // 收到 checksum 立馬設為 true

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

        currentProgress = 0.7;
        displayMessage = _appLocalizations.verifying;
      } else if (message.startsWith('Clean AP1')) {
        currentProgress = 0.8;
        displayMessage = _appLocalizations.updatingFirmware;
      } else if (message.startsWith('Write AP1')) {
        currentProgress = 0.9;
        displayMessage = _appLocalizations.updatingFirmware;
      } else if (message.startsWith('Run AP1')) {
        currentProgress = 1.0;
        displayMessage = _appLocalizations.updateComplete;
      } else {
        currentProgress = state.currentProgress;
        displayMessage = state.updateMessage;
      }
      add(MessageReceived(
          message: displayMessage, currentProgress: currentProgress));
    }, onError: (error) {
      print('onError: $error');
      add(ErrorReceived(errorMessage: error));
    });
  }

  double _roundToSecondDecimalPlace(double value) {
    num mod = 100;
    return ((value * mod).round().toDouble() / mod);
  }

  Future<void> _onMessageReceived(
    MessageReceived event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    if (event.message == _appLocalizations.updateComplete) {
      _updateReportStreamSubscription?.cancel();

      // 收到完成訊息('Run AP1')後, 多等待一段時間, 再提示完成 dialog, 按下OK, 接著讀取基本資訊就可以很快讀到
      // 測試發現若更新 SDLE 完成後提示完成並馬上按下OK, 接著讀取基本資訊就要等待10秒才讀到
      await Future.delayed(const Duration(milliseconds: 3500));

      _stopwatch.stop();
      String formattedTimeElapsed =
          _formatTimeElapsed(_stopwatch.elapsed.inSeconds);

      emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionSuccess,
        formattedTimeElapsed: formattedTimeElapsed,
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
    // 重新傳送時將 checksum flag 設為 false
    _isReceivedChecksum = false;

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
      updateCanceled: false,
    ));

    // 暫停 stream 來重置 timeout 的 countdown
    _updateReportStreamSubscription?.pause();

    // 恢復 stream
    _updateReportStreamSubscription?.resume();

    // Write N, 回到 bootloader ... wait "C"
    _firmwareRepository.writeCommand([0x4E]);

    //開始傳遞 binary
    // _firmwareRepository.updateFirmware(binary: state.binary);
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
    _stopwatch.start(); // 用來計算更新耗時多少時間, 開始計時
    _enterBootloaderTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      print('write enter bootloader cmd: ${timer.tick}');
      if (timer.tick < 50) {
        _firmwareRepository.enterBootloader();
      } else {
        _cancelEnterBootloaderTimer(); // 沒有成功進入 Bootloader, 停止 timer
      }
    });
  }

  // 更新過程失敗, 取消重試後退出 Bootloader
  Future<void> _onBootloaderExited(
    BootloaderExited event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    // 重新傳送時將 checksum flag 設為 false
    _isReceivedChecksum = false;

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      updateCanceled: true,
    ));

    // Write N
    _firmwareRepository.writeCommand([0x4E]);

    emit(state.copyWith(updateMessage: 'Main'));
  }

  // 更新過程出現checksum 錯誤或 timeout , 強制退出 Bootloader
  Future<void> _onBootloaderForceExited(
    BootloaderForceExited event,
    Emitter<Setting18FirmwareState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      updateCanceled: true,
    ));

    if (event.cmd == 'N') {
      // Write N
      _firmwareRepository.writeCommand([0x4E]);
    } else {
      _firmwareRepository.exitBootloader();
    }

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

    String selectedVersion =
        _getSelectedFirmwareVersion(binaryPath: binaryPath);

    List<dynamic> result =
        await _firmwareRepository.calculateCheckSum(binaryPath: binaryPath);

    if (result[0]) {
      int sum = result[1];
      List<int> binary = result[2];

      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        sum: sum,
        binary: binary,
        selectedVersion: selectedVersion,
      ));
    } else {
      emit(state.copyWith(
        formStatus: FormStatus.requestFailure,
      ));
    }

    emit(state.copyWith(selectedBinary: event.selectedPartId));
  }

  void _cancelEnterBootloaderTimer() {
    if (_enterBootloaderTimer != null) {
      _enterBootloaderTimer!.cancel();
    }
  }

  String _formatTimeElapsed(int elapseInSeconds) {
    int minutes = elapseInSeconds ~/ 60;
    int seconds = elapseInSeconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  String _getSelectedFirmwareVersion({
    required String binaryPath,
  }) {
    String splitBySlash = binaryPath.split('/').last;
    String filename = splitBySlash.split('.')[0];
    String version = filename.split('_')[1].substring(1);

    return version;
  }

  Future<void> _transferBinary() async {
    // 將 binary 切分成每個大小為 chunkSize 的封包
    List<List<int>> chunks = _firmwareRepository.divideToChunkList(
      binary: state.binary,
      chunkSize: _chunkSize,
    );

    for (int i = 0; i < chunks.length; i++) {
      if (!_isReceivedChecksum) {
        await _firmwareRepository.transferBinaryChunk(
          chunk: chunks[i],
          indexOfChunk: i,
        );
      } else {
        break;
      }
    }
  }

  @override
  Future<void> close() {
    _updateReportStreamSubscription?.cancel();
    return super.close();
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/code_repository.dart';
import 'package:aci_plus_app/repositories/connection_client_factory.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'setting18_firmware_update_event.dart';
part 'setting18_firmware_update_state.dart';

class Setting18FirmwareUpdateBloc
    extends Bloc<Setting18FirmwareUpdateEvent, Setting18FirmwareUpdateState> {
  Setting18FirmwareUpdateBloc({
    required AppLocalizations appLocalizations,
    required FirmwareRepository firmwareRepository,
    required CodeRepository codeRepository,
    required ACIDeviceRepository aciDeviceRepository,
  })  : _appLocalizations = appLocalizations,
        _firmwareRepository = firmwareRepository,
        _aciDeviceRepository = aciDeviceRepository,
        _codeRepository = codeRepository,
        super(const Setting18FirmwareUpdateState()) {
    on<BootloaderStarted>(_onBootloaderStarted);
    on<BootloaderExited>(_onBootloaderExited);
    on<BootloaderForceExited>(_onBootloaderForceExited);
    on<UpdateStarted>(_onUpdateStarted);
    on<CommandWrited>(_onCommandWrited);
    on<MessageReceived>(_onMessageReceived);
    on<ErrorReceived>(_onErrorReceived);
    on<BinarySelected>(_onBinarySelected);
    // on<BinaryLoaded>(_onBinaryLoaded);
    on<BinaryCanceled>(_onBinaryCanceled);
    on<UpdateLogAdded>(_onUpdateLogAdded);
  }

  final AppLocalizations _appLocalizations;
  final FirmwareRepository _firmwareRepository;
  final CodeRepository _codeRepository;
  final ACIDeviceRepository _aciDeviceRepository;
  StreamSubscription<String>? _updateReportStreamSubscription;
  Timer? _enterBootloaderTimer;
  final Stopwatch _stopwatch = Stopwatch();

  // 檢查是否收到 checksum 的 flag
  bool _isReceivedChecksumOrDisconnected = false;

  int _chunkSize = 244;
  int _chunkLength = 0;

  void _listenUpdateReport() {
    _updateReportStreamSubscription =
        _firmwareRepository.updateReport.listen((message) {
      double currentProgress = 0.0;
      String displayMessage = '';
      BinaryCheckResult binaryCheckResult = state.binaryCheckResult;

      if (message.startsWith('Bootloader')) {
        _cancelEnterBootloaderTimer(); // 成功進入 Bootloader, 停止 timer

        if (!state.updateCanceled) {
          // 正常流程
          // write 'C'
          print('===============C==================');
          _firmwareRepository.writeCommand([0x43]);
          currentProgress = 0.1;
          displayMessage = _appLocalizations.readyToSend;
        } else {
          // 出錯之後, 使用者取消更新,
          // write 'N'
          print('===============N==================');
          _firmwareRepository.writeCommand([0x4E]);

          // 暫停 stream 來重置 timeout 的 countdown
          _updateReportStreamSubscription?.pause();
          currentProgress = 0.0;
          displayMessage = _appLocalizations.dialogMessageCancel;
        }
      } else if (message.startsWith('Write AP2')) {
        _transferBinary(); // 開始傳送 binary
        currentProgress = 0.2;
        displayMessage = _appLocalizations.readyToSend;
      } else if (message.startsWith('Sent')) {
        List<String> splitted = message.split(' ');
        int indexOfChunk = int.parse(splitted[1]);

        // indexOfChunk == _chunkLength 時直接等於 binary size, 因為最後一個封包不一定滿244
        int currentSize = indexOfChunk < _chunkLength - 1
            ? (indexOfChunk + 1) * _chunkSize
            : binaryCheckResult.binary.length;
        int totalSize = binaryCheckResult.binary.length;

        currentProgress =
            _roundToSecondDecimalPlace(0.3 + currentSize / totalSize * 0.4);
        // print(
        //     'round cp: ${_roundToSecondDecimalPlace(0.3 + indexOfChunk / chunkLength * 0.4)}');

        displayMessage =
            '${_appLocalizations.sendingBinary} $currentSize ${CustomStyle.bytes} / $totalSize ${CustomStyle.bytes}';
      } else if (message.contains('Wait "Y"')) {
        _isReceivedChecksumOrDisconnected = true; // 收到 checksum 立馬設為 true

        LineSplitter lineSplitter = const LineSplitter();
        List<String> splitted = lineSplitter.convert(message);

        String receivedHexSum = splitted[0];
        String receivedHexBinaryLength = splitted[1];

        String hexSum = binaryCheckResult.sum.toRadixString(16);

        // receivedHexSum 是大寫字母, 所以轉成大寫來比較
        String targetHexSum =
            hexSum.substring(hexSum.length - 4, hexSum.length).toUpperCase();
        String targetHexBinaryLength =
            binaryCheckResult.binary.length.toRadixString(16).toUpperCase();

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
        message: displayMessage,
        currentProgress: currentProgress,
      ));
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
    Emitter<Setting18FirmwareUpdateState> emit,
  ) async {
    if (event.message == _appLocalizations.updateComplete) {
      _updateReportStreamSubscription?.cancel();

      // 收到完成訊息('Run AP1')後, 多等待一段時間, 再提示完成 dialog, 按下OK, 接著讀取基本資訊就可以很快讀到
      // 測試發現若更新 SDLE 完成後提示完成並馬上按下OK, 接著讀取基本資訊就要等待10秒才讀到
      await Future.delayed(const Duration(milliseconds: 3500));

      _stopwatch.stop();
      String formattedTimeElapsed =
          _formatTimeElapsed(_stopwatch.elapsed.inSeconds);

      // 將 android system back button 設為可點擊
      SystemBackButtonProperty.isEnabled = true;

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
    Emitter<Setting18FirmwareUpdateState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionFailure,
      errorMessage: event.errorMessage,
    ));

    //有可能是收到 checksum錯誤或已經斷線
    _isReceivedChecksumOrDisconnected = true;

    // 將 android system back button 設為可點擊
    SystemBackButtonProperty.isEnabled = true;
  }

  // 在 Bootloader 模式下重新傳遞 binary
  void _onUpdateStarted(
    UpdateStarted event,
    Emitter<Setting18FirmwareUpdateState> emit,
  ) async {
    // 重新傳送時將 checksum flag 設為 false
    _isReceivedChecksumOrDisconnected = false;

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
    Emitter<Setting18FirmwareUpdateState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    //  將 android system back button 設為不可點擊
    SystemBackButtonProperty.isEnabled = false;

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
    Emitter<Setting18FirmwareUpdateState> emit,
  ) async {
    // 重新傳送時將 checksum flag 設為 false
    _isReceivedChecksumOrDisconnected = false;

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
    Emitter<Setting18FirmwareUpdateState> emit,
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
    Emitter<Setting18FirmwareUpdateState> emit,
  ) async {
    List<int> cmd = event.character.codeUnits;

    _firmwareRepository.writeCommand(cmd);
  }

  Future<void> _onBinarySelected(
    BinarySelected event,
    Emitter<Setting18FirmwareUpdateState> emit,
  ) async {
    emit(state.copyWith(
      binaryLoadStatus: FormStatus.requestInProgress,
    ));

    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: ['bin'],
      allowCompression: false,
    );

    if (filePickerResult != null) {
      String partId = event.partId;
      String binaryPath = filePickerResult.files.single.path!;
      Uint8List binaryData = await File(binaryPath).readAsBytes();

      List<dynamic> resultOfcheckFileContent =
          _firmwareRepository.checkFileContent(
        partId: partId,
        binaryData: binaryData,
      );

      if (resultOfcheckFileContent[0]) {
        print('binaryPath: $binaryPath');

        BinaryInfo selectedBinaryInfo =
            _getSelectedBinaryInfo(binaryPath: binaryPath);

        List<dynamic> result =
            await _firmwareRepository.calculateCheckSum(binaryData: binaryData);

        int sum = result[0];
        List<int> binary = result[1];

        emit(state.copyWith(
          binaryLoadStatus: FormStatus.requestSuccess,
          binaryCheckResult: BinaryCheckResult(
            isValid: true,
            sum: sum,
            binary: binary,
          ),
          selectedBinaryInfo: selectedBinaryInfo,
        ));
      } else {
        BinaryInfo selectedBinaryInfo =
            _getSelectedBinaryInfo(binaryPath: binaryPath);

        emit(state.copyWith(
          binaryLoadStatus: FormStatus.requestFailure,
          binaryCheckResult: const BinaryCheckResult(
            isValid: false,
            sum: 0,
            binary: [],
          ),
          selectedBinaryInfo: selectedBinaryInfo,
          fileErrorMessage: 'The file you selected is invalid',
        ));
      }
    } else {
      // 使用者取消 file picker, 沒有選擇任何檔案

      if (state.binaryCheckResult.isValid) {
        emit(state.copyWith(
          binaryLoadStatus: FormStatus.requestSuccess,
        ));
      } else {
        emit(state.copyWith(
          binaryLoadStatus: FormStatus.none,
        ));
      }
    }
  }

  // Future<void> _onBinaryLoaded(
  //   BinaryLoaded event,
  //   Emitter<Setting18FirmwareUpdateState> emit,
  // ) async {
  //   String binaryPath = '';

  //   if (event.currentFirmwareVersion.endsWith('q')) {
  //     binaryPath = FirmwareFileTable.qFilePathMap[event.partId] ?? '';
  //   } else {
  //     binaryPath = FirmwareFileTable.filePathMap[event.partId] ?? '';
  //   }

  //   print('binaryPath: $binaryPath');

  //   if (binaryPath.isNotEmpty) {
  //     BinaryInfo selectedBinaryInfo =
  //         _getSelectedBinaryInfo(binaryPath: binaryPath);

  //     print('selectedVersion: ${selectedBinaryInfo.version}');

  //     List<dynamic> result =
  //         await _firmwareRepository.calculateCheckSum(binaryPath: binaryPath);

  //     if (result[0]) {
  //       int sum = result[1];
  //       List<int> binary = result[2];

  //       emit(state.copyWith(
  //         binaryLoadStatus: FormStatus.requestSuccess,
  //         sum: sum,
  //         binary: binary,
  //         selectedBinaryInfo: selectedBinaryInfo,
  //       ));
  //     } else {
  //       emit(state.copyWith(
  //         binaryLoadStatus: FormStatus.requestFailure,
  //       ));
  //     }
  //   } else {
  //     emit(state.copyWith(
  //       binaryLoadStatus: FormStatus.requestFailure,
  //     ));
  //   }
  // }

  Future<void> _onUpdateLogAdded(
    UpdateLogAdded event,
    Emitter<Setting18FirmwareUpdateState> emit,
  ) async {
    List<dynamic> resultOgGetUpdateLogs =
        await _firmwareRepository.requestCommand1p8GUpdateLogs();

    if (resultOgGetUpdateLogs[0]) {
      List<UpdateLog> updateLogs = resultOgGetUpdateLogs[1];
      String userCode = await _codeRepository.readUserCode();

      UpdateLog updateLog = UpdateLog(
        type: state.selectedBinaryInfo.version >= event.previousFirmwareVersion
            ? UpdateType.upgrade
            : UpdateType.downgrade,
        dateTime: DateTime.now(),
        firmwareVersion: state.selectedBinaryInfo.version.toString(),
        technicianID: userCode,
      );

      // 滿 32 筆時清除最舊的一筆
      if (updateLogs.length == 32) {
        updateLogs.removeLast();
      }
      updateLogs.insert(0, updateLog);

      _firmwareRepository.set1p8GFirmwareUpdateLogs(updateLogs);
    } else {
      emit(state.copyWith(errorMessage: 'Failed to write update log'));
    }
  }

  Future<void> _onBinaryCanceled(
    BinaryCanceled event,
    Emitter<Setting18FirmwareUpdateState> emit,
  ) async {
    emit(state.copyWith(
      binaryLoadStatus: FormStatus.none,
    ));
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

  BinaryInfo _getSelectedBinaryInfo({required String binaryPath}) {
    String filenameWithExtenaionName = binaryPath.split('/').last;
    List<String> nameAndExtensionName = filenameWithExtenaionName.split('.');

    String name = nameAndExtensionName[0];
    String extensionName = nameAndExtensionName[1];
    int version = 0;

    // Regular expression to match the pattern
    RegExp versionRegex = RegExp(r'R(\d+)_');

    // Find the first match
    Match? match = versionRegex.firstMatch(name);

    if (match != null) {
      // Extract the matched substring
      version = int.parse(match.group(1)!);
    }

    return BinaryInfo(
      name: name,
      extensionName: extensionName,
      version: version,
    );
  }

  Future<void> _transferBinary() async {
    ConnectionType connectionType = _aciDeviceRepository.checkConnectionType();

    if (connectionType == ConnectionType.usb) {
      _chunkSize = 8192;

      List<List<int>> chunks = BLEUtils.divideToChunkList(
        binary: state.binaryCheckResult.binary,
        chunkSize: _chunkSize,
      );

      _chunkLength = chunks.length;

      for (int i = 0; i < _chunkLength; i++) {
        if (!_isReceivedChecksumOrDisconnected) {
          await _firmwareRepository.transferBinaryChunk(
            chunk: chunks[i],
            indexOfChunk: i,
          );
        } else {
          break;
        }
      }
    } else {
      // 將 binary 切分成每個大小為 chunkSize 的封包
      int chunkSize = await BLEUtils.getChunkSize();
      _chunkSize = chunkSize;

      List<List<int>> chunks = BLEUtils.divideToChunkList(
        binary: state.binaryCheckResult.binary,
        chunkSize: _chunkSize,
      );

      _chunkLength = chunks.length;

      for (int i = 0; i < _chunkLength; i++) {
        if (!_isReceivedChecksumOrDisconnected) {
          await _firmwareRepository.transferBinaryChunk(
            chunk: chunks[i],
            indexOfChunk: i,
          );
        } else {
          break;
        }
      }
    }
  }

  @override
  Future<void> close() {
    _updateReportStreamSubscription?.cancel();
    return super.close();
  }
}

class BinaryInfo {
  const BinaryInfo({
    required this.name,
    required this.extensionName,
    required this.version,
  });

  const BinaryInfo.empty()
      : name = '',
        extensionName = '',
        version = 0;

  final String name;
  final String extensionName;
  final int version;

  bool get isEmpty {
    return name.isEmpty && extensionName.isEmpty;
  }
}

// a class that present the file is valid or not base on sum and binary data
class BinaryCheckResult {
  const BinaryCheckResult({
    required this.isValid,
    required this.sum,
    required this.binary,
  });

  const BinaryCheckResult.empty()
      : isValid = false,
        sum = 0,
        binary = const [];

  final bool isValid;
  final int sum;
  final List<int> binary;
}

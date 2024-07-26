import 'dart:async';

import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'warm_reset_event.dart';
part 'warm_reset_state.dart';

class WarmResetBloc extends Bloc<WarmResetEvent, WarmResetState> {
  WarmResetBloc({
    required AppLocalizations appLocalizations,
    required FirmwareRepository firmwareRepository,
  })  : _firmwareRepository = firmwareRepository,
        _appLocalizations = appLocalizations,
        super(const WarmResetState()) {
    on<ResetStarted>(_onResetStarted);
    on<MessageReceived>(_onMessageReceived);

    add(const ResetStarted());
  }

  final FirmwareRepository _firmwareRepository;
  final AppLocalizations _appLocalizations;
  StreamSubscription<String>? _updateReportStreamSubscription;
  Timer? _enterBootloaderTimer;

  void _listenUpdateReport() {
    _updateReportStreamSubscription =
        _firmwareRepository.updateReport.listen((message) {
      double currentProgress = 0.0;
      String displayMessage = '';

      if (message.startsWith('Bootloader')) {
        _cancelEnterBootloaderTimer(); // 成功進入 Bootloader, 停止 timer

        // 出錯之後, 使用者取消更新,
        // write 'N'
        print('===============N==================');
        _firmwareRepository.writeCommand([0x4E]);

        // 暫停 stream 來重置 timeout 的 countdown
        _updateReportStreamSubscription?.pause();
        currentProgress = 0.5;
        displayMessage = 'almost done...';

        add(MessageReceived(
          message: displayMessage,
          currentProgress: currentProgress,
        ));
      }
    }, onError: (error) {
      print('onError: $error');
      // add(ErrorReceived(errorMessage: error));
    });
  }

  // 使用者觸發 Start 後, 嘗試進入 Bootloader
  Future<void> _onResetStarted(
    ResetStarted event,
    Emitter<WarmResetState> emit,
  ) async {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.submissionInProgress,
        message: 'Reseting...'));

    // //  將 android system back button 設為不可點擊
    // SystemBackButtonProperty.isEnabled = false;

    _listenUpdateReport();
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

  Future<void> _onMessageReceived(
    MessageReceived event,
    Emitter<WarmResetState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
      message: event.message,
      currentProgress: event.currentProgress,
    ));

    await Future.delayed(
      const Duration(seconds: 3),
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
      message: 'Done',
      currentProgress: 1.0,
    ));
  }

  void _cancelEnterBootloaderTimer() {
    if (_enterBootloaderTimer != null) {
      _enterBootloaderTimer!.cancel();
    }
  }

  @override
  Future<void> close() {
    _updateReportStreamSubscription?.cancel();
    return super.close();
  }
}

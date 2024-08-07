import 'dart:async';

import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'information_event.dart';
part 'information_state.dart';

class InformationBloc extends Bloc<InformationEvent, InformationState> {
  InformationBloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const InformationState()) {
    on<AppVersionRequested>(_onAppVersionRequested);
    on<AlarmUpdated>(_onAlarmUpdated);
    on<AlarmPeriodicUpdateRequested>(_onAlarmPeriodicUpdateRequested);
    on<AlarmPeriodicUpdateCanceled>(_onAlarmPeriodicUpdateCanceled);

    add(const AppVersionRequested());
  }

  Timer? _timer;
  final DsimRepository _dsimRepository;

  Future<void> _onAppVersionRequested(
    AppVersionRequested event,
    Emitter<InformationState> emit,
  ) async {
    String appVersion = await getAppVersion();

    emit(state.copyWith(
      appVersion: appVersion,
    ));
  }

  void _onAlarmPeriodicUpdateRequested(
    AlarmPeriodicUpdateRequested event,
    Emitter<InformationState> emit,
  ) {
    if (_timer != null) {
      _timer!.cancel();
    }

    // timer 啟動後 5 秒才會發 AlarmUpdated, 所以第0秒時先 AlarmUpdated
    add(const AlarmUpdated());

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print('alarm trigger timer: ${timer.tick}');
      add(const AlarmUpdated());
    });

    print('alarm trigger started');
  }

  Future<void> _onAlarmUpdated(
    AlarmUpdated event,
    Emitter<InformationState> emit,
  ) async {
    List<dynamic> resultOfRequestCommand5 =
        await _dsimRepository.requestCommand5();

    if (resultOfRequestCommand5[0]) {
      String alarmRServerity = resultOfRequestCommand5[4];
      String alarmTServerity = resultOfRequestCommand5[5];
      String alarmPServerity = resultOfRequestCommand5[6];

      emit(state.copyWith(
        alarmRSeverity: alarmRServerity,
        alarmTSeverity: alarmTServerity,
        alarmPSeverity: alarmPServerity,
      ));
    } else {
      print('failed, time out');
    }
  }

  Future<void> _onAlarmPeriodicUpdateCanceled(
    AlarmPeriodicUpdateCanceled event,
    Emitter<InformationState> emit,
  ) async {
    if (_timer != null) {
      _timer!.cancel();
      print('alarm trigger timer is canceled');
    }

    // 等待兩秒再將 isTimerStarted = false, 避免當使用者切到別的頁面時，目前的頁面還沒被 dispose又馬上又觸發 _AlarmCard rebuild 並觸發 event 重新創建 timer
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> close() {
    if (_timer != null) {
      _timer!.cancel();

      print('alarm trigger timer is canceled due to bloc closing.');
    }

    return super.close();
  }
}

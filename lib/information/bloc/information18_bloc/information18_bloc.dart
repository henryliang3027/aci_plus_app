import 'dart:async';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'information18_event.dart';
part 'information18_state.dart';

class Information18Bloc extends Bloc<Information18Event, Information18State> {
  Information18Bloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const Information18State()) {
    on<AlarmUpdated>(_onAlarmUpdated);
    on<AlarmPeriodicUpdateRequested>(_onAlarmPeriodicUpdateRequested);
    on<AlarmPeriodicUpdateCanceled>(_onAlarmPeriodicUpdateCanceled);
  }

  Timer? _timer;
  final DsimRepository _dsimRepository;

  void _onAlarmPeriodicUpdateRequested(
    AlarmPeriodicUpdateRequested event,
    Emitter<Information18State> emit,
  ) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print('alarm trigger timer: ${timer.tick}');
      add(const AlarmUpdated());
    });

    print('alarm trigger started');

    emit(state.copyWith(
      isTimerStarted: true,
    ));
  }

  Future<void> _onAlarmUpdated(
    AlarmUpdated event,
    Emitter<Information18State> emit,
  ) async {
    List<dynamic> result = await _dsimRepository.requestCommand1p8GAlarm();

    if (result[0]) {
      String alarmUServerity = result[1];
      String alarmTServerity = result[2];
      String alarmPServerity = result[3];

      emit(state.copyWith(
        alarmUSeverity: alarmUServerity,
        alarmTSeverity: alarmTServerity,
        alarmPSeverity: alarmPServerity,
      ));
    }
  }

  Future<void> _onAlarmPeriodicUpdateCanceled(
    AlarmPeriodicUpdateCanceled event,
    Emitter<Information18State> emit,
  ) async {
    if (_timer != null) {
      _timer!.cancel();
      print('alarm trigger timer is canceled');
    }

    // 等待兩秒再將 isTimerStarted = false, 避免當使用者切到別的頁面時馬上又觸發 bloc 重新創建 timer
    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(
      isTimerStarted: false,
    ));
  }
}

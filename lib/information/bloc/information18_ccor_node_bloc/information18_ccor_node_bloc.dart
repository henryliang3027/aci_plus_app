import 'dart:async';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'information18_ccor_node_event.dart';
part 'information18_ccor_node_state.dart';

class Information18CCorNodeBloc
    extends Bloc<Information18CCorNodeEvent, Information18CCorNodeState> {
  Information18CCorNodeBloc({
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(const Information18CCorNodeState()) {
    on<AlarmUpdated>(_onAlarmUpdated);
    on<AlarmPeriodicUpdateRequested>(_onAlarmPeriodicUpdateRequested);
    on<AlarmPeriodicUpdateCanceled>(_onAlarmPeriodicUpdateCanceled);
  }

  Timer? _timer;
  final Amp18CCorNodeRepository _amp18CCorNodeRepository;

  void _onAlarmPeriodicUpdateRequested(
    AlarmPeriodicUpdateRequested event,
    Emitter<Information18CCorNodeState> emit,
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

    emit(state.copyWith(
      isTimerStarted: true,
    ));
  }

  Future<void> _onAlarmUpdated(
    AlarmUpdated event,
    Emitter<Information18CCorNodeState> emit,
  ) async {
    List<dynamic> result =
        await _amp18CCorNodeRepository.requestCommand1p8GCCorNodeAlarm();

    if (result[0]) {
      String alarmUServerity = result[1];
      String alarmTServerity = result[2];
      String alarmPServerity = result[3];

      emit(state.copyWith(
        alarmUSeverity: alarmUServerity,
        alarmTSeverity: alarmTServerity,
        alarmPSeverity: alarmPServerity,
      ));
    } else {
      print('Alarm updated failed');
    }
  }

  Future<void> _onAlarmPeriodicUpdateCanceled(
    AlarmPeriodicUpdateCanceled event,
    Emitter<Information18CCorNodeState> emit,
  ) async {
    if (_timer != null) {
      _timer!.cancel();
      print('alarm trigger timer is canceled');
    }

    // 等待兩秒再將 isTimerStarted = false, 避免當使用者切到別的頁面時，目前的頁面還沒被 dispose又馬上又觸發 _AlarmCard rebuild 並觸發 event 重新創建 timer
    // await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(
      isTimerStarted: false,
    ));
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

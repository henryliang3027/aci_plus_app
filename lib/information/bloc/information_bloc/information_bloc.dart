import 'dart:async';

import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'information_event.dart';
part 'information_state.dart';

class InformationBloc extends Bloc<InformationEvent, InformationState> {
  InformationBloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const InformationState()) {
    on<AlarmUpdated>(_onAlarmUpdated);

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print('alarm trigger timer: $timer');
      add(const AlarmUpdated());
    });
  }

  late final Timer _timer;
  final DsimRepository _dsimRepository;

  Future<void> _onAlarmUpdated(
    AlarmUpdated event,
    Emitter<InformationState> emit,
  ) async {
    //讓 _dsimRepository 裡面的 _alarmR _alarmT_ alarmp 重新取得資料

    await _dsimRepository.requestCommand3();

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
    }
  }

  @override
  Future<void> close() {
    _timer.cancel();
    print('alarm trigger timer is canceled');
    return super.close();
  }
}

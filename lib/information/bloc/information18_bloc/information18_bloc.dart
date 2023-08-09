import 'dart:async';
import 'package:dsim_app/core/form_status.dart';
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
  }

  late final Timer _timer;
  final DsimRepository _dsimRepository;

  Future<void> _onAlarmUpdated(
    AlarmUpdated event,
    Emitter<Information18State> emit,
  ) async {
    //讓 _dsimRepository 裡面的 _alarmR _alarmT_ alarmp 重新取得資料

    // await _dsimRepository.requestCommand3();

    // List<dynamic> resultOfRequestCommand5 =
    //     await _dsimRepository.requestCommand5();

    // if (resultOfRequestCommand5[0]) {
    //   String alarmRServerity = resultOfRequestCommand5[4];
    //   String alarmTServerity = resultOfRequestCommand5[5];
    //   String alarmPServerity = resultOfRequestCommand5[6];

    //   emit(state.copyWith(
    //     alarmUSeverity: alarmRServerity,
    //     alarmTSeverity: alarmTServerity,
    //     alarmPSeverity: alarmPServerity,
    //   ));
    // }
  }
}

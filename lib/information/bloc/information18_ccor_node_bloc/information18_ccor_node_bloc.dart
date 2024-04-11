import 'dart:async';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'information18_ccor_node_event.dart';
part 'information18_ccor_node_state.dart';

class Information18CCorNodeBloc
    extends Bloc<Information18CCorNodeEvent, Information18CCorNodeState> {
  Information18CCorNodeBloc({
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(const Information18CCorNodeState()) {
    on<AppVersionRequested>(_onAppVersionRequested);
    on<AlarmUpdated>(_onAlarmUpdated);
    on<AlarmPeriodicUpdateRequested>(_onAlarmPeriodicUpdateRequested);
    on<AlarmPeriodicUpdateCanceled>(_onAlarmPeriodicUpdateCanceled);

    add(const AppVersionRequested());
  }

  Timer? _timer;
  final Amp18CCorNodeRepository _amp18CCorNodeRepository;

  Future<void> _onAppVersionRequested(
    AppVersionRequested event,
    Emitter<Information18CCorNodeState> emit,
  ) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = 'V ${packageInfo.version}-beta2';

    emit(state.copyWith(
      appVersion: appVersion,
    ));
  }

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

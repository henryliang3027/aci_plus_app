import 'dart:async';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'information18_event.dart';
part 'information18_state.dart';

class Information18Bloc extends Bloc<Information18Event, Information18State> {
  Information18Bloc({
    required Amp18Repository amp18Repository,
    required ConfigRepository configRepository,
  })  : _amp18Repository = amp18Repository,
        _configRepository = configRepository,
        super(const Information18State()) {
    on<ConfigLoaded>(_onConfigLoaded);
    on<AppVersionRequested>(_onAppVersionRequested);
    on<AlarmUpdated>(_onAlarmUpdated);
    on<AlarmPeriodicUpdateRequested>(_onAlarmPeriodicUpdateRequested);
    on<AlarmPeriodicUpdateCanceled>(_onAlarmPeriodicUpdateCanceled);

    add(const AppVersionRequested());
  }

  Timer? _timer;
  final Amp18Repository _amp18Repository;
  final ConfigRepository _configRepository;

  Future<void> _onAppVersionRequested(
    AppVersionRequested event,
    Emitter<Information18State> emit,
  ) async {
    String appVersion = await getAppVersion();

    emit(state.copyWith(
      appVersion: appVersion,
    ));
  }

  String getGroupIdByPartId(String partId) {
    // TR 或 SDAT 為 trunk
    if (partId == '5' || partId == '8') {
      return '0'; // trunk
    } else {
      return '1'; // distribution
    }
  }

  Future<void> _onConfigLoaded(
    ConfigLoaded event,
    Emitter<Information18State> emit,
  ) async {
    String groupId = getGroupIdByPartId(event.partId);

    List<Config> configs = _configRepository.getConfigsByGroupId(groupId);

    emit(state.copyWith(
      // isLoadConfigEnabled: configs.isNotEmpty ? true : false,
      configs: configs,
    ));

    // if (result[0]) {
    //   dynamic defaultConfig = result[1];

    //   emit(state.copyWith(
    //     isLoadConfigEnabled: true,
    //     defaultConfig: defaultConfig,
    //   ));
    // } else {
    //   emit(state.copyWith(
    //     isLoadConfigEnabled: false,
    //     errorMessage: 'Preset data not found, please add new preset profiles.',
    //   ));
    // }
  }

  void _onAlarmPeriodicUpdateRequested(
    AlarmPeriodicUpdateRequested event,
    Emitter<Information18State> emit,
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
    Emitter<Information18State> emit,
  ) async {
    Stopwatch stopwatch = Stopwatch()..start();
    List<dynamic> result = await _amp18Repository.requestCommand1p8GAlarm();
    print('doSomething() executed in ${stopwatch.elapsed.inMilliseconds}');

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
    Emitter<Information18State> emit,
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

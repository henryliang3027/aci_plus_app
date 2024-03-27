import 'dart:async';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = 'V ${packageInfo.version}';

    emit(state.copyWith(
      appVersion: appVersion,
    ));
  }

  Future<void> _onConfigLoaded(
    ConfigLoaded event,
    Emitter<Information18State> emit,
  ) async {
    String groupId = event.partId == '5' ? '0' : '1';

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

  Future<void> _onDiagramLoaded(
    DiagramLoaded event,
    Emitter<Information18State> emit,
  ) async {
    // String namePlatePath = namePlateFilePath[event.partId] ?? '';

    // String generalString =
    //     await rootBundle.loadString('assets/nameplates/BLE.svg');

    // XmlDocument document = XmlDocument.parse(generalString);

    // final paths = document.findAllElements('path');
    // // final rects = document.findAllElements('rect');
    // final header = document.findElements('svg').toList()[0];
    // final double width = double.parse(header.getAttribute('width').toString());
    // final double height =
    //     double.parse(header.getAttribute('height').toString());

    // List<Component> components = [];
    // List<Box> boxes = [];

    // for (var element in paths) {
    //   // String partColor = element.getAttribute('style').toString();
    //   String? fill = element.getAttribute('fill');

    //   String partColor;

    //   if (fill == null) {
    //     partColor = 'ff000000';
    //   } else {
    //     partColor = 'ff${fill.toString().substring(1)}';
    //   }

    //   // String partColor = 'ff${element.getAttribute('fill').toString()}';
    //   String partPath = element.getAttribute('d').toString();

    //   components.add(Component(color: partColor, path: partPath));
    // }

    // for (var element in rects) {
    //   int moduleId = int.parse(element.getAttribute('symbol').toString());
    //   double x = double.parse(element.getAttribute('x').toString());
    //   double y = double.parse(element.getAttribute('y').toString());
    //   double width = double.parse(element.getAttribute('width').toString());
    //   double height = double.parse(element.getAttribute('height').toString());

    //   boxes.add(Box(
    //     moduleId: moduleId,
    //     x: x,
    //     y: y,
    //     width: width,
    //     height: height,
    //   ));
    // }

    // SVGImage namePlateImage = SVGImage(
    //   width: width,
    //   height: height,
    //   components: components,
    //   boxes: boxes,
    // );

    // emit(state.copyWith(
    //   namePlateImage: namePlateImage,
    // ));
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
    List<dynamic> result = await _amp18Repository.requestCommand1p8GAlarm();

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

import 'dart:async';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'information18_event.dart';
part 'information18_state.dart';

class Information18Bloc extends Bloc<Information18Event, Information18State> {
  Information18Bloc({
    required ConfigRepository configRepository,
  })  : _configRepository = configRepository,
        super(const Information18State()) {
    on<ConfigLoaded>(_onConfigLoaded);
    on<AppVersionRequested>(_onAppVersionRequested);

    add(const AppVersionRequested());
  }

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
      configs: configs,
    ));
  }
}

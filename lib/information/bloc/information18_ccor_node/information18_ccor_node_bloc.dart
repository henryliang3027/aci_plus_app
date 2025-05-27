import 'dart:async';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'information18_ccor_node_event.dart';
part 'information18_ccor_node_state.dart';

class Information18CCorNodeBloc
    extends Bloc<Information18CCorNodeEvent, Information18CCorNodeState> {
  Information18CCorNodeBloc({
    required ConfigRepository configRepository,
  })  : _configRepository = configRepository,
        super(const Information18CCorNodeState()) {
    on<ConfigLoaded>(_onConfigLoaded);
    on<AppVersionRequested>(_onAppVersionRequested);

    add(const AppVersionRequested());
  }

  final ConfigRepository _configRepository;

  Future<void> _onAppVersionRequested(
    AppVersionRequested event,
    Emitter<Information18CCorNodeState> emit,
  ) async {
    String appVersion = await getAppVersion();

    emit(state.copyWith(
      appVersion: appVersion,
    ));
  }

  Future<void> _onConfigLoaded(
    ConfigLoaded event,
    Emitter<Information18CCorNodeState> emit,
  ) async {
    List<NodeConfig> nodeConfigs = _configRepository.getAllNodeConfig();

    emit(state.copyWith(
      nodeConfigs: nodeConfigs,
    ));
  }
}

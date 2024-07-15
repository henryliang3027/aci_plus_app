import 'package:aci_plus_app/advanced/bloc/configs/setting18_base_config/setting18_base_config_bloc.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting18TrunkConfigBloc extends Setting18BaseConfigBloc {
  Setting18TrunkConfigBloc({
    required ConfigRepository configRepository,
  }) : super(configRepository: configRepository) {
    on<ConfigsRequested>(onConfigsRequested);
    on<ConfigDeleted>(onConfigDeleted);

    add(const ConfigsRequested());
  }

  @override
  void onConfigsRequested(
    ConfigsRequested event,
    Emitter<Setting18BaseConfigState> emit,
  ) {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
    ));

    List<Config> configs = configRepository.getAllTrunkConfigs();
    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
      configs: configs,
    ));
  }

  @override
  Future<void> onConfigDeleted(
    ConfigDeleted event,
    Emitter<Setting18BaseConfigState> emit,
  ) async {
    await configRepository.deleteConfig(
      groupId: event.groupId,
      id: event.id,
    );

    List<Config> configs = configRepository.getAllTrunkConfigs();

    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
      configs: configs,
    ));
  }
}

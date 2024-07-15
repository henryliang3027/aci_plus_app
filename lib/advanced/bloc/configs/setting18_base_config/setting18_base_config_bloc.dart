import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_base_config_event.dart';
part 'setting18_base_config_state.dart';

abstract class Setting18BaseConfigBloc
    extends Bloc<Setting18BaseConfigEvent, Setting18BaseConfigState> {
  Setting18BaseConfigBloc({
    required this.configRepository,
  }) : super(const Setting18BaseConfigState());

  final ConfigRepository configRepository;

  void onConfigsRequested(
    ConfigsRequested event,
    Emitter<Setting18BaseConfigState> emit,
  );

  Future<void> onConfigDeleted(
    ConfigDeleted event,
    Emitter<Setting18BaseConfigState> emit,
  );

  // List<Config> getConfigs();
}

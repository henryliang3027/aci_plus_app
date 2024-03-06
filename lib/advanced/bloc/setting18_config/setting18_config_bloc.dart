import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/distribution_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/trunk_config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_config_event.dart';
part 'setting18_config_state.dart';

class Setting18ConfigBloc
    extends Bloc<Setting18ConfigEvent, Setting18ConfigState> {
  Setting18ConfigBloc({
    required ConfigRepository configRepository,
  })  : _configRepository = configRepository,
        super(const Setting18ConfigState()) {
    on<ConfigsRequested>(_onConfigsRequested);
    on<ConfigDeleted>(_onConfigDeleted);
    on<DefaultConfigChanged>(_onDefaultConfigChanged);
    on<QRDataGenerated>(_onQRDataGenerated);
    on<QRDataScanned>(_onQRDataScanned);

    add(const ConfigsRequested());
  }

  final ConfigRepository _configRepository;

  Future<void> _onConfigsRequested(
    ConfigsRequested event,
    Emitter<Setting18ConfigState> emit,
  ) async {
    emit(state.copyWith(
      encodeStaus: FormStatus.none,
      decodeStatus: FormStatus.none,
      formStatus: FormStatus.requestInProgress,
    ));

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildVersion =
        'V ${packageInfo.version}-beta${packageInfo.buildNumber}';

    List<TrunkConfig> trunkConfigs = _configRepository.getAllTrunkConfigs();
    List<DistributionConfig> distributionConfigs =
        _configRepository.getAllDistributionConfigs();

    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
      buildVersion: buildVersion,
      trunkConfigs: trunkConfigs,
      distributionConfigs: distributionConfigs,
    ));
  }

  Future<void> _onConfigDeleted(
    ConfigDeleted event,
    Emitter<Setting18ConfigState> emit,
  ) async {
    await _configRepository.deleteConfig(
      groupId: event.groupId,
      id: event.id,
    );

    List<TrunkConfig> trunkConfigs = _configRepository.getAllTrunkConfigs();
    List<DistributionConfig> distributionConfigs =
        _configRepository.getAllDistributionConfigs();

    emit(state.copyWith(
      encodeStaus: FormStatus.none,
      decodeStatus: FormStatus.none,
      formStatus: FormStatus.requestSuccess,
      trunkConfigs: trunkConfigs,
      distributionConfigs: distributionConfigs,
    ));
  }

  Future<void> _onDefaultConfigChanged(
    DefaultConfigChanged event,
    Emitter<Setting18ConfigState> emit,
  ) async {
    await _configRepository.setDefaultConfigById(
      groupId: event.groupId,
      id: event.id,
    );

    List<TrunkConfig> trunkConfigs = _configRepository.getAllTrunkConfigs();
    List<DistributionConfig> distributionConfigs =
        _configRepository.getAllDistributionConfigs();

    emit(state.copyWith(
      encodeStaus: FormStatus.none,
      decodeStatus: FormStatus.none,
      trunkConfigs: trunkConfigs,
      distributionConfigs: distributionConfigs,
    ));
  }

  void _onQRDataGenerated(
    QRDataGenerated event,
    Emitter<Setting18ConfigState> emit,
  ) {
    // emit(state.copyWith(
    //   encodeStaus: FormStatus.requestInProgress,
    //   decodeStatus: FormStatus.none,
    // ));

    // List<String> jsons = [
    //   for (Config config in state.configs) ...[jsonEncode(config.toJson())]
    // ];

    // emit(state.copyWith(
    //   encodeStaus: FormStatus.requestSuccess,
    //   encodedData: jsons.join(','),
    // ));
  }

  void _onQRDataScanned(
    QRDataScanned event,
    Emitter<Setting18ConfigState> emit,
  ) {
    // emit(state.copyWith(
    //   encodeStaus: FormStatus.none,
    //   decodeStatus: FormStatus.requestInProgress,
    // ));

    // List<Config> configs = [];

    // RegExp configJsonRegex = RegExp(r'({[^{}]+})');

    // Iterable<Match> matches = configJsonRegex.allMatches(event.rawData);

    // print(event.rawData);

    // for (Match match in matches) {
    //   String json = match[0]!;
    //   print(json);
    //   Config config = Config.fromJson(jsonDecode(json));
    //   configs.add(config);
    // }

    // // for (String json in jsons) {
    // //   Config config = jsonDecode(json);
    // //   configs.add(config);
    // // }

    // emit(state.copyWith(
    //   decodeStatus: FormStatus.requestSuccess,
    //   configs: configs,
    // ));
  }
}

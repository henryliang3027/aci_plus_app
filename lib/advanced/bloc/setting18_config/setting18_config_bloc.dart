import 'dart:convert';

import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/distribution_config.dart';
// import 'package:aci_plus_app/repositories/dongle.dart';
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

    List<TrunkConfig> trunkConfigs = _configRepository.getAllTrunkConfigs();
    List<DistributionConfig> distributionConfigs =
        _configRepository.getAllDistributionConfigs();

    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
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

  void _onQRDataGenerated(
    QRDataGenerated event,
    Emitter<Setting18ConfigState> emit,
  ) {
    emit(state.copyWith(
      encodeStaus: FormStatus.requestInProgress,
      decodeStatus: FormStatus.none,
    ));

    // Dongle dongle = const Dongle();
    // String encodedData = jsonEncode(dongle.toJson());

    List<String> trunkConfigJsons = [
      for (TrunkConfig trunkConfig in state.trunkConfigs) ...[
        jsonEncode(trunkConfig.toJson())
      ]
    ];

    List<String> distributionConfigJsons = [
      for (DistributionConfig distributionConfig in state
          .distributionConfigs) ...[jsonEncode(distributionConfig.toJson())]
    ];

    String encodedData =
        '${trunkConfigJsons.join(',')} ${distributionConfigJsons.join(',')}';

    print(encodedData);

    emit(state.copyWith(
      encodeStaus: FormStatus.requestSuccess,
      encodedData: encodedData,
    ));
  }

  Future<void> _onQRDataScanned(
    QRDataScanned event,
    Emitter<Setting18ConfigState> emit,
  ) async {
    emit(state.copyWith(
      encodeStaus: FormStatus.none,
      decodeStatus: FormStatus.requestInProgress,
    ));

    List<TrunkConfig> trunkConfigs = [];
    List<DistributionConfig> distributionConfigs = [];

    RegExp mapRegex = RegExp(r'(\{[^{}]*\})');

    List<String> splitRawData = event.rawData.split(' ');

    String trunkRawData = splitRawData[0];
    String distributionRawData = splitRawData[1];
    // print('-----trunk------');
    // print(trunkRawData);
    // print('-----distribution------');
    // print(distributionRawData);

    Iterable<Match> trunkConfigMatches = mapRegex.allMatches(trunkRawData);
    Iterable<Match> distributionConfigMatches =
        mapRegex.allMatches(distributionRawData);

    print('-----trunk------');

    for (Match match in trunkConfigMatches) {
      String json = match[0]!;
      print(json);
      TrunkConfig trunkConfig = TrunkConfig.fromJson(jsonDecode(json));
      trunkConfigs.add(trunkConfig);
    }

    print('-----distribution------');

    for (Match match in distributionConfigMatches) {
      String json = match[0]!;
      print(json);
      DistributionConfig distributionConfig =
          DistributionConfig.fromJson(jsonDecode(json));
      distributionConfigs.add(distributionConfig);
    }

    await _configRepository.updateConfigsByQRCode(
      trunkConfigs: trunkConfigs,
      distributionConfigs: distributionConfigs,
    );

    List<TrunkConfig> test1 = _configRepository.getAllTrunkConfigs();
    List<DistributionConfig> test2 =
        _configRepository.getAllDistributionConfigs();

    emit(state.copyWith(
      decodeStatus: FormStatus.requestSuccess,
      trunkConfigs: trunkConfigs,
      distributionConfigs: distributionConfigs,
    ));

    // List<String> splitRawData = event.rawData.split(' ');

    // Iterable<Match> trunkConfigMatches =
    //     configJsonRegex.allMatches(splitRawData[0]);
    // Iterable<Match> distributionConfigMatches =
    //     configJsonRegex.allMatches(splitRawData[1]);

    // print('-----trunk------');

    // for (Match match in trunkConfigMatches) {
    //   String json = match[0]!;
    //   print(json);
    //   // Config config = Config.fromJson(jsonDecode(json));
    //   // configs.add(config);
    // }

    // print('-----distribution------');

    // for (Match match in distributionConfigMatches) {
    //   String json = match[0]!;
    //   print(json);
    //   // Config config = Config.fromJson(jsonDecode(json));
    //   // configs.add(config);
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

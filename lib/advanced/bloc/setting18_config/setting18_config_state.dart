part of 'setting18_config_bloc.dart';

class Setting18ConfigState extends Equatable {
  const Setting18ConfigState({
    this.formStatus = FormStatus.none,
    this.encodeStaus = FormStatus.none,
    this.decodeStatus = FormStatus.none,
    this.buildVersion = '',
    this.trunkConfigs = const [],
    this.distributionConfigs = const [],
    this.encodedData = '',
  });

  final FormStatus formStatus;
  final FormStatus encodeStaus;
  final FormStatus decodeStatus;
  final String buildVersion;
  final List<TrunkConfig> trunkConfigs;
  final List<DistributionConfig> distributionConfigs;
  final String encodedData;

  Setting18ConfigState copyWith({
    FormStatus? formStatus,
    FormStatus? encodeStaus,
    FormStatus? decodeStatus,
    String? buildVersion,
    List<TrunkConfig>? trunkConfigs,
    List<DistributionConfig>? distributionConfigs,
    String? encodedData,
  }) {
    return Setting18ConfigState(
      formStatus: formStatus ?? this.formStatus,
      encodeStaus: encodeStaus ?? this.encodeStaus,
      decodeStatus: decodeStatus ?? this.decodeStatus,
      buildVersion: buildVersion ?? this.buildVersion,
      trunkConfigs: trunkConfigs ?? this.trunkConfigs,
      distributionConfigs: distributionConfigs ?? this.distributionConfigs,
      encodedData: encodedData ?? this.encodedData,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        encodeStaus,
        decodeStatus,
        buildVersion,
        trunkConfigs,
        distributionConfigs,
        encodedData,
      ];
}

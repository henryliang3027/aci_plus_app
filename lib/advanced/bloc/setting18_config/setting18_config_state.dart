part of 'setting18_config_bloc.dart';

class Setting18ConfigState extends Equatable {
  const Setting18ConfigState({
    this.formStatus = FormStatus.none,
    this.encodeStaus = FormStatus.none,
    this.decodeStatus = FormStatus.none,
    this.pickImageStatus = FormStatus.none,
    this.trunkConfigs = const [],
    this.distributionConfigs = const [],
    this.nodeConfigs = const [],
    this.encodedData = '',
  });

  final FormStatus formStatus;
  final FormStatus encodeStaus;
  final FormStatus decodeStatus;
  final FormStatus pickImageStatus;
  final List<TrunkConfig> trunkConfigs;
  final List<DistributionConfig> distributionConfigs;
  final List<NodeConfig> nodeConfigs;
  final String encodedData;

  Setting18ConfigState copyWith({
    FormStatus? formStatus,
    FormStatus? encodeStaus,
    FormStatus? decodeStatus,
    FormStatus? pickImageStatus,
    List<TrunkConfig>? trunkConfigs,
    List<DistributionConfig>? distributionConfigs,
    List<NodeConfig>? nodeConfigs,
    String? encodedData,
  }) {
    return Setting18ConfigState(
      formStatus: formStatus ?? this.formStatus,
      encodeStaus: encodeStaus ?? this.encodeStaus,
      decodeStatus: decodeStatus ?? this.decodeStatus,
      pickImageStatus: pickImageStatus ?? this.pickImageStatus,
      trunkConfigs: trunkConfigs ?? this.trunkConfigs,
      distributionConfigs: distributionConfigs ?? this.distributionConfigs,
      nodeConfigs: nodeConfigs ?? this.nodeConfigs,
      encodedData: encodedData ?? this.encodedData,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        encodeStaus,
        decodeStatus,
        pickImageStatus,
        trunkConfigs,
        distributionConfigs,
        nodeConfigs,
        encodedData,
      ];
}

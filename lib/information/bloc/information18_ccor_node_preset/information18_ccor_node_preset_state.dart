part of 'information18_ccor_node_preset_bloc.dart';

class Information18CCorNodePresetState extends Equatable {
  const Information18CCorNodePresetState({
    this.settingStatus = SubmissionStatus.none,
    this.isInitialize = false,
    required this.nodeConfig,
    this.settingResult = const [],
  });

  final SubmissionStatus settingStatus;
  final bool isInitialize;
  final NodeConfig nodeConfig;
  final List<String> settingResult;

  Information18CCorNodePresetState copyWith({
    SubmissionStatus? settingStatus,
    bool? isInitialize,
    NodeConfig? nodeConfig,
    List<String>? settingResult,
  }) {
    return Information18CCorNodePresetState(
      settingStatus: settingStatus ?? this.settingStatus,
      isInitialize: isInitialize ?? this.isInitialize,
      nodeConfig: nodeConfig ?? this.nodeConfig,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        settingStatus,
        isInitialize,
        nodeConfig,
        settingResult,
      ];
}

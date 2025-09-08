part of 'information18_ccor_node_preset_bloc.dart';

class Information18CCorNodePresetState extends Equatable {
  const Information18CCorNodePresetState({
    this.settingStatus = SubmissionStatus.none,
    required this.nodeConfig,
    this.settingResult = const [],
  });

  final SubmissionStatus settingStatus;
  final NodeConfig nodeConfig;
  final List<String> settingResult;

  Information18CCorNodePresetState copyWith({
    SubmissionStatus? settingStatus,
    NodeConfig? nodeConfig,
    List<String>? settingResult,
  }) {
    return Information18CCorNodePresetState(
      settingStatus: settingStatus ?? this.settingStatus,
      nodeConfig: nodeConfig ?? this.nodeConfig,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        settingStatus,
        nodeConfig,
        settingResult,
      ];
}

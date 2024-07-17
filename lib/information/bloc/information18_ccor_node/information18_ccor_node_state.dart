part of 'information18_ccor_node_bloc.dart';

class Information18CCorNodeState extends Equatable {
  const Information18CCorNodeState({
    this.appVersion = '',
    this.nodeConfigs = const [],
    this.alarmUSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
  });

  final String appVersion;
  final List<NodeConfig> nodeConfigs;
  final String alarmUSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;

  Information18CCorNodeState copyWith({
    String? appVersion,
    List<NodeConfig>? nodeConfigs,
    String? alarmUSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
  }) {
    return Information18CCorNodeState(
      appVersion: appVersion ?? this.appVersion,
      nodeConfigs: nodeConfigs ?? this.nodeConfigs,
      alarmUSeverity: alarmUSeverity ?? this.alarmUSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
    );
  }

  @override
  List<Object?> get props => [
        appVersion,
        nodeConfigs,
        alarmUSeverity,
        alarmTSeverity,
        alarmPSeverity,
      ];
}

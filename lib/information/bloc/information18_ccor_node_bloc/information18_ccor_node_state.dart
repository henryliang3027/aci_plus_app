part of 'information18_ccor_node_bloc.dart';

class Information18CCorNodeState extends Equatable {
  const Information18CCorNodeState({
    this.appVersion = '',
    this.alarmUSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
  });

  final String appVersion;
  final String alarmUSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;

  Information18CCorNodeState copyWith({
    String? appVersion,
    String? alarmUSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
  }) {
    return Information18CCorNodeState(
      appVersion: appVersion ?? this.appVersion,
      alarmUSeverity: alarmUSeverity ?? this.alarmUSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
    );
  }

  @override
  List<Object?> get props => [
        appVersion,
        alarmUSeverity,
        alarmTSeverity,
        alarmPSeverity,
      ];
}

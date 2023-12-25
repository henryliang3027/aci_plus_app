part of 'information18_ccor_node_bloc.dart';

class Information18CCorNodeState extends Equatable {
  const Information18CCorNodeState({
    this.alarmUSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
  });

  final String alarmUSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;

  Information18CCorNodeState copyWith({
    String? alarmUSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
  }) {
    return Information18CCorNodeState(
      alarmUSeverity: alarmUSeverity ?? this.alarmUSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
    );
  }

  @override
  List<Object?> get props => [
        alarmUSeverity,
        alarmTSeverity,
        alarmPSeverity,
      ];
}

part of 'information18_bloc.dart';

class Information18State extends Equatable {
  const Information18State({
    this.alarmUSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
  });

  final String alarmUSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;

  Information18State copyWith({
    String? alarmUSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
  }) {
    return Information18State(
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

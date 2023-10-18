part of 'information18_bloc.dart';

class Information18State extends Equatable {
  const Information18State({
    this.alarmUSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
    this.isTimerStarted = false,
  });

  final String alarmUSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;
  final bool isTimerStarted;

  Information18State copyWith({
    String? alarmUSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
    bool? isTimerStarted,
  }) {
    return Information18State(
      alarmUSeverity: alarmUSeverity ?? this.alarmUSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
      isTimerStarted: isTimerStarted ?? this.isTimerStarted,
    );
  }

  @override
  List<Object?> get props => [
        alarmUSeverity,
        alarmTSeverity,
        alarmPSeverity,
        isTimerStarted,
      ];
}

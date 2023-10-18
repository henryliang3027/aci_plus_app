part of 'information_bloc.dart';

class InformationState extends Equatable {
  const InformationState({
    this.alarmRSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
    this.isTimerStarted = false,
  });

  final String alarmRSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;
  final bool isTimerStarted;

  InformationState copyWith({
    String? alarmRSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
    bool? isTimerStarted,
  }) {
    return InformationState(
      alarmRSeverity: alarmRSeverity ?? this.alarmRSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
      isTimerStarted: isTimerStarted ?? this.isTimerStarted,
    );
  }

  @override
  List<Object?> get props => [
        alarmRSeverity,
        alarmTSeverity,
        alarmPSeverity,
        isTimerStarted,
      ];
}

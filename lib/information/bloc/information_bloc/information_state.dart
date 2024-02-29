part of 'information_bloc.dart';

class InformationState extends Equatable {
  const InformationState({
    this.alarmRSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
  });

  final String alarmRSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;

  InformationState copyWith({
    String? alarmRSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
  }) {
    return InformationState(
      alarmRSeverity: alarmRSeverity ?? this.alarmRSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
    );
  }

  @override
  List<Object?> get props => [
        alarmRSeverity,
        alarmTSeverity,
        alarmPSeverity,
      ];
}

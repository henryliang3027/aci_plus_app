part of 'information_bloc.dart';

class InformationState extends Equatable {
  const InformationState({
    this.status = FormStatus.none,
    this.alarmRSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
  });

  final FormStatus status;
  final String alarmRSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;

  InformationState copyWith({
    FormStatus? status,
    String? alarmRSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
  }) {
    return InformationState(
      status: status ?? this.status,
      alarmRSeverity: alarmRSeverity ?? this.alarmRSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
    );
  }

  @override
  List<Object?> get props => [
        status,
        alarmRSeverity,
        alarmTSeverity,
        alarmPSeverity,
      ];
}

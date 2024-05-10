part of 'information_bloc.dart';

class InformationState extends Equatable {
  const InformationState({
    this.appVersion = '',
    this.alarmRSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
  });

  final String appVersion;
  final String alarmRSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;

  InformationState copyWith({
    String? appVersion,
    String? alarmRSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
  }) {
    return InformationState(
      appVersion: appVersion ?? this.appVersion,
      alarmRSeverity: alarmRSeverity ?? this.alarmRSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
    );
  }

  @override
  List<Object?> get props => [
        appVersion,
        alarmRSeverity,
        alarmTSeverity,
        alarmPSeverity,
      ];
}

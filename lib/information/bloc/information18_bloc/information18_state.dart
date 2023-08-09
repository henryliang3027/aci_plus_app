part of 'information18_bloc.dart';

class Information18State extends Equatable {
  const Information18State({
    this.status = FormStatus.none,
    this.alarmUSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
  });

  final FormStatus status;
  final String alarmUSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;

  Information18State copyWith({
    FormStatus? status,
    String? alarmUSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
  }) {
    return Information18State(
      status: status ?? this.status,
      alarmUSeverity: alarmUSeverity ?? this.alarmUSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
    );
  }

  @override
  List<Object?> get props => [
        status,
        alarmUSeverity,
        alarmTSeverity,
        alarmPSeverity,
      ];
}

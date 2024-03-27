part of 'information18_bloc.dart';

class Information18State extends Equatable {
  const Information18State({
    this.appVersion = '',
    this.configs = const [],
    this.alarmUSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
    this.errorMessage = '',
  });

  final String appVersion;
  final List<Config> configs;
  final String alarmUSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;
  final String errorMessage;

  Information18State copyWith({
    String? appVersion,
    List<Config>? configs,
    String? alarmUSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
    String? errorMessage,
  }) {
    return Information18State(
      appVersion: appVersion ?? this.appVersion,
      configs: configs ?? this.configs,
      alarmUSeverity: alarmUSeverity ?? this.alarmUSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        appVersion,
        configs,
        alarmUSeverity,
        alarmTSeverity,
        alarmPSeverity,
        errorMessage,
      ];
}

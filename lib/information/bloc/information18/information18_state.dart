part of 'information18_bloc.dart';

class Information18State extends Equatable {
  const Information18State({
    this.submissionStatus = SubmissionStatus.none,
    this.appVersion = '',
    this.configs = const [],
    this.alarmUSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
    this.errorMessage = '',
    this.characteristicDataCache = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final String appVersion;
  final List<Config> configs;
  final String alarmUSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;
  final String errorMessage;
  final Map<DataKey, String> characteristicDataCache;
  final List<String> settingResult;

  Information18State copyWith({
    SubmissionStatus? submissionStatus,
    String? appVersion,
    List<Config>? configs,
    String? alarmUSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
    String? errorMessage,
    Map<DataKey, String>? characteristicDataCache,
    List<String>? settingResult,
  }) {
    return Information18State(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      appVersion: appVersion ?? this.appVersion,
      configs: configs ?? this.configs,
      alarmUSeverity: alarmUSeverity ?? this.alarmUSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
      errorMessage: errorMessage ?? this.errorMessage,
      characteristicDataCache:
          characteristicDataCache ?? this.characteristicDataCache,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object?> get props => [
        submissionStatus,
        appVersion,
        configs,
        alarmUSeverity,
        alarmTSeverity,
        alarmPSeverity,
        errorMessage,
        characteristicDataCache,
        settingResult,
      ];
}

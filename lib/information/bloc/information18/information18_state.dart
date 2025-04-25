part of 'information18_bloc.dart';

class Information18State extends Equatable {
  const Information18State({
    this.appVersion = '',
    this.configs = const [],
    this.alarmUSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
    this.errorMessage = '',
    this.isConnected = false,
    this.characteristicDataCache = const {},
  });

  final String appVersion;
  final List<Config> configs;
  final String alarmUSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;
  final String errorMessage;
  final bool isConnected;
  final Map<DataKey, String> characteristicDataCache;

  Information18State copyWith({
    String? appVersion,
    List<Config>? configs,
    String? alarmUSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
    String? errorMessage,
    bool? isConnected,
    Map<DataKey, String>? characteristicDataCache,
  }) {
    return Information18State(
      appVersion: appVersion ?? this.appVersion,
      configs: configs ?? this.configs,
      alarmUSeverity: alarmUSeverity ?? this.alarmUSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
      errorMessage: errorMessage ?? this.errorMessage,
      isConnected: isConnected ?? this.isConnected,
      characteristicDataCache:
          characteristicDataCache ?? this.characteristicDataCache,
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
        isConnected,
        characteristicDataCache,
      ];
}

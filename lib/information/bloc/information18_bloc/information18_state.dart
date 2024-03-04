part of 'information18_bloc.dart';

class Information18State extends Equatable {
  const Information18State({
    this.isLoadConfigEnabled = false,
    this.defaultConfig = const Config(
      id: -1,
      name: '',
      splitOption: '0',
      firstChannelLoadingFrequency: '',
      firstChannelLoadingLevel: '',
      lastChannelLoadingFrequency: '',
      lastChannelLoadingLevel: '',
      isDefault: '0',
    ),
    this.alarmUSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
    this.errorMessage = '',
  });

  final bool isLoadConfigEnabled;
  final Config defaultConfig;
  final String alarmUSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;
  final String errorMessage;

  Information18State copyWith({
    bool? isLoadConfigEnabled,
    Config? defaultConfig,
    String? alarmUSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
    String? errorMessage,
  }) {
    return Information18State(
      isLoadConfigEnabled: isLoadConfigEnabled ?? this.isLoadConfigEnabled,
      defaultConfig: defaultConfig ?? this.defaultConfig,
      alarmUSeverity: alarmUSeverity ?? this.alarmUSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoadConfigEnabled,
        defaultConfig,
        alarmUSeverity,
        alarmTSeverity,
        alarmPSeverity,
        errorMessage,
      ];
}

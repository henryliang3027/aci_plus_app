part of 'information18_preset_bloc.dart';

class Information18PresetState extends Equatable {
  const Information18PresetState({
    this.settingStatus = SubmissionStatus.none,
    this.isInitialize = false,
    required this.config,
    this.settingResult = const [],
  });

  final SubmissionStatus settingStatus;
  final bool isInitialize;
  final Config config;
  final List<String> settingResult;

  Information18PresetState copyWith({
    SubmissionStatus? settingStatus,
    bool? isInitialize,
    Config? config,
    List<String>? settingResult,
  }) {
    return Information18PresetState(
      settingStatus: settingStatus ?? this.settingStatus,
      isInitialize: isInitialize ?? this.isInitialize,
      config: config ?? this.config,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        settingStatus,
        isInitialize,
        config,
        settingResult,
      ];
}

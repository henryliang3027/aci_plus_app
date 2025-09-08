part of 'information18_preset_bloc.dart';

class Information18PresetState extends Equatable {
  const Information18PresetState({
    this.settingStatus = SubmissionStatus.none,
    required this.config,
    this.settingResult = const [],
  });

  final SubmissionStatus settingStatus;
  final Config config;
  final List<String> settingResult;

  Information18PresetState copyWith({
    SubmissionStatus? settingStatus,
    Config? config,
    List<String>? settingResult,
  }) {
    return Information18PresetState(
      settingStatus: settingStatus ?? this.settingStatus,
      config: config ?? this.config,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        settingStatus,
        config,
        settingResult,
      ];
}

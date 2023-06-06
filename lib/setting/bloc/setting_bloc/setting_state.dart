part of 'setting_bloc.dart';

class SettingState extends Equatable {
  const SettingState({
    this.status = FormStatus.none,
    this.location = const Location.pure(),
    this.isGraphType = false,
    this.selectedTGCCableLength = const {
      '9': false,
      '18': false,
      '27': false,
    },
    this.selectedWorkingMode = const {
      'MGC': false,
      'AGC': false,
      'TGC': false,
    },
    this.logIntervalId = 1,
    this.pilotCode = '',
    this.pilotChannel = '',
  });

  final FormStatus status;
  final Location location;
  final bool isGraphType;
  final Map<String, bool> selectedTGCCableLength;
  final Map<String, bool> selectedWorkingMode;
  final int logIntervalId;
  final String pilotCode;
  final String pilotChannel;

  SettingState copyWith({
    FormStatus? status,
    Location? location,
    bool? isGraphType,
    Map<String, bool>? selectedTGCCableLength,
    Map<String, bool>? selectedWorkingMode,
    int? logIntervalId,
    String? pilotCode,
    String? pilotChannel,
  }) {
    return SettingState(
      status: status ?? this.status,
      location: location ?? this.location,
      isGraphType: isGraphType ?? this.isGraphType,
      selectedTGCCableLength:
          selectedTGCCableLength ?? this.selectedTGCCableLength,
      selectedWorkingMode: selectedWorkingMode ?? this.selectedWorkingMode,
      logIntervalId: logIntervalId ?? this.logIntervalId,
      pilotCode: pilotCode ?? this.pilotCode,
      pilotChannel: pilotChannel ?? this.pilotChannel,
    );
  }

  @override
  List<Object?> get props => [
        status,
        location,
        isGraphType,
        selectedTGCCableLength,
        selectedWorkingMode,
        logIntervalId,
        pilotCode,
        pilotChannel,
      ];
}

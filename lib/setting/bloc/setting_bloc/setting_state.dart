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
    this.logIntervalId = 1,
  });

  final FormStatus status;
  final Location location;
  final bool isGraphType;
  final Map<String, bool> selectedTGCCableLength;
  final int logIntervalId;

  SettingState copyWith({
    FormStatus? status,
    Location? location,
    bool? isGraphType,
    Map<String, bool>? selectedTGCCableLength,
    int? logIntervalId,
  }) {
    return SettingState(
      status: status ?? this.status,
      location: location ?? this.location,
      isGraphType: isGraphType ?? this.isGraphType,
      selectedTGCCableLength:
          selectedTGCCableLength ?? this.selectedTGCCableLength,
      logIntervalId: logIntervalId ?? this.logIntervalId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        location,
        isGraphType,
        selectedTGCCableLength,
        logIntervalId,
      ];
}

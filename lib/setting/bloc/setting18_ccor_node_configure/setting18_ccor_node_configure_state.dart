part of 'setting18_ccor_node_configure_bloc.dart';

class Setting18CCorNodeConfigureState extends Equatable {
  const Setting18CCorNodeConfigureState({
    this.submissionStatus = SubmissionStatus.none,
    this.gpsStatus = FormStatus.none,
    this.location = '',
    this.coordinates = '',
    this.forwardConfig = '',
    this.splitOption = '1',
    this.forwardMode = '',
    this.logInterval = '30',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const {},
    this.settingResult = const [],
    this.gpsCoordinateErrorMessage = '',
  });

  final SubmissionStatus submissionStatus;
  final FormStatus gpsStatus;
  final String location;
  final String coordinates;
  final String forwardConfig;
  final String splitOption;
  final String forwardMode;
  final String logInterval;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;
  final String gpsCoordinateErrorMessage;

  Setting18CCorNodeConfigureState copyWith({
    SubmissionStatus? submissionStatus,
    FormStatus? gpsStatus,
    String? location,
    String? coordinates,
    String? forwardConfig,
    String? splitOption,
    String? forwardMode,
    String? logInterval,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    Map<DataKey, String>? initialValues,
    List<String>? settingResult,
    String? gpsCoordinateErrorMessage,
  }) {
    return Setting18CCorNodeConfigureState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      gpsStatus: gpsStatus ?? this.gpsStatus,
      location: location ?? this.location,
      coordinates: coordinates ?? this.coordinates,
      forwardConfig: forwardConfig ?? this.forwardConfig,
      splitOption: splitOption ?? this.splitOption,
      forwardMode: forwardMode ?? this.forwardMode,
      logInterval: logInterval ?? this.logInterval,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
      initialValues: initialValues ?? this.initialValues,
      settingResult: settingResult ?? this.settingResult,
      gpsCoordinateErrorMessage:
          gpsCoordinateErrorMessage ?? this.gpsCoordinateErrorMessage,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        gpsStatus,
        location,
        coordinates,
        forwardConfig,
        splitOption,
        forwardMode,
        logInterval,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
        gpsCoordinateErrorMessage
      ];
}

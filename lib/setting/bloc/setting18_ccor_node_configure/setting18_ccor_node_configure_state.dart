part of 'setting18_ccor_node_configure_bloc.dart';

class Setting18CCorNodeConfigureState extends Equatable {
  const Setting18CCorNodeConfigureState({
    this.submissionStatus = SubmissionStatus.none,
    this.gpsStatus = FormStatus.none,
    this.location = '',
    this.coordinates = '',
    this.splitOption = '1',
    this.logInterval = '30',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const [],
    this.settingResult = const [],
    this.gpsCoordinateErrorMessage = '',
  });

  final SubmissionStatus submissionStatus;
  final FormStatus gpsStatus;
  final String location;
  final String coordinates;
  final String splitOption;
  final String logInterval;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final List<dynamic> initialValues;
  final List<String> settingResult;
  final String gpsCoordinateErrorMessage;

  Setting18CCorNodeConfigureState copyWith({
    SubmissionStatus? submissionStatus,
    FormStatus? gpsStatus,
    String? location,
    String? coordinates,
    String? splitOption,
    String? logInterval,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    List<dynamic>? initialValues,
    List<String>? settingResult,
    String? gpsCoordinateErrorMessage,
  }) {
    return Setting18CCorNodeConfigureState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      gpsStatus: gpsStatus ?? this.gpsStatus,
      location: location ?? this.location,
      coordinates: coordinates ?? this.coordinates,
      splitOption: splitOption ?? this.splitOption,
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
        splitOption,
        logInterval,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
        gpsCoordinateErrorMessage
      ];
}

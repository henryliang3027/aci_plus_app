part of 'setting18_ccor_node_attribute_bloc.dart';

class Setting18CCorNodeAttributeState extends Equatable {
  const Setting18CCorNodeAttributeState({
    this.submissionStatus = SubmissionStatus.none,
    this.gpsStatus = FormStatus.none,
    this.location = '',
    this.coordinates = const CoordinateInput.pure(),
    this.technicianID = '',
    // this.inputSignalLevel = '',
    // this.inputAttenuation = '',
    // this.inputEqualizer = '',
    this.cascadePosition = '',
    this.deviceName = '',
    this.deviceNote = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const {},
    this.tappedSet = const {},
    this.settingResult = const [],
    this.gpsCoordinateErrorMessage = '',
  });

  final SubmissionStatus submissionStatus;
  final FormStatus gpsStatus;
  final String location;
  final CoordinateInput coordinates;
  final String technicianID;
  // final String inputSignalLevel;
  // final String inputAttenuation;
  // final String inputEqualizer;
  final String cascadePosition;
  final String deviceName;
  final String deviceNote;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
  final Set<DataKey> tappedSet;
  final List<String> settingResult;
  final String gpsCoordinateErrorMessage;

  Setting18CCorNodeAttributeState copyWith({
    SubmissionStatus? submissionStatus,
    FormStatus? gpsStatus,
    String? location,
    CoordinateInput? coordinates,
    String? technicianID,
    // String? inputSignalLevel,
    // String? inputAttenuation,
    // String? inputEqualizer,
    String? cascadePosition,
    String? deviceName,
    String? deviceNote,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    Map<DataKey, String>? initialValues,
    Set<DataKey>? tappedSet,
    List<String>? settingResult,
    String? gpsCoordinateErrorMessage,
  }) {
    return Setting18CCorNodeAttributeState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      gpsStatus: gpsStatus ?? this.gpsStatus,
      location: location ?? this.location,
      coordinates: coordinates ?? this.coordinates,
      technicianID: technicianID ?? this.technicianID,
      // inputSignalLevel: inputSignalLevel ?? this.inputSignalLevel,
      // inputAttenuation: inputAttenuation ?? this.inputAttenuation,
      // inputEqualizer: inputEqualizer ?? this.inputEqualizer,
      cascadePosition: cascadePosition ?? this.cascadePosition,
      deviceName: deviceName ?? this.deviceName,
      deviceNote: deviceNote ?? this.deviceNote,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
      initialValues: initialValues ?? this.initialValues,
      tappedSet: tappedSet ?? this.tappedSet,
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
        technicianID,
        // inputSignalLevel,
        // inputAttenuation,
        // inputEqualizer,
        cascadePosition,
        deviceName,
        deviceNote,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
        gpsCoordinateErrorMessage
      ];
}

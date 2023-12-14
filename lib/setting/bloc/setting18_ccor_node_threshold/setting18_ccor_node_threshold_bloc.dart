import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_threshold_event.dart';
part 'setting18_ccor_node_threshold_state.dart';

class Setting18CCorNodeThresholdBloc extends Bloc<
    Setting18CCorNodeThresholdEvent, Setting18CCorNodeThresholdState> {
  Setting18CCorNodeThresholdBloc({
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
    required UnitRepository unitRepository,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        _unitRepository = unitRepository,
        super(const Setting18CCorNodeThresholdState()) {
    on<Initialized>(_onInitialized);
    on<TemperatureAlarmChanged>(_onTemperatureAlarmChanged);
    on<MinTemperatureChanged>(_onMinTemperatureChanged);
    on<MaxTemperatureChanged>(_onMaxTemperatureChanged);
    on<VoltageAlarmChanged>(_onVoltageAlarmChanged);
    on<MinVoltageChanged>(_onMinVoltageChanged);
    on<MaxVoltageChanged>(_onMaxVoltageChanged);
    on<SplitOptionAlarmChanged>(_onSplitOptionAlarmChanged);

    // port 1
    on<RFOutputPowerAlarmState1Changed>(_onRFOutputPowerAlarmState1Changed);
    on<MinRFOutputPower1Changed>(_onMinRFOutputPower1Changed);
    on<MaxRFOutputPower1Changed>(_onMaxRFOutputPower1Changed);
    // port 1

    // port 3
    on<RFOutputPowerAlarmState3Changed>(_onRFOutputPowerAlarmState3Changed);
    on<MinRFOutputPower3Changed>(_onMinRFOutputPower3Changed);
    on<MaxRFOutputPower3Changed>(_onMaxRFOutputPower3Changed);
    // port 3

    // port 4
    on<RFOutputPowerAlarmState4Changed>(_onRFOutputPowerAlarmState4Changed);
    on<MinRFOutputPower4Changed>(_onMinRFOutputPower4Changed);
    on<MaxRFOutputPower4Changed>(_onMaxRFOutputPower4Changed);
    // port 4

    // port 6
    on<RFOutputPowerAlarmState6Changed>(_onRFOutputPowerAlarmState6Changed);
    on<MinRFOutputPower6Changed>(_onMinRFOutputPower6Changed);
    on<MaxRFOutputPower6Changed>(_onMaxRFOutputPower6Changed);
    // port 6

    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;
  final UnitRepository _unitRepository;

  String getMinTemperature({
    required String minTemperatureC,
    required String minTemperatureF,
  }) {
    String minTemperature = '';
    if (_unitRepository.temperatureUnit == TemperatureUnit.celsius) {
      minTemperature = minTemperatureC;
    } else {
      minTemperature = minTemperatureF;
    }

    return minTemperature;
  }

  String getMaxTemperature({
    required String maxTemperatureC,
    required String maxTemperatureF,
  }) {
    String maxTemperature = '';
    if (_unitRepository.temperatureUnit == TemperatureUnit.celsius) {
      maxTemperature = maxTemperatureC;
    } else {
      maxTemperature = maxTemperatureF;
    }

    return maxTemperature;
  }

  String _boolToStringNumber(bool value) {
    if (value) {
      // alarm enable
      return '0';
    } else {
      // alarm mask
      return '1';
    }
  }

  bool _stringNumberToBool(String value) {
    return value == '1' ? false : true;
  }

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18CCorNodeRepository.characteristicDataCache;

    String minTemperatureC =
        characteristicDataCache[DataKey.minTemperatureC] ?? '';
    String maxTemperatureC =
        characteristicDataCache[DataKey.maxTemperatureC] ?? '';
    String minTemperatureF =
        characteristicDataCache[DataKey.minTemperatureF] ?? '';
    String maxTemperatureF =
        characteristicDataCache[DataKey.maxTemperatureF] ?? '';
    String minVoltage = characteristicDataCache[DataKey.minVoltage] ?? '';
    String maxVoltage = characteristicDataCache[DataKey.maxVoltage] ?? '';

    String strTemperatureAlarmState =
        characteristicDataCache[DataKey.temperatureAlarmState] ?? '';
    bool temperatureAlarmState = strTemperatureAlarmState == '1' ? false : true;

    String strVoltageAlarmState =
        characteristicDataCache[DataKey.voltageAlarmState] ?? '';
    bool voltageAlarmState = strVoltageAlarmState == '1' ? false : true;

    String strSplitOptionAlarmState =
        characteristicDataCache[DataKey.splitOptionAlarmState] ?? '';
    bool splitOptionAlarmState = strSplitOptionAlarmState == '1' ? false : true;

    String strRFOutputPower1AlarmState =
        characteristicDataCache[DataKey.rfOutputPower1AlarmState] ?? '';
    bool rfOutputPower1AlarmState =
        strRFOutputPower1AlarmState == '1' ? false : true;

    String strRFOutputPower3AlarmState =
        characteristicDataCache[DataKey.rfOutputPower3AlarmState] ?? '';
    bool rfOutputPower3AlarmState =
        strRFOutputPower3AlarmState == '1' ? false : true;

    String strRFOutputPower4AlarmState =
        characteristicDataCache[DataKey.rfOutputPower4AlarmState] ?? '';
    bool rfOutputPower4AlarmState =
        strRFOutputPower4AlarmState == '1' ? false : true;

    String strRFOutputPower6AlarmState =
        characteristicDataCache[DataKey.rfOutputPower6AlarmState] ?? '';
    bool rfOutputPower6AlarmState =
        strRFOutputPower6AlarmState == '1' ? false : true;

    String minRFOutputPower1 =
        characteristicDataCache[DataKey.minRFOutputPower1] ?? '';
    String maxRFOutputPower1 =
        characteristicDataCache[DataKey.maxRFOutputPower1] ?? '';
    String minRFOutputPower3 =
        characteristicDataCache[DataKey.minRFOutputPower3] ?? '';
    String maxRFOutputPower3 =
        characteristicDataCache[DataKey.maxRFOutputPower3] ?? '';
    String minRFOutputPower4 =
        characteristicDataCache[DataKey.minRFOutputPower4] ?? '';
    String maxRFOutputPower4 =
        characteristicDataCache[DataKey.maxRFOutputPower4] ?? '';
    String minRFOutputPower6 =
        characteristicDataCache[DataKey.minRFOutputPower6] ?? '';
    String maxRFOutputPower6 =
        characteristicDataCache[DataKey.maxRFOutputPower6] ?? '';

    emit(state.copyWith(
      temperatureAlarmState: _stringNumberToBool(strTemperatureAlarmState),
      minTemperature: getMinTemperature(
        minTemperatureC: minTemperatureC,
        minTemperatureF: minTemperatureF,
      ),
      maxTemperature: getMaxTemperature(
        maxTemperatureC: maxTemperatureC,
        maxTemperatureF: maxTemperatureF,
      ),
      temperatureUnit: _unitRepository.temperatureUnit,
      voltageAlarmState: _stringNumberToBool(strVoltageAlarmState),
      minVoltage: minVoltage,
      maxVoltage: maxVoltage,
      splitOptionAlarmState: _stringNumberToBool(strSplitOptionAlarmState),
      rfOutputPower1AlarmState:
          _stringNumberToBool(strRFOutputPower1AlarmState),
      minRFOutputPower1: minRFOutputPower1,
      maxRFOutputPower1: maxRFOutputPower1,
      rfOutputPower3AlarmState: rfOutputPower3AlarmState,
      minRFOutputPower3: minRFOutputPower3,
      maxRFOutputPower3: maxRFOutputPower3,
      rfOutputPower4AlarmState: rfOutputPower4AlarmState,
      minRFOutputPower4: minRFOutputPower4,
      maxRFOutputPower4: maxRFOutputPower4,
      rfOutputPower6AlarmState: rfOutputPower6AlarmState,
      minRFOutputPower6: minRFOutputPower6,
      maxRFOutputPower6: maxRFOutputPower6,
      isInitialize: true,
      initialValues: characteristicDataCache,
    ));
  }

  void _onTemperatureAlarmChanged(
    TemperatureAlarmChanged event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      temperatureAlarmState: event.temperatureAlarmState,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: event.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onMinTemperatureChanged(
    MinTemperatureChanged event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      minTemperature: event.minTemperature,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: event.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onMaxTemperatureChanged(
    MaxTemperatureChanged event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      maxTemperature: event.maxTemperature,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: event.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onVoltageAlarmChanged(
    VoltageAlarmChanged event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      voltageAlarmState: event.voltageAlarmState,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: event.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onMinVoltageChanged(
    MinVoltageChanged event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      minVoltage: event.minVoltage,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: event.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onMaxVoltageChanged(
    MaxVoltageChanged event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      maxVoltage: event.maxVoltage,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: event.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onSplitOptionAlarmChanged(
    SplitOptionAlarmChanged event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      splitOptionAlarmState: event.splitOptionAlarmState,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: event.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  // port 1
  void _onRFOutputPowerAlarmState1Changed(
    RFOutputPowerAlarmState1Changed event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rfOutputPower1AlarmState: event.rfOutputPower1AlarmState,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: event.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onMinRFOutputPower1Changed(
    MinRFOutputPower1Changed event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      minRFOutputPower1: event.minRFOutputPower1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: event.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onMaxRFOutputPower1Changed(
    MaxRFOutputPower1Changed event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      maxRFOutputPower1: event.maxRFOutputPower1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: event.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }
  // port 1

  // port 3
  void _onRFOutputPowerAlarmState3Changed(
    RFOutputPowerAlarmState3Changed event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rfOutputPower3AlarmState: event.rfOutputPower3AlarmState,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: event.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onMinRFOutputPower3Changed(
    MinRFOutputPower3Changed event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      minRFOutputPower3: event.minRFOutputPower3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: event.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onMaxRFOutputPower3Changed(
    MaxRFOutputPower3Changed event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      maxRFOutputPower3: event.maxRFOutputPower3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: event.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }
  // port 3

  // port 4
  void _onRFOutputPowerAlarmState4Changed(
    RFOutputPowerAlarmState4Changed event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rfOutputPower4AlarmState: event.rfOutputPower4AlarmState,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: event.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onMinRFOutputPower4Changed(
    MinRFOutputPower4Changed event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      minRFOutputPower4: event.minRFOutputPower4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: event.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onMaxRFOutputPower4Changed(
    MaxRFOutputPower4Changed event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      maxRFOutputPower4: event.maxRFOutputPower4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: event.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }
  // port 4

  // port 6
  void _onRFOutputPowerAlarmState6Changed(
    RFOutputPowerAlarmState6Changed event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rfOutputPower6AlarmState: event.rfOutputPower6AlarmState,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: event.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onMinRFOutputPower6Changed(
    MinRFOutputPower6Changed event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      minRFOutputPower6: event.minRFOutputPower6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: event.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
      ),
    ));
  }

  void _onMaxRFOutputPower6Changed(
    MaxRFOutputPower6Changed event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      maxRFOutputPower6: event.maxRFOutputPower6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        splitOptionAlarmState: state.splitOptionAlarmState,
        rfOutputPower1AlarmState: state.rfOutputPower1AlarmState,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        rfOutputPower3AlarmState: state.rfOutputPower3AlarmState,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        rfOutputPower4AlarmState: state.rfOutputPower4AlarmState,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        rfOutputPower6AlarmState: state.rfOutputPower6AlarmState,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: event.maxRFOutputPower6,
      ),
    ));
  }
  // port 6

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) {
    String minTemperatureC = state.initialValues[DataKey.minTemperatureC] ?? '';
    String maxTemperatureC = state.initialValues[DataKey.maxTemperatureC] ?? '';
    String minTemperatureF = state.initialValues[DataKey.minTemperatureF] ?? '';
    String maxTemperatureF = state.initialValues[DataKey.maxTemperatureF] ?? '';

    String strTemperatureAlarmState =
        state.initialValues[DataKey.temperatureAlarmState] ?? '';

    String strVoltageAlarmState =
        state.initialValues[DataKey.voltageAlarmState] ?? '';

    String strSplitOptionAlarmState =
        state.initialValues[DataKey.splitOptionAlarmState] ?? '';

    String strRFOutputPower1AlarmState =
        state.initialValues[DataKey.rfOutputPower1AlarmState] ?? '';

    String strRFOutputPower3AlarmState =
        state.initialValues[DataKey.rfOutputPower3AlarmState] ?? '';

    String strRFOutputPower4AlarmState =
        state.initialValues[DataKey.rfOutputPower4AlarmState] ?? '';

    String strRFOutputPower6AlarmState =
        state.initialValues[DataKey.rfOutputPower6AlarmState] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: true,
      editMode: false,
      enableSubmission: false,
      temperatureAlarmState: _stringNumberToBool(strTemperatureAlarmState),
      minTemperature: getMinTemperature(
        minTemperatureC: minTemperatureC,
        minTemperatureF: minTemperatureF,
      ),
      maxTemperature: getMaxTemperature(
        maxTemperatureC: maxTemperatureC,
        maxTemperatureF: maxTemperatureF,
      ),
      temperatureUnit: _unitRepository.temperatureUnit,
      voltageAlarmState: _stringNumberToBool(strVoltageAlarmState),
      minVoltage: state.initialValues[DataKey.minVoltage],
      maxVoltage: state.initialValues[DataKey.maxVoltage],
      splitOptionAlarmState: _stringNumberToBool(strSplitOptionAlarmState),
      rfOutputPower1AlarmState:
          _stringNumberToBool(strRFOutputPower1AlarmState),
      minRFOutputPower1: state.initialValues[DataKey.minRFOutputPower1],
      maxRFOutputPower1: state.initialValues[DataKey.maxRFOutputPower1],
      rfOutputPower3AlarmState:
          _stringNumberToBool(strRFOutputPower3AlarmState),
      minRFOutputPower3: state.initialValues[DataKey.minRFOutputPower3],
      maxRFOutputPower3: state.initialValues[DataKey.maxRFOutputPower3],
      rfOutputPower4AlarmState:
          _stringNumberToBool(strRFOutputPower4AlarmState),
      minRFOutputPower4: state.initialValues[DataKey.minRFOutputPower4],
      maxRFOutputPower4: state.initialValues[DataKey.maxRFOutputPower4],
      rfOutputPower6AlarmState:
          _stringNumberToBool(strRFOutputPower6AlarmState),
      minRFOutputPower6: state.initialValues[DataKey.minRFOutputPower6],
      maxRFOutputPower6: state.initialValues[DataKey.maxRFOutputPower6],
    ));
  }

  bool _isEnabledSubmission({
    required bool temperatureAlarmState,
    required String minTemperature,
    required String maxTemperature,
    required bool voltageAlarmState,
    required String minVoltage,
    required String maxVoltage,
    required bool splitOptionAlarmState,
    required bool rfOutputPower1AlarmState,
    required String minRFOutputPower1,
    required String maxRFOutputPower1,
    required bool rfOutputPower3AlarmState,
    required String minRFOutputPower3,
    required String maxRFOutputPower3,
    required bool rfOutputPower4AlarmState,
    required String minRFOutputPower4,
    required String maxRFOutputPower4,
    required bool rfOutputPower6AlarmState,
    required String minRFOutputPower6,
    required String maxRFOutputPower6,
  }) {
    String minTemperatureC = state.initialValues[DataKey.minTemperatureC] ?? '';
    String maxTemperatureC = state.initialValues[DataKey.maxTemperatureC] ?? '';
    String minTemperatureF = state.initialValues[DataKey.minTemperatureF] ?? '';
    String maxTemperatureF = state.initialValues[DataKey.maxTemperatureF] ?? '';

    String strTemperatureAlarmState =
        state.initialValues[DataKey.temperatureAlarmState] ?? '';

    String strVoltageAlarmState =
        state.initialValues[DataKey.voltageAlarmState] ?? '';

    String strSplitOptionAlarmState =
        state.initialValues[DataKey.splitOptionAlarmState] ?? '';

    String strRFOutputPower1AlarmState =
        state.initialValues[DataKey.rfOutputPower1AlarmState] ?? '';

    String strRFOutputPower3AlarmState =
        state.initialValues[DataKey.rfOutputPower3AlarmState] ?? '';

    String strRFOutputPower4AlarmState =
        state.initialValues[DataKey.rfOutputPower4AlarmState] ?? '';

    String strRFOutputPower6AlarmState =
        state.initialValues[DataKey.rfOutputPower6AlarmState] ?? '';

    if (temperatureAlarmState !=
            _stringNumberToBool(strTemperatureAlarmState) ||
        minTemperature !=
            getMinTemperature(
              minTemperatureC: minTemperatureC,
              minTemperatureF: minTemperatureF,
            ) ||
        maxTemperature !=
            getMaxTemperature(
              maxTemperatureC: maxTemperatureC,
              maxTemperatureF: maxTemperatureF,
            ) ||
        voltageAlarmState != _stringNumberToBool(strVoltageAlarmState) ||
        minVoltage != state.initialValues[DataKey.minVoltage] ||
        maxVoltage != state.initialValues[DataKey.maxVoltage] ||
        splitOptionAlarmState !=
            _stringNumberToBool(strSplitOptionAlarmState) ||
        rfOutputPower1AlarmState !=
            _stringNumberToBool(strRFOutputPower1AlarmState) ||
        minRFOutputPower1 != state.initialValues[DataKey.minRFOutputPower1] ||
        maxRFOutputPower1 != state.initialValues[DataKey.maxRFOutputPower1] ||
        rfOutputPower3AlarmState !=
            _stringNumberToBool(strRFOutputPower3AlarmState) ||
        minRFOutputPower3 != state.initialValues[DataKey.minRFOutputPower3] ||
        maxRFOutputPower3 != state.initialValues[DataKey.maxRFOutputPower3] ||
        rfOutputPower4AlarmState !=
            _stringNumberToBool(strRFOutputPower4AlarmState) ||
        minRFOutputPower4 != state.initialValues[DataKey.minRFOutputPower4] ||
        maxRFOutputPower4 != state.initialValues[DataKey.maxRFOutputPower4] ||
        rfOutputPower6AlarmState !=
            _stringNumberToBool(strRFOutputPower6AlarmState) ||
        minRFOutputPower6 != state.initialValues[DataKey.minRFOutputPower6] ||
        maxRFOutputPower6 != state.initialValues[DataKey.maxRFOutputPower6]) {
      return true;
    } else {
      return false;
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    String minTemperatureC = state.initialValues[DataKey.minTemperatureC] ?? '';
    String maxTemperatureC = state.initialValues[DataKey.maxTemperatureC] ?? '';
    String minTemperatureF = state.initialValues[DataKey.minTemperatureF] ?? '';
    String maxTemperatureF = state.initialValues[DataKey.maxTemperatureF] ?? '';

    String strTemperatureAlarmState =
        state.initialValues[DataKey.temperatureAlarmState] ?? '';

    String strVoltageAlarmState =
        state.initialValues[DataKey.voltageAlarmState] ?? '';

    String strSplitOptionAlarmState =
        state.initialValues[DataKey.splitOptionAlarmState] ?? '';

    String strRFOutputPower1AlarmState =
        state.initialValues[DataKey.rfOutputPower1AlarmState] ?? '';

    String strRFOutputPower3AlarmState =
        state.initialValues[DataKey.rfOutputPower3AlarmState] ?? '';

    String strRFOutputPower4AlarmState =
        state.initialValues[DataKey.rfOutputPower4AlarmState] ?? '';

    String strRFOutputPower6AlarmState =
        state.initialValues[DataKey.rfOutputPower6AlarmState] ?? '';

    String minTemperature = getMinTemperature(
      minTemperatureC: minTemperatureC,
      minTemperatureF: minTemperatureF,
    );
    String maxTemperature = getMaxTemperature(
      maxTemperatureC: maxTemperatureC,
      maxTemperatureF: maxTemperatureF,
    );

    List<String> settingResult = [];

    if (state.temperatureAlarmState !=
        _stringNumberToBool(strTemperatureAlarmState)) {
      String temperatureAlarmState =
          _boolToStringNumber(state.temperatureAlarmState);
      bool resultOfSetTemperatureAlarmState = await _amp18CCorNodeRepository
          .set1p8GCCorNodeTemperatureAlarmState(temperatureAlarmState);

      settingResult.add(
          '${DataKey.temperatureAlarmState.name},$resultOfSetTemperatureAlarmState');
    }

    if (state.minTemperature != minTemperature) {
      String minTemperature = state.minTemperature;
      if (state.temperatureUnit == TemperatureUnit.fahrenheit) {
        minTemperature = _unitRepository
            .convertStrFahrenheitToCelcius(minTemperature)
            .toStringAsFixed(1);
      }

      bool resultOfSetMinTemperature = await _amp18CCorNodeRepository
          .set1p8GCCorNodeMinTemperature(minTemperature);

      settingResult
          .add('${DataKey.minTemperatureC.name},$resultOfSetMinTemperature');
    }

    if (state.maxTemperature != maxTemperature) {
      String maxTemperature = state.maxTemperature;
      if (state.temperatureUnit == TemperatureUnit.fahrenheit) {
        maxTemperature = _unitRepository
            .convertStrFahrenheitToCelcius(maxTemperature)
            .toStringAsFixed(1);
      }

      bool resultOfSetMaxTemperature = await _amp18CCorNodeRepository
          .set1p8GCCorNodeMaxTemperature(maxTemperature);

      settingResult
          .add('${DataKey.maxTemperatureC.name},$resultOfSetMaxTemperature');
    }

    if (state.voltageAlarmState != _stringNumberToBool(strVoltageAlarmState)) {
      String voltageAlarmState = _boolToStringNumber(state.voltageAlarmState);
      bool resultOfSetVoltageAlarmState = await _amp18CCorNodeRepository
          .set1p8GCCorNodeVoltageAlarmState(voltageAlarmState);

      settingResult.add(
          '${DataKey.voltageAlarmState.name},$resultOfSetVoltageAlarmState');
    }

    if (state.minVoltage != state.initialValues[DataKey.minVoltage]) {
      bool resultOfSetMinVoltage = await _amp18CCorNodeRepository
          .set1p8GCCorNodeMinVoltage(state.minVoltage);

      settingResult.add('${DataKey.minVoltage.name},$resultOfSetMinVoltage');
    }

    if (state.maxVoltage != state.initialValues[DataKey.maxVoltage]) {
      bool resultOfSetMaxVoltage = await _amp18CCorNodeRepository
          .set1p8GCCorNodeMaxVoltage(state.maxVoltage);

      settingResult.add('${DataKey.maxVoltage.name},$resultOfSetMaxVoltage');
    }

    if (state.splitOptionAlarmState !=
        _stringNumberToBool(strSplitOptionAlarmState)) {
      String splitOptionAlarmState =
          _boolToStringNumber(state.splitOptionAlarmState);
      bool resultOfSetSplitOptionAlarmState = await _amp18CCorNodeRepository
          .set1p8GCCorNodeSplitOptionAlarmState(splitOptionAlarmState);

      settingResult.add(
          '${DataKey.splitOptionAlarmState.name},$resultOfSetSplitOptionAlarmState');
    }

    if (state.rfOutputPower1AlarmState !=
        _stringNumberToBool(strRFOutputPower1AlarmState)) {
      String rfOutputPower1AlarmState =
          _boolToStringNumber(state.rfOutputPower1AlarmState);
      bool resultOfSetRFOutputPower1AlarmState = await _amp18CCorNodeRepository
          .set1p8GCCorNodeRFOutputPower1AlarmState(rfOutputPower1AlarmState);

      settingResult.add(
          '${DataKey.rfOutputPower1AlarmState.name},$resultOfSetRFOutputPower1AlarmState');
    }

    if (state.minRFOutputPower1 !=
        state.initialValues[DataKey.minRFOutputPower1]) {
      bool resultOfSetMinRFOutputPower1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeMinRFOutputPower1(state.minRFOutputPower1);

      settingResult.add(
          '${DataKey.minRFOutputPower1.name},$resultOfSetMinRFOutputPower1');
    }

    if (state.maxRFOutputPower1 !=
        state.initialValues[DataKey.maxRFOutputPower1]) {
      bool resultOfSetMaxRFOutputPower1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeMaxRFOutputPower1(state.maxRFOutputPower1);

      settingResult.add(
          '${DataKey.maxRFOutputPower1.name},$resultOfSetMaxRFOutputPower1');
    }

    if (state.rfOutputPower3AlarmState !=
        _stringNumberToBool(strRFOutputPower3AlarmState)) {
      String rfOutputPower3AlarmState =
          _boolToStringNumber(state.rfOutputPower3AlarmState);
      bool resultOfSetRFOutputPower3AlarmState = await _amp18CCorNodeRepository
          .set1p8GCCorNodeRFOutputPower3AlarmState(rfOutputPower3AlarmState);

      settingResult.add(
          '${DataKey.rfOutputPower3AlarmState.name},$resultOfSetRFOutputPower3AlarmState');
    }

    if (state.minRFOutputPower3 !=
        state.initialValues[DataKey.minRFOutputPower3]) {
      bool resultOfSetMinRFOutputPower3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeMinRFOutputPower3(state.minRFOutputPower3);

      settingResult.add(
          '${DataKey.minRFOutputPower3.name},$resultOfSetMinRFOutputPower3');
    }

    if (state.maxRFOutputPower3 !=
        state.initialValues[DataKey.maxRFOutputPower3]) {
      bool resultOfSetMaxRFOutputPower3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeMaxRFOutputPower3(state.maxRFOutputPower3);

      settingResult.add(
          '${DataKey.maxRFOutputPower3.name},$resultOfSetMaxRFOutputPower3');
    }

    if (state.rfOutputPower4AlarmState !=
        _stringNumberToBool(strRFOutputPower4AlarmState)) {
      String rfOutputPower4AlarmState =
          _boolToStringNumber(state.rfOutputPower4AlarmState);
      bool resultOfSetRFOutputPower4AlarmState = await _amp18CCorNodeRepository
          .set1p8GCCorNodeRFOutputPower4AlarmState(rfOutputPower4AlarmState);

      settingResult.add(
          '${DataKey.rfOutputPower4AlarmState.name},$resultOfSetRFOutputPower4AlarmState');
    }

    if (state.minRFOutputPower4 !=
        state.initialValues[DataKey.minRFOutputPower4]) {
      bool resultOfSetMinRFOutputPower4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeMinRFOutputPower4(state.minRFOutputPower4);

      settingResult.add(
          '${DataKey.minRFOutputPower1.name},$resultOfSetMinRFOutputPower4');
    }

    if (state.maxRFOutputPower4 !=
        state.initialValues[DataKey.maxRFOutputPower4]) {
      bool resultOfSetMaxRFOutputPower4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeMaxRFOutputPower4(state.maxRFOutputPower4);

      settingResult.add(
          '${DataKey.maxRFOutputPower4.name},$resultOfSetMaxRFOutputPower4');
    }

    if (state.rfOutputPower6AlarmState !=
        _stringNumberToBool(strRFOutputPower6AlarmState)) {
      String rfOutputPower6AlarmState =
          _boolToStringNumber(state.rfOutputPower6AlarmState);
      bool resultOfSetRFOutputPower6AlarmState = await _amp18CCorNodeRepository
          .set1p8GCCorNodeRFOutputPower6AlarmState(rfOutputPower6AlarmState);

      settingResult.add(
          '${DataKey.rfOutputPower6AlarmState.name},$resultOfSetRFOutputPower6AlarmState');
    }

    if (state.minRFOutputPower6 !=
        state.initialValues[DataKey.minRFOutputPower6]) {
      bool resultOfSetMinRFOutputPower6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeMinRFOutputPower6(state.minRFOutputPower6);

      settingResult.add(
          '${DataKey.minRFOutputPower6.name},$resultOfSetMinRFOutputPower6');
    }

    if (state.maxRFOutputPower6 !=
        state.initialValues[DataKey.maxRFOutputPower6]) {
      bool resultOfSetMaxRFOutputPower6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeMaxRFOutputPower6(state.maxRFOutputPower6);

      settingResult.add(
          '${DataKey.maxRFOutputPower6.name},$resultOfSetMaxRFOutputPower6');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18CCorNodeRepository.update1p8GCCorNodeCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      editMode: false,
    ));
  }
}

import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/repositories/unit_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_threshold_event.dart';
part 'setting18_ccor_node_threshold_state.dart';

class Setting18CCorNodeThresholdBloc extends Bloc<
    Setting18CCorNodeThresholdEvent, Setting18CCorNodeThresholdState> {
  Setting18CCorNodeThresholdBloc({
    required DsimRepository dsimRepository,
    required UnitRepository unitRepository,
  })  : _dsimRepository = dsimRepository,
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
    on<OutputAttenuation1Changed>(_onOutputAttenuation1Changed);
    on<OutputEqualizer1Changed>(_onOutputEqualizer1Changed);
    // port 1

    // port 3
    on<RFOutputPowerAlarmState3Changed>(_onRFOutputPowerAlarmState3Changed);
    on<MinRFOutputPower3Changed>(_onMinRFOutputPower3Changed);
    on<MaxRFOutputPower3Changed>(_onMaxRFOutputPower3Changed);
    on<OutputAttenuation3Changed>(_onOutputAttenuation3Changed);
    on<OutputEqualizer3Changed>(_onOutputEqualizer3Changed);
    // port 3

    // port 4
    on<RFOutputPowerAlarmState4Changed>(_onRFOutputPowerAlarmState4Changed);
    on<MinRFOutputPower4Changed>(_onMinRFOutputPower4Changed);
    on<MaxRFOutputPower4Changed>(_onMaxRFOutputPower4Changed);
    on<OutputAttenuation4Changed>(_onOutputAttenuation4Changed);
    on<OutputEqualizer4Changed>(_onOutputEqualizer4Changed);
    // port 4

    // port 6
    on<RFOutputPowerAlarmState6Changed>(_onRFOutputPowerAlarmState6Changed);
    on<MinRFOutputPower6Changed>(_onMinRFOutputPower6Changed);
    on<MaxRFOutputPower6Changed>(_onMaxRFOutputPower6Changed);
    on<OutputAttenuation6Changed>(_onOutputAttenuation6Changed);
    on<OutputEqualizer6Changed>(_onOutputEqualizer6Changed);
    // port 6

    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final DsimRepository _dsimRepository;
  final UnitRepository _unitRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18CCorNodeThresholdState> emit,
  ) async {
    String minTemperature = '';
    String maxTemperature = '';

    if (_unitRepository.temperatureUnit == TemperatureUnit.celsius) {
      minTemperature = event.minTemperature;
      maxTemperature = event.maxTemperature;
    } else {
      minTemperature = event.minTemperatureF;
      maxTemperature = event.maxTemperatureF;
    }

    emit(state.copyWith(
      temperatureAlarmState: event.temperatureAlarmState,
      minTemperature: minTemperature,
      maxTemperature: maxTemperature,
      temperatureUnit: _unitRepository.temperatureUnit,
      voltageAlarmState: event.voltageAlarmState,
      minVoltage: event.minVoltage,
      maxVoltage: event.maxVoltage,
      splitOptionAlarmState: event.splitOptionAlarmState,
      rfOutputPowerAlarmState1: event.rfOutputPowerAlarmState1,
      minRFOutputPower1: event.minRFOutputPower1,
      maxRFOutputPower1: event.maxRFOutputPower1,
      outputAttenuation1: event.outputAttenuation1,
      outputEqualizer1: event.outputEqualizer1,
      rfOutputPowerAlarmState3: event.rfOutputPowerAlarmState3,
      minRFOutputPower3: event.minRFOutputPower3,
      maxRFOutputPower3: event.maxRFOutputPower3,
      outputAttenuation3: event.outputAttenuation3,
      outputEqualizer3: event.outputEqualizer3,
      rfOutputPowerAlarmState4: event.rfOutputPowerAlarmState4,
      minRFOutputPower4: event.minRFOutputPower4,
      maxRFOutputPower4: event.maxRFOutputPower4,
      outputAttenuation4: event.outputAttenuation4,
      outputEqualizer4: event.outputEqualizer4,
      rfOutputPowerAlarmState6: event.rfOutputPowerAlarmState6,
      minRFOutputPower6: event.minRFOutputPower6,
      maxRFOutputPower6: event.maxRFOutputPower6,
      outputAttenuation6: event.outputAttenuation6,
      outputEqualizer6: event.outputEqualizer6,
      isInitialize: true,
      initialValues: [
        event.temperatureAlarmState,
        minTemperature,
        maxTemperature,
        event.voltageAlarmState,
        event.minVoltage,
        event.maxVoltage,
        event.splitOptionAlarmState,
        event.rfOutputPowerAlarmState1,
        event.minRFOutputPower1,
        event.maxRFOutputPower1,
        event.outputAttenuation1,
        event.outputEqualizer1,
        event.rfOutputPowerAlarmState3,
        event.minRFOutputPower3,
        event.maxRFOutputPower3,
        event.outputAttenuation3,
        event.outputEqualizer3,
        event.rfOutputPowerAlarmState4,
        event.minRFOutputPower4,
        event.maxRFOutputPower4,
        event.outputAttenuation4,
        event.outputEqualizer4,
        event.rfOutputPowerAlarmState6,
        event.minRFOutputPower6,
        event.maxRFOutputPower6,
        event.outputAttenuation6,
        event.outputEqualizer6,
      ],
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
        rfOutputPowerAlarmState1: state.rfOutputPowerAlarmState1,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        outputAttenuation1: state.outputAttenuation1,
        outputEqualizer1: state.outputEqualizer1,
        rfOutputPowerAlarmState3: state.rfOutputPowerAlarmState3,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        outputAttenuation3: state.outputAttenuation3,
        outputEqualizer3: state.outputEqualizer3,
        rfOutputPowerAlarmState4: state.rfOutputPowerAlarmState4,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        outputAttenuation4: state.outputAttenuation4,
        outputEqualizer4: state.outputEqualizer4,
        rfOutputPowerAlarmState6: state.rfOutputPowerAlarmState6,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
        outputAttenuation6: state.outputAttenuation6,
        outputEqualizer6: state.outputEqualizer6,
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
        rfOutputPowerAlarmState1: state.rfOutputPowerAlarmState1,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        outputAttenuation1: state.outputAttenuation1,
        outputEqualizer1: state.outputEqualizer1,
        rfOutputPowerAlarmState3: state.rfOutputPowerAlarmState3,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        outputAttenuation3: state.outputAttenuation3,
        outputEqualizer3: state.outputEqualizer3,
        rfOutputPowerAlarmState4: state.rfOutputPowerAlarmState4,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        outputAttenuation4: state.outputAttenuation4,
        outputEqualizer4: state.outputEqualizer4,
        rfOutputPowerAlarmState6: state.rfOutputPowerAlarmState6,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
        outputAttenuation6: state.outputAttenuation6,
        outputEqualizer6: state.outputEqualizer6,
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
        rfOutputPowerAlarmState1: state.rfOutputPowerAlarmState1,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        outputAttenuation1: state.outputAttenuation1,
        outputEqualizer1: state.outputEqualizer1,
        rfOutputPowerAlarmState3: state.rfOutputPowerAlarmState3,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        outputAttenuation3: state.outputAttenuation3,
        outputEqualizer3: state.outputEqualizer3,
        rfOutputPowerAlarmState4: state.rfOutputPowerAlarmState4,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        outputAttenuation4: state.outputAttenuation4,
        outputEqualizer4: state.outputEqualizer4,
        rfOutputPowerAlarmState6: state.rfOutputPowerAlarmState6,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
        outputAttenuation6: state.outputAttenuation6,
        outputEqualizer6: state.outputEqualizer6,
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
        rfOutputPowerAlarmState1: state.rfOutputPowerAlarmState1,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        outputAttenuation1: state.outputAttenuation1,
        outputEqualizer1: state.outputEqualizer1,
        rfOutputPowerAlarmState3: state.rfOutputPowerAlarmState3,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        outputAttenuation3: state.outputAttenuation3,
        outputEqualizer3: state.outputEqualizer3,
        rfOutputPowerAlarmState4: state.rfOutputPowerAlarmState4,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        outputAttenuation4: state.outputAttenuation4,
        outputEqualizer4: state.outputEqualizer4,
        rfOutputPowerAlarmState6: state.rfOutputPowerAlarmState6,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
        outputAttenuation6: state.outputAttenuation6,
        outputEqualizer6: state.outputEqualizer6,
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
        rfOutputPowerAlarmState1: state.rfOutputPowerAlarmState1,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        outputAttenuation1: state.outputAttenuation1,
        outputEqualizer1: state.outputEqualizer1,
        rfOutputPowerAlarmState3: state.rfOutputPowerAlarmState3,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        outputAttenuation3: state.outputAttenuation3,
        outputEqualizer3: state.outputEqualizer3,
        rfOutputPowerAlarmState4: state.rfOutputPowerAlarmState4,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        outputAttenuation4: state.outputAttenuation4,
        outputEqualizer4: state.outputEqualizer4,
        rfOutputPowerAlarmState6: state.rfOutputPowerAlarmState6,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
        outputAttenuation6: state.outputAttenuation6,
        outputEqualizer6: state.outputEqualizer6,
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
        rfOutputPowerAlarmState1: state.rfOutputPowerAlarmState1,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        outputAttenuation1: state.outputAttenuation1,
        outputEqualizer1: state.outputEqualizer1,
        rfOutputPowerAlarmState3: state.rfOutputPowerAlarmState3,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        outputAttenuation3: state.outputAttenuation3,
        outputEqualizer3: state.outputEqualizer3,
        rfOutputPowerAlarmState4: state.rfOutputPowerAlarmState4,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        outputAttenuation4: state.outputAttenuation4,
        outputEqualizer4: state.outputEqualizer4,
        rfOutputPowerAlarmState6: state.rfOutputPowerAlarmState6,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
        outputAttenuation6: state.outputAttenuation6,
        outputEqualizer6: state.outputEqualizer6,
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
        rfOutputPowerAlarmState1: state.rfOutputPowerAlarmState1,
        minRFOutputPower1: state.minRFOutputPower1,
        maxRFOutputPower1: state.maxRFOutputPower1,
        outputAttenuation1: state.outputAttenuation1,
        outputEqualizer1: state.outputEqualizer1,
        rfOutputPowerAlarmState3: state.rfOutputPowerAlarmState3,
        minRFOutputPower3: state.minRFOutputPower3,
        maxRFOutputPower3: state.maxRFOutputPower3,
        outputAttenuation3: state.outputAttenuation3,
        outputEqualizer3: state.outputEqualizer3,
        rfOutputPowerAlarmState4: state.rfOutputPowerAlarmState4,
        minRFOutputPower4: state.minRFOutputPower4,
        maxRFOutputPower4: state.maxRFOutputPower4,
        outputAttenuation4: state.outputAttenuation4,
        outputEqualizer4: state.outputEqualizer4,
        rfOutputPowerAlarmState6: state.rfOutputPowerAlarmState6,
        minRFOutputPower6: state.minRFOutputPower6,
        maxRFOutputPower6: state.maxRFOutputPower6,
        outputAttenuation6: state.outputAttenuation6,
        outputEqualizer6: state.outputEqualizer6,
      ),
    ));
  }

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
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: true,
      editMode: false,
      enableSubmission: false,
      temperatureAlarmState: state.initialValues[0],
      minTemperature: state.initialValues[1],
      maxTemperature: state.initialValues[2],
      temperatureUnit: _unitRepository.temperatureUnit,
      voltageAlarmState: state.initialValues[3],
      minVoltage: state.initialValues[4],
      maxVoltage: state.initialValues[5],
      splitOptionAlarmState: state.initialValues[6],
      rfOutputPowerAlarmState1: state.initialValues[7],
      minRFOutputPower1: state.initialValues[8],
      maxRFOutputPower1: state.initialValues[9],
      outputAttenuation1: state.initialValues[10],
      outputEqualizer1: state.initialValues[11],
      rfOutputPowerAlarmState3: state.initialValues[12],
      minRFOutputPower3: state.initialValues[13],
      maxRFOutputPower3: state.initialValues[14],
      outputAttenuation3: state.initialValues[15],
      outputEqualizer3: state.initialValues[16],
      rfOutputPowerAlarmState4: state.initialValues[17],
      minRFOutputPower4: state.initialValues[18],
      maxRFOutputPower4: state.initialValues[19],
      outputAttenuation4: state.initialValues[20],
      outputEqualizer4: state.initialValues[21],
      rfOutputPowerAlarmState6: state.initialValues[22],
      minRFOutputPower6: state.initialValues[23],
      maxRFOutputPower6: state.initialValues[24],
      outputAttenuation6: state.initialValues[25],
      outputEqualizer6: state.initialValues[26],
    ));
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

  bool _isEnabledSubmission({
    required bool temperatureAlarmState,
    required String minTemperature,
    required String maxTemperature,
    required bool voltageAlarmState,
    required String minVoltage,
    required String maxVoltage,
    required bool splitOptionAlarmState,
    required bool rfOutputPowerAlarmState1,
    required String minRFOutputPower1,
    required String maxRFOutputPower1,
    required String outputAttenuation1,
    required String outputEqualizer1,
    required bool rfOutputPowerAlarmState3,
    required String minRFOutputPower3,
    required String maxRFOutputPower3,
    required String outputAttenuation3,
    required String outputEqualizer3,
    required bool rfOutputPowerAlarmState4,
    required String minRFOutputPower4,
    required String maxRFOutputPower4,
    required String outputAttenuation4,
    required String outputEqualizer4,
    required bool rfOutputPowerAlarmState6,
    required String minRFOutputPower6,
    required String maxRFOutputPower6,
    required String outputAttenuation6,
    required String outputEqualizer6,
  }) {
    if (temperatureAlarmState != state.initialValues[0] ||
        minTemperature != state.initialValues[1] ||
        maxTemperature != state.initialValues[2] ||
        voltageAlarmState != state.initialValues[3] ||
        minVoltage != state.initialValues[4] ||
        maxVoltage != state.initialValues[5] ||
        splitOptionAlarmState != state.initialValues[6] ||
        rfOutputPowerAlarmState1 != state.initialValues[7] ||
        minRFOutputPower1 != state.initialValues[8] ||
        maxRFOutputPower1 != state.initialValues[9] ||
        outputAttenuation1 != state.initialValues[10] ||
        outputEqualizer1 != state.initialValues[11] ||
        rfOutputPowerAlarmState3 != state.initialValues[12] ||
        minRFOutputPower3 != state.initialValues[13] ||
        maxRFOutputPower3 != state.initialValues[14] ||
        outputAttenuation3 != state.initialValues[15] ||
        outputEqualizer3 != state.initialValues[16] ||
        rfOutputPowerAlarmState4 != state.initialValues[17] ||
        minRFOutputPower4 != state.initialValues[18] ||
        maxRFOutputPower4 != state.initialValues[19] ||
        outputAttenuation4 != state.initialValues[20] ||
        outputEqualizer4 != state.initialValues[21] ||
        rfOutputPowerAlarmState6 != state.initialValues[22] ||
        minRFOutputPower6 != state.initialValues[23] ||
        maxRFOutputPower6 != state.initialValues[24] ||
        outputAttenuation6 != state.initialValues[25] ||
        outputEqualizer6 != state.initialValues[26]) {
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

    List<String> settingResult = [];

    if (state.temperatureAlarmState != state.initialValues[0]) {
      String temperatureAlarmState =
          _boolToStringNumber(state.temperatureAlarmState);
      bool resultOfSetTemperatureAlarmState = await _dsimRepository
          .set1p8GTemperatureAlarmState(temperatureAlarmState);

      settingResult.add(
          '${DataKey.temperatureAlarmState.name},$resultOfSetTemperatureAlarmState');
    }

    if (state.minTemperature != state.initialValues[1]) {
      String minTemperature = state.minTemperature;
      if (state.temperatureUnit == TemperatureUnit.fahrenheit) {
        minTemperature = _unitRepository
            .convertStrFahrenheitToCelcius(minTemperature)
            .toStringAsFixed(1);
      }

      bool resultOfSetMinTemperature =
          await _dsimRepository.set1p8GMinTemperature(minTemperature);

      settingResult
          .add('${DataKey.minTemperatureC.name},$resultOfSetMinTemperature');
    }

    if (state.maxTemperature != state.initialValues[2]) {
      String maxTemperature = state.maxTemperature;
      if (state.temperatureUnit == TemperatureUnit.fahrenheit) {
        maxTemperature = _unitRepository
            .convertStrFahrenheitToCelcius(maxTemperature)
            .toStringAsFixed(1);
      }

      bool resultOfSetMaxTemperature =
          await _dsimRepository.set1p8GMaxTemperature(maxTemperature);

      settingResult
          .add('${DataKey.maxTemperatureC.name},$resultOfSetMaxTemperature');
    }

    if (state.voltageAlarmState != state.initialValues[3]) {
      String voltageAlarmState = _boolToStringNumber(state.voltageAlarmState);
      bool resultOfSetVoltageAlarmState =
          await _dsimRepository.set1p8GVoltageAlarmState(voltageAlarmState);

      settingResult.add(
          '${DataKey.voltageAlarmState.name},$resultOfSetVoltageAlarmState');
    }

    if (state.minVoltage != state.initialValues[4]) {
      bool resultOfSetMinVoltage =
          await _dsimRepository.set1p8GMinVoltage(state.minVoltage);

      settingResult.add('${DataKey.minVoltage.name},$resultOfSetMinVoltage');
    }

    if (state.maxVoltage != state.initialValues[5]) {
      bool resultOfSetMaxVoltage =
          await _dsimRepository.set1p8GMaxVoltage(state.maxVoltage);

      settingResult.add('${DataKey.maxVoltage.name},$resultOfSetMaxVoltage');
    }

    if (state.splitOptionAlarmState != state.initialValues[12]) {
      String splitOptionAlarmState =
          _boolToStringNumber(state.splitOptionAlarmState);
      bool resultOfSetSplitOptionAlarmState = await _dsimRepository
          .set1p8GSplitOptionAlarmState(splitOptionAlarmState);

      settingResult.add(
          '${DataKey.splitOptionAlarmState.name},$resultOfSetSplitOptionAlarmState');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      editMode: false,
    ));

    await _dsimRepository.updateCharacteristics();
  }
}

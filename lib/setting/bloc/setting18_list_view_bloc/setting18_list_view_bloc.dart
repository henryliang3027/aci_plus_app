import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_list_view_event.dart';
part 'setting18_list_view_state.dart';

class Setting18ListViewBloc
    extends Bloc<Setting18ListViewEvent, Setting18ListViewState> {
  Setting18ListViewBloc({required DsimRepository dsimRepository})
      : _dsimRepository = dsimRepository,
        super(const Setting18ListViewState()) {
    on<Initialized>(_onInitialized);
    on<SplitOptionChanged>(_onSplitOptionChanged);
    on<FirstChannelLoadingFrequencyChanged>(
        _onFirstChannelLoadingFrequencyChanged);
    on<FirstChannelLoadingLevelChanged>(_onFirstChannelLoadingLevelChanged);
    on<LastChannelLoadingFrequencyChanged>(
        _onLastChannelLoadingFrequencyChanged);
    on<LastChannelLoadingLevelChanged>(_onLastChannelLoadingLevelChanged);
    on<PilotFrequencyModeChanged>(_onPilotFrequencyModeChanged);
    on<PilotFrequency1Changed>(_onPilotFrequency1Changed);
    on<PilotFrequency2Changed>(_onPilotFrequency2Changed);
    on<FwdAGCModeChanged>(_onFwdAGCModeChanged);
    on<AutoLevelControlChanged>(_onAutoLevelControlChanged);
    on<TemperatureAlarmChanged>(_onTemperatureAlarmChanged);
    on<MinTemperatureChanged>(_onMinTemperatureChanged);
    on<MaxTemperatureChanged>(_onMaxTemperatureChanged);
    on<VoltageAlarmChanged>(_onVoltageAlarmChanged);
    on<MinVoltageChanged>(_onMinVoltageChanged);
    on<MaxVoltageChanged>(_onMaxVoltageChanged);
    on<RFInputPowerAlarmChanged>(_onRFInputPowerAlarmChanged);
    on<RFOutputPowerAlarmChanged>(_onRFOutputPowerAlarmChanged);
    on<PilotFrequency1AlarmChanged>(_onPilotFrequency1AlarmChanged);
    on<PilotFrequency2AlarmChanged>(_onPilotFrequency2AlarmChanged);
    on<FirstChannelOutputLevelAlarmChanged>(
        _onFirstChannelOutputLevelAlarmChanged);
    on<LastChannelOutputLevelAlarmChanged>(
        _onLastChannelOutputLevelAlarmChanged);
    on<FwdInputAttenuationChanged>(_onFwdInputAttenuationChanged);
    on<FwdInputEQChanged>(_onFwdInputEQChanged);
    on<RtnInputAttenuation2Changed>(_onRtnInputAttenuation2Changed);
    on<RtnInputAttenuation3Changed>(_onRtnInputAttenuation3Changed);
    on<RtnInputAttenuation4Changed>(_onRtnInputAttenuation4Changed);
    on<RtnOutputLevelAttenuationChanged>(_onRtnOutputLevelAttenuationChanged);
    on<RtnOutputEQChanged>(_onRtnOutputEQChanged);
    on<RtnIngressSetting2Changed>(_onRtnIngressSetting2Changed);
    on<RtnIngressSetting3Changed>(_onRtnIngressSetting3Changed);
    on<RtnIngressSetting4Changed>(_onRtnIngressSetting4Changed);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final DsimRepository _dsimRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18ListViewState> emit,
  ) async {}

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      splitOption: event.splitOption,
    ));
  }

  void _onFirstChannelLoadingFrequencyChanged(
    FirstChannelLoadingFrequencyChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      firstChannelLoadingFrequency: event.firstChannelLoadingFrequency,
    ));
  }

  void _onFirstChannelLoadingLevelChanged(
    FirstChannelLoadingLevelChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      firstChannelLoadingLevel: event.firstChannelLoadingLevel,
    ));
  }

  void _onLastChannelLoadingFrequencyChanged(
    LastChannelLoadingFrequencyChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      lastChannelLoadingFrequency: event.lastChannelLoadingFrequency,
    ));
  }

  void _onLastChannelLoadingLevelChanged(
    LastChannelLoadingLevelChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      lastChannelLoadingLevel: event.lastChannelLoadingLevel,
    ));
  }

  void _onPilotFrequencyModeChanged(
    PilotFrequencyModeChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      pilotFrequencyMode: event.pilotFrequencyMode,
    ));
  }

  void _onPilotFrequency1Changed(
    PilotFrequency1Changed event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      pilotFrequency1: event.pilotFrequency1,
    ));
  }

  void _onPilotFrequency2Changed(
    PilotFrequency2Changed event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      pilotFrequency2: event.pilotFrequency2,
    ));
  }

  void _onFwdAGCModeChanged(
    FwdAGCModeChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      fwdAGCMode: event.fwdAGCMode,
    ));
  }

  void _onAutoLevelControlChanged(
    AutoLevelControlChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      autoLevelControl: event.autoLevelControl,
    ));
  }

  void _onTemperatureAlarmChanged(
    TemperatureAlarmChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      enableTemperatureAlarm: event.enableTemperatureAlarm,
    ));
  }

  void _onMinTemperatureChanged(
    MinTemperatureChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      minTemperature: event.minTemperature,
    ));
  }

  void _onMaxTemperatureChanged(
    MaxTemperatureChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      maxTemperature: event.maxTemperature,
    ));
  }

  void _onVoltageAlarmChanged(
    VoltageAlarmChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      enableVoltageAlarm: event.enableVoltageAlarm,
    ));
  }

  void _onMinVoltageChanged(
    MinVoltageChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      minVoltage: event.minVoltage,
    ));
  }

  void _onMaxVoltageChanged(
    MaxVoltageChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      maxVoltage: event.maxVoltage,
    ));
  }

  void _onRFInputPowerAlarmChanged(
    RFInputPowerAlarmChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      enableRFInputPowerAlarm: event.enableRFInputPowerAlarm,
    ));
  }

  void _onRFOutputPowerAlarmChanged(
    RFOutputPowerAlarmChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      enableRFOutputPowerAlarm: event.enableRFOutputPowerAlarm,
    ));
  }

  void _onPilotFrequency1AlarmChanged(
    PilotFrequency1AlarmChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      enablePilotFrequency1Alarm: event.enablePilotFrequency1Alarm,
    ));
  }

  void _onPilotFrequency2AlarmChanged(
    PilotFrequency2AlarmChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      enablePilotFrequency2Alarm: event.enablePilotFrequency2Alarm,
    ));
  }

  void _onFirstChannelOutputLevelAlarmChanged(
    FirstChannelOutputLevelAlarmChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      enableFirstChannelOutputLevelAlarm:
          event.enableFirstChannelOutputLevelAlarm,
    ));
  }

  void _onLastChannelOutputLevelAlarmChanged(
    LastChannelOutputLevelAlarmChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      enableLastChannelOutputLevelAlarm:
          event.enableLastChannelOutputLevelAlarm,
    ));
  }

  void _onFwdInputAttenuationChanged(
    FwdInputAttenuationChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      fwdInputAttenuation: event.fwdInputAttenuation,
    ));
  }

  void _onFwdInputEQChanged(
    FwdInputEQChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      fwdInputEQ: event.fwdInputEQ,
    ));
  }

  void _onRtnInputAttenuation2Changed(
    RtnInputAttenuation2Changed event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      rtnInputAttenuation2: event.rtnInputAttenuation2,
    ));
  }

  void _onRtnInputAttenuation3Changed(
    RtnInputAttenuation3Changed event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      rtnInputAttenuation3: event.rtnInputAttenuation3,
    ));
  }

  void _onRtnInputAttenuation4Changed(
    RtnInputAttenuation4Changed event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      rtnInputAttenuation4: event.rtnInputAttenuation4,
    ));
  }

  void _onRtnOutputLevelAttenuationChanged(
    RtnOutputLevelAttenuationChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      rtnOutputLevelAttenuation: event.rtnOutputLevelAttenuation,
    ));
  }

  void _onRtnOutputEQChanged(
    RtnOutputEQChanged event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      rtnOutputEQ: event.rtnOutputEQ,
    ));
  }

  void _onRtnIngressSetting2Changed(
    RtnIngressSetting2Changed event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      rtnIngressSetting2: event.rtnIngressSetting2,
    ));
  }

  void _onRtnIngressSetting3Changed(
    RtnIngressSetting3Changed event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      rtnIngressSetting3: event.rtnIngressSetting3,
    ));
  }

  void _onRtnIngressSetting4Changed(
    RtnIngressSetting4Changed event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      rtnIngressSetting4: event.rtnIngressSetting4,
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18ListViewState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: false,
      enableSubmission: false,
    ));
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18ListViewState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));
  }
}

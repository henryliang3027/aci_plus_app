import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_configure_event.dart';
part 'setting18_configure_state.dart';

class Setting18ConfigureBloc
    extends Bloc<Setting18ConfigureEvent, Setting18ConfigureState> {
  Setting18ConfigureBloc({required DsimRepository dsimRepository})
      : _dsimRepository = dsimRepository,
        super(const Setting18ConfigureState()) {
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
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final DsimRepository _dsimRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18ConfigureState> emit,
  ) async {}

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      splitOption: event.splitOption,
    ));
  }

  void _onFirstChannelLoadingFrequencyChanged(
    FirstChannelLoadingFrequencyChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      firstChannelLoadingFrequency: event.firstChannelLoadingFrequency,
    ));
  }

  void _onFirstChannelLoadingLevelChanged(
    FirstChannelLoadingLevelChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      firstChannelLoadingLevel: event.firstChannelLoadingLevel,
    ));
  }

  void _onLastChannelLoadingFrequencyChanged(
    LastChannelLoadingFrequencyChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      lastChannelLoadingFrequency: event.lastChannelLoadingFrequency,
    ));
  }

  void _onLastChannelLoadingLevelChanged(
    LastChannelLoadingLevelChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      lastChannelLoadingLevel: event.lastChannelLoadingLevel,
    ));
  }

  void _onPilotFrequencyModeChanged(
    PilotFrequencyModeChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      pilotFrequencyMode: event.pilotFrequencyMode,
    ));
  }

  void _onPilotFrequency1Changed(
    PilotFrequency1Changed event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      pilotFrequency1: event.pilotFrequency1,
    ));
  }

  void _onPilotFrequency2Changed(
    PilotFrequency2Changed event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      pilotFrequency2: event.pilotFrequency2,
    ));
  }

  void _onFwdAGCModeChanged(
    FwdAGCModeChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      fwdAGCMode: event.fwdAGCMode,
    ));
  }

  void _onAutoLevelControlChanged(
    AutoLevelControlChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      autoLevelControl: event.autoLevelControl,
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18ConfigureState> emit,
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
    Emitter<Setting18ConfigureState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));
  }
}

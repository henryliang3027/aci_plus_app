import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/setting/bloc/setting_list_view_bloc/setting_list_view_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_control_event.dart';
part 'setting18_control_state.dart';

class Setting18ControlBloc
    extends Bloc<Setting18ControlEvent, Setting18ControlState> {
  Setting18ControlBloc({required DsimRepository dsimRepository})
      : _dsimRepository = dsimRepository,
        super(const Setting18ControlState()) {
    on<Initialized>(_onInitialized);
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

  void _onInitialized(
    Initialized event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
        fwdInputAttenuation: event.fwdInputAttenuation,
        fwdInputEQ: event.fwdInputEQ,
        rtnInputAttenuation2: event.rtnInputAttenuation2,
        rtnInputAttenuation3: event.rtnInputAttenuation3,
        rtnInputAttenuation4: event.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: event.rtnOutputLevelAttenuation,
        rtnOutputEQ: event.rtnOutputEQ,
        rtnIngressSetting2: event.rtnIngressSetting2,
        rtnIngressSetting3: event.rtnIngressSetting3,
        rtnIngressSetting4: event.rtnIngressSetting4,
        isInitialize: true,
        initialValues: [
          event.fwdInputAttenuation,
          event.fwdInputEQ,
          event.rtnInputAttenuation2,
          event.rtnInputAttenuation3,
          event.rtnInputAttenuation4,
          event.rtnOutputLevelAttenuation,
          event.rtnOutputEQ,
          event.rtnIngressSetting2,
          event.rtnIngressSetting3,
          event.rtnIngressSetting4,
        ]));
  }

  void _onFwdInputAttenuationChanged(
    FwdInputAttenuationChanged event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      fwdInputAttenuation: event.fwdInputAttenuation,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: event.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
      ),
    ));
  }

  void _onFwdInputEQChanged(
    FwdInputEQChanged event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      fwdInputEQ: event.fwdInputEQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: event.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
      ),
    ));
  }

  void _onRtnInputAttenuation2Changed(
    RtnInputAttenuation2Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation2: event.rtnInputAttenuation2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: event.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
      ),
    ));
  }

  void _onRtnInputAttenuation3Changed(
    RtnInputAttenuation3Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation3: event.rtnInputAttenuation3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: event.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
      ),
    ));
  }

  void _onRtnInputAttenuation4Changed(
    RtnInputAttenuation4Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation4: event.rtnInputAttenuation4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: event.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
      ),
    ));
  }

  void _onRtnOutputLevelAttenuationChanged(
    RtnOutputLevelAttenuationChanged event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputLevelAttenuation: event.rtnOutputLevelAttenuation,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: event.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
      ),
    ));
  }

  void _onRtnOutputEQChanged(
    RtnOutputEQChanged event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputEQ: event.rtnOutputEQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: event.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
      ),
    ));
  }

  void _onRtnIngressSetting2Changed(
    RtnIngressSetting2Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnIngressSetting2: event.rtnIngressSetting2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: event.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
      ),
    ));
  }

  void _onRtnIngressSetting3Changed(
    RtnIngressSetting3Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnIngressSetting3: event.rtnIngressSetting3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: event.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
      ),
    ));
  }

  void _onRtnIngressSetting4Changed(
    RtnIngressSetting4Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnIngressSetting4: event.rtnIngressSetting4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: event.rtnIngressSetting4,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: false,
      enableSubmission: false,
      fwdInputAttenuation: state.initialValues[0],
      fwdInputEQ: state.initialValues[1],
      rtnInputAttenuation2: state.initialValues[2],
      rtnInputAttenuation3: state.initialValues[3],
      rtnInputAttenuation4: state.initialValues[4],
      rtnOutputLevelAttenuation: state.initialValues[5],
      rtnOutputEQ: state.initialValues[6],
      rtnIngressSetting2: state.initialValues[7],
      rtnIngressSetting3: state.initialValues[8],
      rtnIngressSetting4: state.initialValues[9],
    ));
  }

  bool _isEnabledSubmission({
    required String fwdInputAttenuation,
    required String fwdInputEQ,
    required String rtnInputAttenuation2,
    required String rtnInputAttenuation3,
    required String rtnInputAttenuation4,
    required String rtnOutputLevelAttenuation,
    required String rtnOutputEQ,
    required String rtnIngressSetting2,
    required String rtnIngressSetting3,
    required String rtnIngressSetting4,
  }) {
    if (fwdInputAttenuation != state.initialValues[0] ||
        fwdInputEQ != state.initialValues[1] ||
        rtnInputAttenuation2 != state.initialValues[2] ||
        rtnInputAttenuation3 != state.initialValues[3] ||
        rtnInputAttenuation4 != state.initialValues[4] ||
        rtnOutputLevelAttenuation != state.initialValues[5] ||
        rtnOutputEQ != state.initialValues[6] ||
        rtnIngressSetting2 != state.initialValues[7] ||
        rtnIngressSetting3 != state.initialValues[8] ||
        rtnIngressSetting4 != state.initialValues[9]) {
      return true;
    } else {
      return false;
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18ControlState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];

    if (state.fwdInputAttenuation != state.initialValues[0]) {
      bool resultOfSetForwardInputAttenuation = await _dsimRepository
          .set1p8GForwardInputAttenuation(state.fwdInputAttenuation);

      settingResult.add(
          '${DataKey.inputAttenuation.name},$resultOfSetForwardInputAttenuation');
    }

    if (state.fwdInputEQ != state.initialValues[1]) {
      bool resultOfSetForwardInputEqualizer =
          await _dsimRepository.set1p8GForwardInputEqualizer(state.fwdInputEQ);

      settingResult.add(
          '${DataKey.inputEqualizer.name},$resultOfSetForwardInputEqualizer');
    }

    if (state.rtnInputAttenuation2 != state.initialValues[2]) {
      bool resultOfSetReturnInputAttenuation2 = await _dsimRepository
          .set1p8GReturnInputAttenuation2(state.rtnInputAttenuation2);

      settingResult.add(
          '${DataKey.inputAttenuation2.name},$resultOfSetReturnInputAttenuation2');
    }

    if (state.rtnInputAttenuation3 != state.initialValues[3]) {
      bool resultOfSetReturnInputAttenuation3 = await _dsimRepository
          .set1p8GReturnInputAttenuation3(state.rtnInputAttenuation3);

      settingResult.add(
          '${DataKey.inputAttenuation3.name},$resultOfSetReturnInputAttenuation3');
    }

    if (state.rtnInputAttenuation4 != state.initialValues[4]) {
      bool resultOfSetReturnInputAttenuation4 = await _dsimRepository
          .set1p8GReturnInputAttenuation4(state.rtnInputAttenuation4);

      settingResult.add(
          '${DataKey.inputAttenuation4.name},$resultOfSetReturnInputAttenuation4');
    }

    if (state.rtnOutputLevelAttenuation != state.initialValues[5]) {
      bool resultOfSetReturnOutputAttenuation = await _dsimRepository
          .set1p8GReturnOutputAttenuation(state.rtnOutputLevelAttenuation);

      settingResult.add(
          '${DataKey.outputAttenuation.name},$resultOfSetReturnOutputAttenuation');
    }

    if (state.rtnOutputEQ != state.initialValues[6]) {
      bool resultOfSetReturnOutputEqualizer =
          await _dsimRepository.set1p8GReturnOutputEqualizer(state.rtnOutputEQ);

      settingResult.add(
          '${DataKey.outputEqualizer.name},$resultOfSetReturnOutputEqualizer');
    }

    if (state.rtnIngressSetting2 != state.initialValues[7]) {
      bool resultOfSetReturnIngress2 =
          await _dsimRepository.set1p8GReturnIngress2(state.rtnIngressSetting2);

      settingResult
          .add('${DataKey.ingressSetting2.name},$resultOfSetReturnIngress2');
    }

    if (state.rtnIngressSetting3 != state.initialValues[8]) {
      bool resultOfSetReturnIngress3 =
          await _dsimRepository.set1p8GReturnIngress3(state.rtnIngressSetting3);

      settingResult
          .add('${DataKey.ingressSetting3.name},$resultOfSetReturnIngress3');
    }

    if (state.rtnIngressSetting4 != state.initialValues[9]) {
      bool resultOfSetReturnIngress4 =
          await _dsimRepository.set1p8GReturnIngress4(state.rtnIngressSetting4);

      settingResult
          .add('${DataKey.ingressSetting4.name},$resultOfSetReturnIngress4');
    }

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      editMode: false,
    ));

    await _dsimRepository.updateCharacteristics();
  }
}

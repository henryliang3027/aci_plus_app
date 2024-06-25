import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_reverse_control_event.dart';
part 'setting18_reverse_control_state.dart';

class Setting18ReverseControlBloc
    extends Bloc<Setting18ReverseControlEvent, Setting18ReverseControlState> {
  Setting18ReverseControlBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const Setting18ReverseControlState()) {
    on<Initialized>(_onInitialized);
    on<ResetReverseValuesRequested>(_onResetReverseValuesRequested);
    on<USVCA1Changed>(_onUSVCA1Changed);
    on<USVCA2Changed>(_onUSVCA2Changed);
    on<USVCA3Changed>(_onUSVCA3Changed);
    on<USVCA4Changed>(_onUSVCA4Changed);
    on<EREQChanged>(_onEREQChanged);
    on<RtnIngressSetting2Changed>(_onRtnIngressSetting2Changed);
    on<RtnIngressSetting3Changed>(_onRtnIngressSetting3Changed);
    on<RtnIngressSetting4Changed>(_onRtnIngressSetting4Changed);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final Amp18Repository _amp18Repository;

  void _onInitialized(
    Initialized event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String usVCA1 = characteristicDataCache[DataKey.usVCA1] ?? '';
    String usVCA2 = characteristicDataCache[DataKey.usVCA2] ?? '';
    String usVCA3 = characteristicDataCache[DataKey.usVCA3] ?? '';
    String usVCA4 = characteristicDataCache[DataKey.usVCA4] ?? '';

    String eREQ = characteristicDataCache[DataKey.eREQ] ?? '';
    String ingressSetting2 =
        characteristicDataCache[DataKey.ingressSetting2] ?? '';
    String ingressSetting3 =
        characteristicDataCache[DataKey.ingressSetting3] ?? '';
    String ingressSetting4 =
        characteristicDataCache[DataKey.ingressSetting4] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      usVCA2: usVCA2,
      usVCA3: usVCA3,
      usVCA4: usVCA4,
      eREQ: eREQ,
      returnIngressSetting2: ingressSetting2,
      returnIngressSetting3: ingressSetting3,
      returnIngressSetting4: ingressSetting4,
      initialValues: characteristicDataCache,
    ));
  }

  void _onResetReverseValuesRequested(
    ResetReverseValuesRequested event,
    Emitter<Setting18ReverseControlState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.submissionInProgress,
    ));

    bool result =
        await _amp18Repository.set1p8GFactoryDefault(34); // load upstream only

    if (result) {
      // 等待 device 完成更新後在讀取值
      await Future.delayed(const Duration(milliseconds: 1000));
      await _amp18Repository.updateCharacteristics();

      emit(state.copyWith(
        resetReverseValuesSubmissionStatus: SubmissionStatus.submissionSuccess,
        editMode: false,
      ));
    } else {
      emit(state.copyWith(
        resetReverseValuesSubmissionStatus: SubmissionStatus.submissionFailure,
        editMode: false,
      ));
    }
  }

  void _onUSVCA1Changed(
    USVCA1Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA1: event.usVCA1,
      enableSubmission: _isEnabledSubmission(
        usVCA1: event.usVCA1,
      ),
    ));
  }

  void _onUSVCA2Changed(
    USVCA2Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA2: event.usVCA2,
      enableSubmission: _isEnabledSubmission(
        usVCA2: event.usVCA2,
      ),
    ));
  }

  void _onUSVCA3Changed(
    USVCA3Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA3: event.usVCA3,
      enableSubmission: _isEnabledSubmission(
        usVCA3: event.usVCA3,
      ),
    ));
  }

  void _onUSVCA4Changed(
    USVCA4Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA4: event.usVCA4,
      enableSubmission: _isEnabledSubmission(
        usVCA4: event.usVCA4,
      ),
    ));
  }

  void _onEREQChanged(
    EREQChanged event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      eREQ: event.eREQ,
      enableSubmission: _isEnabledSubmission(
        eREQ: event.eREQ,
      ),
    ));
  }

  void _onRtnIngressSetting2Changed(
    RtnIngressSetting2Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      returnIngressSetting2: event.returnIngressSetting2,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting2: event.returnIngressSetting2,
      ),
    ));
  }

  void _onRtnIngressSetting3Changed(
    RtnIngressSetting3Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      returnIngressSetting3: event.returnIngressSetting3,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting3: event.returnIngressSetting3,
      ),
    ));
  }

  void _onRtnIngressSetting4Changed(
    RtnIngressSetting4Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      returnIngressSetting4: event.returnIngressSetting4,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting4: event.returnIngressSetting4,
      ),
    ));
  }

  bool _isEnabledSubmission({
    String? usVCA1,
    String? usVCA2,
    String? usVCA3,
    String? usVCA4,
    String? eREQ,
    String? returnIngressSetting2,
    String? returnIngressSetting3,
    String? returnIngressSetting4,
  }) {
    usVCA1 ??= state.usVCA1;
    usVCA2 ??= state.usVCA2;
    usVCA3 ??= state.usVCA3;
    usVCA4 ??= state.usVCA4;
    eREQ ??= state.eREQ;
    returnIngressSetting2 ??= state.returnIngressSetting2;
    returnIngressSetting3 ??= state.returnIngressSetting3;
    returnIngressSetting4 ??= state.returnIngressSetting4;

    if (usVCA1.isEmpty ||
        usVCA2.isEmpty ||
        usVCA3.isEmpty ||
        usVCA4.isEmpty ||
        eREQ.isEmpty ||
        usVCA3.isEmpty ||
        usVCA3.isEmpty) {
      return false;
    } else {
      if (usVCA1 != state.initialValues[DataKey.usVCA1] ||
          usVCA2 != state.initialValues[DataKey.usVCA2] ||
          usVCA3 != state.initialValues[DataKey.usVCA3] ||
          usVCA4 != state.initialValues[DataKey.usVCA4] ||
          eREQ != state.initialValues[DataKey.eREQ] ||
          returnIngressSetting2 !=
              state.initialValues[DataKey.ingressSetting2] ||
          returnIngressSetting3 !=
              state.initialValues[DataKey.ingressSetting3] ||
          returnIngressSetting4 !=
              state.initialValues[DataKey.ingressSetting4]) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      editMode: false,
      enableSubmission: false,
      usVCA1: state.initialValues[DataKey.usVCA1],
      usVCA2: state.initialValues[DataKey.usVCA2],
      usVCA3: state.initialValues[DataKey.usVCA3],
      usVCA4: state.initialValues[DataKey.usVCA4],
      eREQ: state.initialValues[DataKey.eREQ],
      returnIngressSetting2: state.initialValues[DataKey.ingressSetting2],
      returnIngressSetting3: state.initialValues[DataKey.ingressSetting3],
      returnIngressSetting4: state.initialValues[DataKey.ingressSetting4],
    ));
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18ReverseControlState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];

    if (state.usVCA1 != state.initialValues[DataKey.usVCA1]) {
      bool resultOfSetUSVCA1Cmd =
          await _amp18Repository.set1p8GUSVCA1(state.usVCA1);

      settingResult.add('${DataKey.usVCA1.name},$resultOfSetUSVCA1Cmd');
    }

    if (state.usVCA2 != state.initialValues[DataKey.usVCA2]) {
      bool resultOfSetUSVCA2 =
          await _amp18Repository.set1p8GUSVCA2(state.usVCA2);

      settingResult.add('${DataKey.usVCA2.name},$resultOfSetUSVCA2');
    }

    if (state.usVCA3 != state.initialValues[DataKey.usVCA3]) {
      bool resultOfSetUSVCA3 =
          await _amp18Repository.set1p8GUSVCA3(state.usVCA3);

      settingResult.add('${DataKey.usVCA3.name},$resultOfSetUSVCA3');
    }

    if (state.usVCA4 != state.initialValues[DataKey.usVCA4]) {
      bool resultOfSetUSVCA4 =
          await _amp18Repository.set1p8GUSVCA4(state.usVCA4);

      settingResult.add('${DataKey.usVCA4.name},$resultOfSetUSVCA4');
    }

    if (state.eREQ != state.initialValues[DataKey.eREQ]) {
      bool resultOfSetEREQ = await _amp18Repository.set1p8GEREQ(state.eREQ);

      settingResult.add('${DataKey.eREQ.name},$resultOfSetEREQ');
    }

    if (state.returnIngressSetting2 !=
        state.initialValues[DataKey.ingressSetting2]) {
      bool resultOfSetReturnIngress2 = await _amp18Repository
          .set1p8GReturnIngress2(state.returnIngressSetting2);

      settingResult
          .add('${DataKey.ingressSetting2.name},$resultOfSetReturnIngress2');
    }

    if (state.returnIngressSetting3 !=
        state.initialValues[DataKey.ingressSetting3]) {
      bool resultOfSetReturnIngress3 = await _amp18Repository
          .set1p8GReturnIngress3(state.returnIngressSetting3);

      settingResult
          .add('${DataKey.ingressSetting3.name},$resultOfSetReturnIngress3');
    }

    if (state.returnIngressSetting4 !=
        state.initialValues[DataKey.ingressSetting4]) {
      bool resultOfSetReturnIngress4 = await _amp18Repository
          .set1p8GReturnIngress4(state.returnIngressSetting4);

      settingResult
          .add('${DataKey.ingressSetting4.name},$resultOfSetReturnIngress4');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      editMode: false,
    ));
  }
}

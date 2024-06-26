import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_forward_control_event.dart';
part 'setting18_ccor_node_forward_control_state.dart';

class Setting18CCorNodeForwardControlBloc extends Bloc<
    Setting18CCorNodeForwardControlEvent,
    Setting18CCorNodeForwardControlState> {
  Setting18CCorNodeForwardControlBloc({
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(const Setting18CCorNodeForwardControlState()) {
    on<Initialized>(_onInitialized);
    on<DSVVA1Changed>(_onDSVVA1Changed);
    on<DSVVA3Changed>(_onDSVVA3Changed);
    on<DSVVA4Changed>(_onDSVVA4Changed);
    on<DSVVA6Changed>(_onDSVVA6Changed);
    on<DSInSlope1Changed>(_onDSInSlope1Changed);
    on<DSInSlope3Changed>(_onDSInSlope3Changed);
    on<DSInSlope4Changed>(_onDSInSlope4Changed);
    on<DSInSlope6Changed>(_onDSInSlope6Changed);
    on<DSOutSlope1Changed>(_onDSOutSlope1Changed);
    on<DSOutSlope3Changed>(_onDSOutSlope3Changed);
    on<DSOutSlope4Changed>(_onDSOutSlope4Changed);
    on<DSOutSlope6Changed>(_onDSOutSlope6Changed);
    on<BiasCurrent1Changed>(_onBiasCurrent1Changed);
    on<BiasCurrent3Changed>(_onBiasCurrent3Changed);
    on<BiasCurrent4Changed>(_onBiasCurrent4Changed);
    on<BiasCurrent6Changed>(_onBiasCurrent6Changed);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18CCorNodeRepository.characteristicDataCache;

    String dsVVA1 = characteristicDataCache[DataKey.dsVVA1] ?? '';
    String dsVVA3 = characteristicDataCache[DataKey.dsVVA3] ?? '';
    String dsVVA4 = characteristicDataCache[DataKey.dsVVA4] ?? '';
    String dsVVA6 = characteristicDataCache[DataKey.dsVVA6] ?? '';
    String dsInSlope1 = characteristicDataCache[DataKey.dsInSlope1] ?? '';
    String dsInSlope3 = characteristicDataCache[DataKey.dsInSlope3] ?? '';
    String dsInSlope4 = characteristicDataCache[DataKey.dsInSlope4] ?? '';
    String dsInSlope6 = characteristicDataCache[DataKey.dsInSlope6] ?? '';
    String dsOutSlope1 = characteristicDataCache[DataKey.dsOutSlope1] ?? '';
    String dsOutSlope3 = characteristicDataCache[DataKey.dsOutSlope3] ?? '';
    String dsOutSlope4 = characteristicDataCache[DataKey.dsOutSlope4] ?? '';
    String dsOutSlope6 = characteristicDataCache[DataKey.dsOutSlope6] ?? '';
    String biasCurrent1 = characteristicDataCache[DataKey.biasCurrent1] ?? '';
    String biasCurrent3 = characteristicDataCache[DataKey.biasCurrent3] ?? '';
    String biasCurrent4 = characteristicDataCache[DataKey.biasCurrent4] ?? '';
    String biasCurrent6 = characteristicDataCache[DataKey.biasCurrent6] ?? '';

    emit(state.copyWith(
      dsVVA1: dsVVA1,
      dsVVA3: dsVVA3,
      dsVVA4: dsVVA4,
      dsVVA6: dsVVA6,
      dsInSlope1: dsInSlope1,
      dsInSlope3: dsInSlope3,
      dsInSlope4: dsInSlope4,
      dsInSlope6: dsInSlope6,
      dsOutSlope1: dsOutSlope1,
      dsOutSlope3: dsOutSlope3,
      dsOutSlope4: dsOutSlope4,
      dsOutSlope6: dsOutSlope6,
      biasCurrent1: biasCurrent1,
      biasCurrent3: biasCurrent3,
      biasCurrent4: biasCurrent4,
      biasCurrent6: biasCurrent6,
      initialValues: characteristicDataCache,
    ));
  }

  void _onDSVVA1Changed(
    DSVVA1Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: event.dsVVA1,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: event.dsVVA1,
      ),
    ));
  }

  void _onDSVVA3Changed(
    DSVVA3Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA3: event.dsVVA3,
      enableSubmission: _isEnabledSubmission(
        dsVVA3: event.dsVVA3,
      ),
    ));
  }

  void _onDSVVA4Changed(
    DSVVA4Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA4: event.dsVVA4,
      enableSubmission: _isEnabledSubmission(
        dsVVA4: event.dsVVA4,
      ),
    ));
  }

  void _onDSVVA6Changed(
    DSVVA6Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA6: event.dsVVA6,
      enableSubmission: _isEnabledSubmission(
        dsVVA6: event.dsVVA6,
      ),
    ));
  }

  void _onDSInSlope1Changed(
    DSInSlope1Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope1: event.dsInSlope1,
      enableSubmission: _isEnabledSubmission(
        dsInSlope1: event.dsInSlope1,
      ),
    ));
  }

  void _onDSInSlope3Changed(
    DSInSlope3Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope3: event.dsInSlope3,
      enableSubmission: _isEnabledSubmission(
        dsInSlope3: event.dsInSlope3,
      ),
    ));
  }

  void _onDSInSlope4Changed(
    DSInSlope4Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope4: event.dsInSlope4,
      enableSubmission: _isEnabledSubmission(
        dsInSlope4: event.dsInSlope4,
      ),
    ));
  }

  void _onDSInSlope6Changed(
    DSInSlope6Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope6: event.dsInSlope6,
      enableSubmission: _isEnabledSubmission(
        dsInSlope6: event.dsInSlope6,
      ),
    ));
  }

  void _onDSOutSlope1Changed(
    DSOutSlope1Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsOutSlope1: event.dsOutSlope1,
      enableSubmission: _isEnabledSubmission(
        dsOutSlope1: event.dsOutSlope1,
      ),
    ));
  }

  void _onDSOutSlope3Changed(
    DSOutSlope3Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsOutSlope3: event.dsOutSlope3,
      enableSubmission: _isEnabledSubmission(
        dsOutSlope3: event.dsOutSlope3,
      ),
    ));
  }

  void _onDSOutSlope4Changed(
    DSOutSlope4Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsOutSlope4: event.dsOutSlope4,
      enableSubmission: _isEnabledSubmission(
        dsOutSlope4: event.dsOutSlope4,
      ),
    ));
  }

  void _onDSOutSlope6Changed(
    DSOutSlope6Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsOutSlope6: event.dsOutSlope6,
      enableSubmission: _isEnabledSubmission(
        dsOutSlope6: event.dsOutSlope6,
      ),
    ));
  }

  void _onBiasCurrent1Changed(
    BiasCurrent1Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      biasCurrent1: event.biasCurrent1,
      enableSubmission: _isEnabledSubmission(
        biasCurrent1: event.biasCurrent1,
      ),
    ));
  }

  void _onBiasCurrent3Changed(
    BiasCurrent3Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      biasCurrent3: event.biasCurrent3,
      enableSubmission: _isEnabledSubmission(
        biasCurrent3: event.biasCurrent3,
      ),
    ));
  }

  void _onBiasCurrent4Changed(
    BiasCurrent4Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      biasCurrent4: event.biasCurrent4,
      enableSubmission: _isEnabledSubmission(
        biasCurrent4: event.biasCurrent4,
      ),
    ));
  }

  void _onBiasCurrent6Changed(
    BiasCurrent6Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      biasCurrent6: event.biasCurrent6,
      enableSubmission: _isEnabledSubmission(
        biasCurrent6: event.biasCurrent6,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      editMode: false,
      enableSubmission: false,
      dsVVA1: state.initialValues[DataKey.dsVVA1],
      dsVVA3: state.initialValues[DataKey.dsVVA3],
      dsVVA4: state.initialValues[DataKey.dsVVA4],
      dsVVA6: state.initialValues[DataKey.dsVVA6],
      dsInSlope1: state.initialValues[DataKey.dsInSlope1],
      dsInSlope3: state.initialValues[DataKey.dsInSlope3],
      dsInSlope4: state.initialValues[DataKey.dsInSlope4],
      dsInSlope6: state.initialValues[DataKey.dsInSlope6],
      dsOutSlope1: state.initialValues[DataKey.dsOutSlope1],
      dsOutSlope3: state.initialValues[DataKey.dsOutSlope3],
      dsOutSlope4: state.initialValues[DataKey.dsOutSlope4],
      dsOutSlope6: state.initialValues[DataKey.dsOutSlope6],
      biasCurrent1: state.initialValues[DataKey.biasCurrent1],
      biasCurrent3: state.initialValues[DataKey.biasCurrent3],
      biasCurrent4: state.initialValues[DataKey.biasCurrent4],
      biasCurrent6: state.initialValues[DataKey.biasCurrent6],
    ));
  }

  bool _isEnabledSubmission({
    String? dsVVA1,
    String? dsVVA3,
    String? dsVVA4,
    String? dsVVA6,
    String? dsInSlope1,
    String? dsInSlope3,
    String? dsInSlope4,
    String? dsInSlope6,
    String? dsOutSlope1,
    String? dsOutSlope3,
    String? dsOutSlope4,
    String? dsOutSlope6,
    String? biasCurrent1,
    String? biasCurrent3,
    String? biasCurrent4,
    String? biasCurrent6,
  }) {
    dsVVA1 ??= state.dsVVA1;
    dsVVA3 ??= state.dsVVA3;
    dsVVA4 ??= state.dsVVA4;
    dsVVA6 ??= state.dsVVA6;
    dsInSlope1 ??= state.dsInSlope1;
    dsInSlope3 ??= state.dsInSlope3;
    dsInSlope4 ??= state.dsInSlope4;
    dsInSlope6 ??= state.dsInSlope6;
    dsOutSlope1 ??= state.dsOutSlope1;
    dsOutSlope3 ??= state.dsOutSlope3;
    dsOutSlope4 ??= state.dsOutSlope4;
    dsOutSlope6 ??= state.dsOutSlope6;
    biasCurrent1 ??= state.biasCurrent1;
    biasCurrent3 ??= state.biasCurrent3;
    biasCurrent4 ??= state.biasCurrent4;
    biasCurrent6 ??= state.biasCurrent6;

    if (dsVVA1.isEmpty ||
        dsVVA3.isEmpty ||
        dsVVA4.isEmpty ||
        dsVVA6.isEmpty ||
        dsInSlope1.isEmpty ||
        dsInSlope3.isEmpty ||
        dsInSlope4.isEmpty ||
        dsInSlope6.isEmpty ||
        dsOutSlope1.isEmpty ||
        dsOutSlope3.isEmpty ||
        dsOutSlope4.isEmpty ||
        dsOutSlope6.isEmpty ||
        biasCurrent1.isEmpty ||
        biasCurrent3.isEmpty ||
        biasCurrent4.isEmpty ||
        biasCurrent6.isEmpty) {
      return false;
    } else {
      if (dsVVA1 != state.initialValues[DataKey.dsVVA1] ||
          dsVVA3 != state.initialValues[DataKey.dsVVA3] ||
          dsVVA4 != state.initialValues[DataKey.dsVVA4] ||
          dsVVA6 != state.initialValues[DataKey.dsVVA6] ||
          dsInSlope1 != state.initialValues[DataKey.dsInSlope1] ||
          dsInSlope3 != state.initialValues[DataKey.dsInSlope3] ||
          dsInSlope4 != state.initialValues[DataKey.dsInSlope4] ||
          dsInSlope6 != state.initialValues[DataKey.dsInSlope6] ||
          dsOutSlope1 != state.initialValues[DataKey.dsOutSlope1] ||
          dsOutSlope3 != state.initialValues[DataKey.dsOutSlope3] ||
          dsOutSlope4 != state.initialValues[DataKey.dsOutSlope4] ||
          dsOutSlope6 != state.initialValues[DataKey.dsOutSlope6] ||
          biasCurrent1 != state.initialValues[DataKey.biasCurrent1] ||
          biasCurrent3 != state.initialValues[DataKey.biasCurrent3] ||
          biasCurrent4 != state.initialValues[DataKey.biasCurrent4] ||
          biasCurrent6 != state.initialValues[DataKey.biasCurrent6]) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];

    if (state.dsVVA1 != state.initialValues[DataKey.dsVVA1]) {
      bool resultOfSetDSVVA1 =
          await _amp18CCorNodeRepository.set1p8GCCorNodeDSVVA1(state.dsVVA1);

      settingResult.add('${DataKey.dsVVA1.name},$resultOfSetDSVVA1');
    }

    if (state.dsVVA3 != state.initialValues[DataKey.dsVVA3]) {
      bool resultOfSetDSVVA3 =
          await _amp18CCorNodeRepository.set1p8GCCorNodeDSVVA3(state.dsVVA3);

      settingResult.add('${DataKey.dsVVA3.name},$resultOfSetDSVVA3');
    }

    if (state.dsVVA4 != state.initialValues[DataKey.dsVVA4]) {
      bool resultOfSetDSVVA4 =
          await _amp18CCorNodeRepository.set1p8GCCorNodeDSVVA4(state.dsVVA4);

      settingResult.add('${DataKey.dsVVA4.name},$resultOfSetDSVVA4');
    }

    if (state.dsVVA6 != state.initialValues[DataKey.dsVVA6]) {
      bool resultOfSetDSVVA6 =
          await _amp18CCorNodeRepository.set1p8GCCorNodeDSVVA6(state.dsVVA6);

      settingResult.add('${DataKey.dsVVA6.name},$resultOfSetDSVVA6');
    }

    if (state.dsInSlope1 != state.initialValues[DataKey.dsInSlope1]) {
      bool resultOfSetDSInSlope1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSInSlope1(state.dsInSlope1);

      settingResult.add('${DataKey.dsInSlope1.name},$resultOfSetDSInSlope1');
    }

    if (state.dsInSlope3 != state.initialValues[DataKey.dsInSlope3]) {
      bool resultOfSetDSInSlope3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSInSlope3(state.dsInSlope3);

      settingResult.add('${DataKey.dsInSlope3.name},$resultOfSetDSInSlope3');
    }

    if (state.dsInSlope4 != state.initialValues[DataKey.dsInSlope4]) {
      bool resultOfSetDSInSlope4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSInSlope4(state.dsInSlope4);

      settingResult.add('${DataKey.dsInSlope4.name},$resultOfSetDSInSlope4');
    }

    if (state.dsInSlope6 != state.initialValues[DataKey.dsInSlope6]) {
      bool resultOfSetDSInSlope6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSInSlope6(state.dsInSlope6);

      settingResult.add('${DataKey.dsInSlope6.name},$resultOfSetDSInSlope6');
    }

    if (state.dsOutSlope1 != state.initialValues[DataKey.dsOutSlope1]) {
      bool resultOfSetDSOutSlope1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSOutSlope1(state.dsOutSlope1);

      settingResult.add('${DataKey.dsOutSlope1.name},$resultOfSetDSOutSlope1');
    }

    if (state.dsOutSlope3 != state.initialValues[DataKey.dsOutSlope3]) {
      bool resultOfSetDSOutSlope3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSOutSlope3(state.dsOutSlope3);

      settingResult.add('${DataKey.dsOutSlope3.name},$resultOfSetDSOutSlope3');
    }

    if (state.dsOutSlope4 != state.initialValues[DataKey.dsOutSlope4]) {
      bool resultOfSetDSOutSlope4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSOutSlope4(state.dsOutSlope4);

      settingResult.add('${DataKey.dsOutSlope4.name},$resultOfSetDSOutSlope4');
    }

    if (state.dsOutSlope6 != state.initialValues[DataKey.dsOutSlope6]) {
      bool resultOfSetDSOutSlope6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSOutSlope6(state.dsOutSlope6);

      settingResult.add('${DataKey.dsOutSlope6.name},$resultOfSetDSOutSlope6');
    }

    if (state.biasCurrent1 != state.initialValues[DataKey.biasCurrent1]) {
      bool resultOfSetBiasCurrent1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeBiasCurrent1(state.biasCurrent1);

      settingResult
          .add('${DataKey.biasCurrent1.name},$resultOfSetBiasCurrent1');
    }

    if (state.biasCurrent3 != state.initialValues[DataKey.biasCurrent3]) {
      bool resultOfSetBiasCurrent3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeBiasCurrent3(state.biasCurrent3);

      settingResult
          .add('${DataKey.biasCurrent3.name},$resultOfSetBiasCurrent3');
    }

    if (state.biasCurrent4 != state.initialValues[DataKey.biasCurrent4]) {
      bool resultOfSetBiasCurrent4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeBiasCurrent4(state.biasCurrent4);

      settingResult
          .add('${DataKey.biasCurrent4.name},$resultOfSetBiasCurrent4');
    }

    if (state.biasCurrent6 != state.initialValues[DataKey.biasCurrent6]) {
      bool resultOfSetBiasCurrent6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeBiasCurrent6(state.biasCurrent6);

      settingResult
          .add('${DataKey.biasCurrent6.name},$resultOfSetBiasCurrent6');
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

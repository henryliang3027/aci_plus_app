import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_forward_control_event.dart';
part 'setting18_forward_control_state.dart';

class Setting18ForwardControlBloc
    extends Bloc<Setting18ForwardControlEvent, Setting18ForwardControlState> {
  Setting18ForwardControlBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const Setting18ForwardControlState()) {
    on<Initialized>(_onInitialized);
    on<ResetForwardValuesRequested>(_onResetForwardValuesRequested);
    on<DSVVA1Changed>(_onDSVVA1Changed);
    on<DSVVA2Changed>(_onDSVVA2Changed);
    on<DSVVA3Changed>(_onDSVVA3Changed);
    on<DSVVA4Changed>(_onDSVVA4Changed);
    on<DSVVA5Changed>(_onDSVVA5Changed);
    on<DSSlope1Changed>(_onDSSlope1Changed);
    on<DSSlope2Changed>(_onDSSlope2Changed);
    on<DSSlope3Changed>(_onDSSlope3Changed);
    on<DSSlope4Changed>(_onDSSlope4Changed);
    on<TGCCableLengthChanged>(_onTGCCableLengthChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18Repository _amp18Repository;

  double getSlope1MaxValue(String index) {
    if (index.isNotEmpty) {
      int intIndex = int.parse(index);

      if (intIndex >= 0 && intIndex <= 24) {
        return 24.0;
      } else if (intIndex == 120) {
        return 12.0;
      } else if (intIndex == 180) {
        return 12.0;
      } else if (intIndex == 255) {
        return 12.0;
      } else {
        return 12.0;
      }
    } else {
      return 12.0;
    }
  }

  void _onInitialized(
    Initialized event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String forwardCEQIndex =
        characteristicDataCache[DataKey.forwardCEQIndex] ?? '';

    String dsVVA1 = characteristicDataCache[DataKey.dsVVA1] ?? '';
    String dsVVA2 = characteristicDataCache[DataKey.dsVVA2] ?? '';
    String dsVVA3 = characteristicDataCache[DataKey.dsVVA3] ?? '';
    String dsVVA4 = characteristicDataCache[DataKey.dsVVA4] ?? '';
    String dsVVA5 = characteristicDataCache[DataKey.dsVVA5] ?? '';
    String dsSlope1 = characteristicDataCache[DataKey.dsSlope1] ?? '';
    String dsSlope2 = characteristicDataCache[DataKey.dsSlope2] ?? '';
    String dsSlope3 = characteristicDataCache[DataKey.dsSlope3] ?? '';
    String dsSlope4 = characteristicDataCache[DataKey.dsSlope4] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      dsVVA2: dsVVA2,
      dsVVA3: dsVVA3,
      dsVVA4: dsVVA4,
      dsVVA5: dsVVA5,
      dsSlope1: dsSlope1,
      dsSlope2: dsSlope2,
      dsSlope3: dsSlope3,
      dsSlope4: dsSlope4,
      initialValues: characteristicDataCache,
    ));
  }

  void _onResetForwardValuesRequested(
    ResetForwardValuesRequested event,
    Emitter<Setting18ForwardControlState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.submissionInProgress,
    ));

    bool result = await _amp18Repository
        .set1p8GFactoryDefault(43); // load downstream only

    if (result) {
      // 等待 device 完成更新後在讀取值
      await Future.delayed(const Duration(milliseconds: 1000));
      await _amp18Repository.updateCharacteristics();

      emit(state.copyWith(
        resetForwardValuesSubmissionStatus: SubmissionStatus.submissionSuccess,
        editMode: false,
      ));
    } else {
      emit(state.copyWith(
        resetForwardValuesSubmissionStatus: SubmissionStatus.submissionFailure,
        editMode: false,
      ));
    }
  }

  void _onDSVVA1Changed(
    DSVVA1Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA1: event.dsVVA1,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: event.dsVVA1,
      ),
    ));
  }

  void _onDSVVA2Changed(
    DSVVA2Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA2: event.dsVVA2,
      enableSubmission: _isEnabledSubmission(
        dsVVA2: event.dsVVA2,
      ),
    ));
  }

  void _onDSVVA3Changed(
    DSVVA3Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA3: event.dsVVA3,
      enableSubmission: _isEnabledSubmission(
        dsVVA3: event.dsVVA3,
      ),
    ));
  }

  void _onDSVVA4Changed(
    DSVVA4Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA4: event.dsVVA4,
      enableSubmission: _isEnabledSubmission(
        dsVVA4: event.dsVVA4,
      ),
    ));
  }

  void _onDSVVA5Changed(
    DSVVA5Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA5: event.dsVVA5,
      enableSubmission: _isEnabledSubmission(
        dsVVA5: event.dsVVA5,
      ),
    ));
  }

  void _onDSSlope1Changed(
    DSSlope1Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope1: event.dsSlope1,
      enableSubmission: _isEnabledSubmission(
        dsSlope1: event.dsSlope1,
      ),
    ));
  }

  void _onDSSlope2Changed(
    DSSlope2Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope2: event.dsSlope2,
      enableSubmission: _isEnabledSubmission(
        dsSlope2: event.dsSlope2,
      ),
    ));
  }

  void _onDSSlope3Changed(
    DSSlope3Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope3: event.dsSlope3,
      enableSubmission: _isEnabledSubmission(
        dsSlope3: event.dsSlope3,
      ),
    ));
  }

  void _onDSSlope4Changed(
    DSSlope4Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope4: event.dsSlope4,
      enableSubmission: _isEnabledSubmission(
        dsSlope4: event.dsSlope4,
      ),
    ));
  }

  void _onTGCCableLengthChanged(
    TGCCableLengthChanged event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      tgcCableLength: event.tgcCableLength,
      enableSubmission: _isEnabledSubmission(
        tgcCableLength: event.tgcCableLength,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      editMode: false,
      enableSubmission: false,
      dsVVA1: state.initialValues[DataKey.dsVVA1],
      dsVVA2: state.initialValues[DataKey.dsVVA2],
      dsVVA3: state.initialValues[DataKey.dsVVA3],
      dsVVA4: state.initialValues[DataKey.dsVVA4],
      dsSlope1: state.initialValues[DataKey.dsSlope1],
      dsSlope2: state.initialValues[DataKey.dsSlope2],
      dsSlope3: state.initialValues[DataKey.dsSlope3],
      tgcCableLength: state.initialValues[DataKey.tgcCableLength],
    ));
  }

  bool _isEnabledSubmission({
    String? dsVVA1,
    String? dsVVA2,
    String? dsVVA3,
    String? dsVVA4,
    String? dsVVA5,
    String? dsSlope1,
    String? dsSlope2,
    String? dsSlope3,
    String? dsSlope4,
    String? tgcCableLength,
  }) {
    dsVVA1 ??= state.dsVVA1;
    dsVVA2 ??= state.dsVVA2;
    dsVVA3 ??= state.dsVVA3;
    dsVVA4 ??= state.dsVVA4;
    dsVVA5 ??= state.dsVVA5;
    dsSlope1 ??= state.dsSlope1;
    dsSlope2 ??= state.dsSlope2;
    dsSlope3 ??= state.dsSlope3;
    dsSlope4 ??= state.dsSlope4;
    tgcCableLength ??= state.tgcCableLength;

    if (dsVVA1.isEmpty ||
        dsVVA2.isEmpty ||
        dsVVA3.isEmpty ||
        dsVVA4.isEmpty ||
        dsVVA5.isEmpty ||
        dsSlope1.isEmpty ||
        dsSlope2.isEmpty ||
        dsSlope3.isEmpty ||
        dsSlope4.isEmpty) {
      return false;
    } else {
      if (dsVVA1 != state.initialValues[DataKey.dsVVA1] ||
          dsVVA2 != state.initialValues[DataKey.dsVVA2] ||
          dsVVA3 != state.initialValues[DataKey.dsVVA3] ||
          dsVVA4 != state.initialValues[DataKey.dsVVA4] ||
          dsVVA5 != state.initialValues[DataKey.dsVVA5] ||
          dsSlope1 != state.initialValues[DataKey.dsSlope1] ||
          dsSlope2 != state.initialValues[DataKey.dsSlope2] ||
          dsSlope3 != state.initialValues[DataKey.dsSlope3] ||
          dsSlope4 != state.initialValues[DataKey.dsSlope4] ||
          tgcCableLength != state.initialValues[DataKey.tgcCableLength]) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18ForwardControlState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    // 按照畫面上的排列順序依序檢查是否值有改變, 如果有變就進行設定
    List<String> settingResult = [];

    if (state.dsVVA1 != state.initialValues[DataKey.dsVVA1]) {
      bool resultOfSetDSVVA1 =
          await _amp18Repository.set1p8GDSVVA1(state.dsVVA1);

      settingResult.add('${DataKey.dsVVA1.name},$resultOfSetDSVVA1');
    }

    if (state.dsVVA4 != state.initialValues[DataKey.dsVVA4]) {
      bool resultOfSetDSVVA4 =
          await _amp18Repository.set1p8GDSVVA4(state.dsVVA4);

      settingResult.add('${DataKey.dsVVA4.name},$resultOfSetDSVVA4');
    }

    if (state.dsVVA5 != state.initialValues[DataKey.dsVVA5]) {
      bool resultOfSetDSVVA5 =
          await _amp18Repository.set1p8GDSVVA5(state.dsVVA5);

      settingResult.add('${DataKey.dsVVA5.name},$resultOfSetDSVVA5');
    }

    if (state.dsSlope1 != state.initialValues[DataKey.dsSlope1]) {
      bool resultOfSetDSSlope1 =
          await _amp18Repository.set1p8GDSSlope1(state.dsSlope1);

      settingResult.add('${DataKey.dsSlope1.name},$resultOfSetDSSlope1');
    }

    if (state.dsSlope3 != state.initialValues[DataKey.dsSlope3]) {
      bool resultOfSetDSSlope3 =
          await _amp18Repository.set1p8GDSSlope3(state.dsSlope3);

      settingResult.add('${DataKey.dsSlope3.name},$resultOfSetDSSlope3');
    }

    if (state.dsSlope4 != state.initialValues[DataKey.dsSlope4]) {
      bool resultOfSetDSSlope4 =
          await _amp18Repository.set1p8GDSSlope4(state.dsSlope4);

      settingResult.add('${DataKey.dsSlope4.name},$resultOfSetDSSlope4');
    }

    if (state.dsVVA2 != state.initialValues[DataKey.dsVVA2]) {
      bool resultOfSetDSVVA2 =
          await _amp18Repository.set1p8GDSVVA2(state.dsVVA2);

      settingResult.add('${DataKey.dsVVA2.name},$resultOfSetDSVVA2');
    }

    if (state.dsSlope2 != state.initialValues[DataKey.dsSlope2]) {
      bool resultOfSetDSSlope2 =
          await _amp18Repository.set1p8GDSSlope2(state.dsSlope2);

      settingResult.add('${DataKey.dsSlope2.name},$resultOfSetDSSlope2');
    }

    if (state.dsVVA3 != state.initialValues[DataKey.dsVVA3]) {
      bool resultOfSetDSVVA3 =
          await _amp18Repository.set1p8DSVVA3(state.dsVVA3);

      settingResult.add('${DataKey.dsVVA3.name},$resultOfSetDSVVA3');
    }

    // if (state.tgcCableLength != state.initialValues[DataKey.tgcCableLength]) {
    //   bool resultOfSetTGCCableLength =
    //       await _amp18Repository.set1p8GTGCCableLength(state.tgcCableLength);

    //   settingResult
    //       .add('${DataKey.tgcCableLength.name},$resultOfSetTGCCableLength');
    // }

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

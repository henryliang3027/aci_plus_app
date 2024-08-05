import 'package:aci_plus_app/core/control_item_value.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/formz_input_initializer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_reverse_control_event.dart';
part 'setting18_ccor_node_reverse_control_state.dart';

class Setting18CCorNodeReverseControlBloc extends Bloc<
    Setting18CCorNodeReverseControlEvent,
    Setting18CCorNodeReverseControlState> {
  Setting18CCorNodeReverseControlBloc({
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(const Setting18CCorNodeReverseControlState()) {
    on<Initialized>(_onInitialized);
    on<USVCA1Changed>(_onUSVCA1Changed);
    on<USVCA3Changed>(_onUSVCA3Changed);
    on<USVCA4Changed>(_onUSVCA4Changed);
    on<USVCA6Changed>(_onUSVCA6Changed);
    on<ReturnIngressSetting1Changed>(_onReturnIngressSetting1Changed);
    on<ReturnIngressSetting3Changed>(_onReturnIngressSetting3Changed);
    on<ReturnIngressSetting4Changed>(_onReturnIngressSetting4Changed);
    on<ReturnIngressSetting6Changed>(_onReturnIngressSetting6Changed);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18CCorNodeReverseControlState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18CCorNodeRepository.characteristicDataCache;

    String splitOption = characteristicDataCache[DataKey.splitOption]!;
    String partId = characteristicDataCache[DataKey.partId]!;

    Map<DataKey, MinMax> values =
        ControlItemValue.valueCollection[splitOption]![int.parse(partId)];

    MinMax usVCA1MinMax = values[DataKey.usVCA1]!;
    RangeFloatPointInput usVCA1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA1] ?? '',
      minValue: usVCA1MinMax.min,
      maxValue: usVCA1MinMax.max,
    );

    MinMax usVCA3MinMax = values[DataKey.usVCA3]!;
    RangeFloatPointInput usVCA3 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA3] ?? '',
      minValue: usVCA3MinMax.min,
      maxValue: usVCA3MinMax.max,
    );

    MinMax usVCA4MinMax = values[DataKey.usVCA4]!;
    RangeFloatPointInput usVCA4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA4] ?? '',
      minValue: usVCA4MinMax.min,
      maxValue: usVCA4MinMax.max,
    );

    MinMax usVCA6MinMax = values[DataKey.usVCA6]!;
    RangeFloatPointInput usVCA6 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA6] ?? '',
      minValue: usVCA6MinMax.min,
      maxValue: usVCA6MinMax.max,
    );
    String returnIngressSetting1 =
        characteristicDataCache[DataKey.ingressSetting1] ?? '';
    String returnIngressSetting3 =
        characteristicDataCache[DataKey.ingressSetting3] ?? '';
    String returnIngressSetting4 =
        characteristicDataCache[DataKey.ingressSetting4] ?? '';
    String returnIngressSetting6 =
        characteristicDataCache[DataKey.ingressSetting6] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      usVCA3: usVCA3,
      usVCA4: usVCA4,
      usVCA6: usVCA6,
      returnIngressSetting1: returnIngressSetting1,
      returnIngressSetting3: returnIngressSetting3,
      returnIngressSetting4: returnIngressSetting4,
      returnIngressSetting6: returnIngressSetting6,
      initialValues: characteristicDataCache,
      editMode: false,
      enableSubmission: false,
      settingResult: const [],
    ));
  }

  void _onUSVCA1Changed(
    USVCA1Changed event,
    Emitter<Setting18CCorNodeReverseControlState> emit,
  ) {
    RangeFloatPointInput usVCA1 = RangeFloatPointInput.dirty(
      event.usVCA1,
      minValue: state.usVCA1.minValue,
      maxValue: state.usVCA1.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      enableSubmission: _isEnabledSubmission(
        usVCA1: usVCA1,
      ),
    ));
  }

  void _onUSVCA3Changed(
    USVCA3Changed event,
    Emitter<Setting18CCorNodeReverseControlState> emit,
  ) {
    RangeFloatPointInput usVCA3 = RangeFloatPointInput.dirty(
      event.usVCA3,
      minValue: state.usVCA3.minValue,
      maxValue: state.usVCA3.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA3: usVCA3,
      enableSubmission: _isEnabledSubmission(
        usVCA3: usVCA3,
      ),
    ));
  }

  void _onUSVCA4Changed(
    USVCA4Changed event,
    Emitter<Setting18CCorNodeReverseControlState> emit,
  ) {
    RangeFloatPointInput usVCA4 = RangeFloatPointInput.dirty(
      event.usVCA4,
      minValue: state.usVCA4.minValue,
      maxValue: state.usVCA4.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA4: usVCA4,
      enableSubmission: _isEnabledSubmission(
        usVCA4: usVCA4,
      ),
    ));
  }

  void _onUSVCA6Changed(
    USVCA6Changed event,
    Emitter<Setting18CCorNodeReverseControlState> emit,
  ) {
    RangeFloatPointInput usVCA6 = RangeFloatPointInput.dirty(
      event.usVCA6,
      minValue: state.usVCA6.minValue,
      maxValue: state.usVCA6.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA6: usVCA6,
      enableSubmission: _isEnabledSubmission(
        usVCA6: usVCA6,
      ),
    ));
  }

  void _onReturnIngressSetting1Changed(
    ReturnIngressSetting1Changed event,
    Emitter<Setting18CCorNodeReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting1: event.returnIngressSetting1,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting1: event.returnIngressSetting1,
      ),
    ));
  }

  void _onReturnIngressSetting3Changed(
    ReturnIngressSetting3Changed event,
    Emitter<Setting18CCorNodeReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting3: event.returnIngressSetting3,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting3: event.returnIngressSetting3,
      ),
    ));
  }

  void _onReturnIngressSetting4Changed(
    ReturnIngressSetting4Changed event,
    Emitter<Setting18CCorNodeReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting4: event.returnIngressSetting4,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting4: event.returnIngressSetting4,
      ),
    ));
  }

  void _onReturnIngressSetting6Changed(
    ReturnIngressSetting6Changed event,
    Emitter<Setting18CCorNodeReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting6: event.returnIngressSetting6,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting6: event.returnIngressSetting6,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18CCorNodeReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18CCorNodeReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      editMode: false,
      enableSubmission: false,
      usVCA1: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.usVCA1] ?? '',
        minValue: state.usVCA1.minValue,
        maxValue: state.usVCA1.maxValue,
      ),
      usVCA3: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.usVCA3] ?? '',
        minValue: state.usVCA3.minValue,
        maxValue: state.usVCA3.maxValue,
      ),
      usVCA4: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.usVCA4] ?? '',
        minValue: state.usVCA4.minValue,
        maxValue: state.usVCA4.maxValue,
      ),
      usVCA6: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.usVCA6] ?? '',
        minValue: state.usVCA6.minValue,
        maxValue: state.usVCA6.maxValue,
      ),
      returnIngressSetting1: state.initialValues[DataKey.ingressSetting1],
      returnIngressSetting3: state.initialValues[DataKey.ingressSetting3],
      returnIngressSetting4: state.initialValues[DataKey.ingressSetting4],
      returnIngressSetting6: state.initialValues[DataKey.ingressSetting6],
    ));
  }

  bool _isEnabledSubmission({
    RangeFloatPointInput? usVCA1,
    RangeFloatPointInput? usVCA3,
    RangeFloatPointInput? usVCA4,
    RangeFloatPointInput? usVCA6,
    String? returnIngressSetting1,
    String? returnIngressSetting3,
    String? returnIngressSetting4,
    String? returnIngressSetting6,
  }) {
    usVCA1 ??= state.usVCA1;
    usVCA3 ??= state.usVCA3;
    usVCA4 ??= state.usVCA4;
    usVCA6 ??= state.usVCA6;
    returnIngressSetting1 ??= state.returnIngressSetting1;
    returnIngressSetting3 ??= state.returnIngressSetting3;
    returnIngressSetting4 ??= state.returnIngressSetting4;
    returnIngressSetting6 ??= state.returnIngressSetting6;

    if (usVCA1.isNotValid ||
        usVCA3.isNotValid ||
        usVCA4.isNotValid ||
        usVCA6.isNotValid) {
      return false;
    } else {
      if (usVCA1.value != state.initialValues[DataKey.usVCA1] ||
          usVCA3.value != state.initialValues[DataKey.usVCA3] ||
          usVCA4.value != state.initialValues[DataKey.usVCA4] ||
          usVCA6.value != state.initialValues[DataKey.usVCA6] ||
          returnIngressSetting1 !=
              state.initialValues[DataKey.ingressSetting1] ||
          returnIngressSetting3 !=
              state.initialValues[DataKey.ingressSetting3] ||
          returnIngressSetting4 !=
              state.initialValues[DataKey.ingressSetting4] ||
          returnIngressSetting6 !=
              state.initialValues[DataKey.ingressSetting6]) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18CCorNodeReverseControlState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];

    if (state.usVCA1.value != state.initialValues[DataKey.usVCA1]) {
      bool resultOfSetUSVCA1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeUSVCA1(state.usVCA1.value);

      settingResult.add('${DataKey.usVCA1.name},$resultOfSetUSVCA1');
    }

    if (state.usVCA3.value != state.initialValues[DataKey.usVCA3]) {
      bool resultOfSetUSVCA3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeUSVCA3(state.usVCA3.value);

      settingResult.add('${DataKey.usVCA3.name},$resultOfSetUSVCA3');
    }

    if (state.usVCA4.value != state.initialValues[DataKey.usVCA4]) {
      bool resultOfSetUSVCA4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeUSVCA4(state.usVCA4.value);

      settingResult.add('${DataKey.usVCA4.name},$resultOfSetUSVCA4');
    }

    if (state.usVCA6.value != state.initialValues[DataKey.usVCA6]) {
      bool resultOfSetUSVCA6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeUSVCA6(state.usVCA6.value);

      settingResult.add('${DataKey.usVCA6.name},$resultOfSetUSVCA6');
    }

    if (state.returnIngressSetting1 !=
        state.initialValues[DataKey.ingressSetting1]) {
      bool resultOfSetReturnIngress1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeReturnIngress1(state.returnIngressSetting1);

      settingResult
          .add('${DataKey.ingressSetting1.name},$resultOfSetReturnIngress1');
    }
    if (state.returnIngressSetting3 !=
        state.initialValues[DataKey.ingressSetting3]) {
      bool resultOfSetReturnIngress3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeReturnIngress3(state.returnIngressSetting3);

      settingResult
          .add('${DataKey.ingressSetting3.name},$resultOfSetReturnIngress3');
    }
    if (state.returnIngressSetting4 !=
        state.initialValues[DataKey.ingressSetting4]) {
      bool resultOfSetReturnIngress4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeReturnIngress4(state.returnIngressSetting4);

      settingResult
          .add('${DataKey.ingressSetting4.name},$resultOfSetReturnIngress4');
    }
    if (state.returnIngressSetting6 !=
        state.initialValues[DataKey.ingressSetting6]) {
      bool resultOfSetReturnIngress6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeReturnIngress6(state.returnIngressSetting6);

      settingResult
          .add('${DataKey.ingressSetting6.name},$resultOfSetReturnIngress6');
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

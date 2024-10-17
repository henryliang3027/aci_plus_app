import 'dart:async';

import 'package:aci_plus_app/core/control_item_value.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/formz_input_initializer.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'setting18_graph_module_event.dart';
part 'setting18_graph_module_state.dart';

class Setting18GraphModuleBloc
    extends Bloc<Setting18GraphModuleEvent, Setting18GraphModuleState> {
  Setting18GraphModuleBloc({
    required Amp18Repository amp18Repository,
    bool editable = true,
  })  : _amp18Repository = amp18Repository,
        _editable = editable,
        super(const Setting18GraphModuleState()) {
    on<Initialized>(_onInitialized);
    on<DSVVA1Changed>(_onDSVVA1Changed);
    on<DSVVA4Changed>(_onDSVVA4Changed);
    on<DSVVA5Changed>(_onDSVVA5Changed);
    on<DSSlope1Changed>(_onDSSlope1Changed);
    on<DSSlope3Changed>(_onDSSlope3Changed);
    on<DSSlope4Changed>(_onDSSlope4Changed);
    on<USVCA1Changed>(_onUSVCA1Changed);
    on<USVCA2Changed>(_onUSVCA2Changed);
    on<USVCA3Changed>(_onUSVCA3Changed);
    on<USVCA4Changed>(_onUSVCA4Changed);
    on<EREQChanged>(_onEREQChanged);
    on<RtnIngressSetting2Changed>(_onRtnIngressSetting2Changed);
    on<RtnIngressSetting3Changed>(_onRtnIngressSetting3Changed);
    on<RtnIngressSetting4Changed>(_onRtnIngressSetting4Changed);
    // on<TGCCableLengthChanged>(_onTGCCableLengthChanged);
    // on<USTGCChanged>(_onUSTGCChanged);
    on<SplitOptionChanged>(_onSplitOptionChanged);
    on<PilotFrequencyModeChanged>(_onPilotFrequencyModeChanged);
    on<FirstChannelLoadingFrequencyChanged>(
        _onFirstChannelLoadingFrequencyChanged);
    on<LastChannelLoadingFrequencyChanged>(
        _onLastChannelLoadingFrequencyChanged);
    on<FirstChannelLoadingLevelChanged>(_onFirstChannelLoadingLevelChanged);
    on<LastChannelLoadingLevelChanged>(_onLastChannelLoadingLevelChanged);
    on<AGCModeChanged>(_onAGCModeChanged);
    on<ALCModeChanged>(_onALCModeChanged);
    on<PilotFrequency1Changed>(_onPilotFrequency1Changed);
    on<PilotFrequency2Changed>(_onPilotFrequency2Changed);

    on<SettingSubmitted>(_onSettingSubmitted);
    on<CurrentForwardCEQUpdated>(_onCurrentForwardCEQUpdated);
    on<CurrentForwardCEQPeriodicUpdateRequested>(
        _onCurrentForwardCEQPeriodicUpdateRequested);
    on<CurrentForwardCEQPeriodicUpdateCanceled>(
        _onCurrentForwardCEQPeriodicUpdateCanceled);

    add(const Initialized());
    add(const CurrentForwardCEQPeriodicUpdateRequested());
  }

  final Amp18Repository _amp18Repository;
  final bool _editable;
  Timer? _timer;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18GraphModuleState> emit,
  ) async {
    if (!event.useCache) {
      await _amp18Repository.updateSettingCharacteristics();
    }

    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    // ex: C-coe LE 沒有 VVA4, VVA5, VCA3, VCA4, 讀到的值是 -0.1, 不符合範圍, 所以改成 0.0 作為初始值
    characteristicDataCache.forEach((key, value) {
      if (value == '-0.1') {
        characteristicDataCache[key] = '0.0';
      }
    });

    String forwardCEQIndex =
        characteristicDataCache[DataKey.forwardCEQIndex] ?? '';

    String splitOption = characteristicDataCache[DataKey.splitOption]!;
    String partId = characteristicDataCache[DataKey.partId]!;
    String operatingMode = getOperatingModeFromForwardCEQIndex(forwardCEQIndex);

    Map<DataKey, MinMax> values = ControlItemValue
        .allValueCollections[operatingMode]![splitOption]![int.parse(partId)];

    MinMax dsVVA1MinMax = values[DataKey.dsVVA1] ??
        MinMax(
          min: state.dsVVA1.minValue,
          max: state.dsVVA1.maxValue,
        );
    RangeFloatPointInput dsVVA1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA1] ?? '',
      minValue: dsVVA1MinMax.min,
      maxValue: dsVVA1MinMax.max,
    );

    MinMax dsVVA4MinMax = values[DataKey.dsVVA4] ??
        MinMax(
          min: state.dsVVA4.minValue,
          max: state.dsVVA4.maxValue,
        );
    RangeFloatPointInput dsVVA4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA4] ?? '',
      minValue: dsVVA4MinMax.min,
      maxValue: dsVVA4MinMax.max,
    );

    MinMax dsVVA5MinMax = values[DataKey.dsVVA5] ??
        MinMax(
          min: state.dsVVA5.minValue,
          max: state.dsVVA5.maxValue,
        );
    RangeFloatPointInput dsVVA5 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA5] ?? '',
      minValue: dsVVA5MinMax.min,
      maxValue: dsVVA5MinMax.max,
    );

    MinMax dsSlope1MinMax = values[DataKey.dsSlope1] ??
        MinMax(
          min: state.dsSlope1.minValue,
          max: state.dsSlope1.maxValue,
        );
    RangeFloatPointInput dsSlope1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsSlope1] ?? '',
      minValue: dsSlope1MinMax.min,
      maxValue: dsSlope1MinMax.max,
    );

    MinMax dsSlope3MinMax = values[DataKey.dsSlope3] ??
        MinMax(
          min: state.dsSlope3.minValue,
          max: state.dsSlope3.maxValue,
        );
    RangeFloatPointInput dsSlope3 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsSlope3] ?? '',
      minValue: dsSlope3MinMax.min,
      maxValue: dsSlope3MinMax.max,
    );

    MinMax dsSlope4MinMax = values[DataKey.dsSlope4] ??
        MinMax(
          min: state.dsSlope4.minValue,
          max: state.dsSlope4.maxValue,
        );
    RangeFloatPointInput dsSlope4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsSlope4] ?? '',
      minValue: dsSlope4MinMax.min,
      maxValue: dsSlope4MinMax.max,
    );

    MinMax usVCA1MinMax = values[DataKey.usVCA1] ??
        MinMax(
          min: state.usVCA1.minValue,
          max: state.usVCA1.maxValue,
        );
    RangeFloatPointInput usVCA1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA1] ?? '',
      minValue: usVCA1MinMax.min,
      maxValue: usVCA1MinMax.max,
    );

    MinMax usVCA2MinMax = values[DataKey.usVCA2] ??
        MinMax(
          min: state.usVCA2.minValue,
          max: state.usVCA2.maxValue,
        );
    RangeFloatPointInput usVCA2 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA2] ?? '',
      minValue: usVCA2MinMax.min,
      maxValue: usVCA2MinMax.max,
    );

    MinMax usVCA3MinMax = values[DataKey.usVCA3] ??
        MinMax(
          min: state.usVCA3.minValue,
          max: state.usVCA3.maxValue,
        );
    RangeFloatPointInput usVCA3 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA3] ?? '',
      minValue: usVCA3MinMax.min,
      maxValue: usVCA3MinMax.max,
    );

    MinMax usVCA4MinMax = values[DataKey.usVCA4] ??
        MinMax(
          min: state.usVCA4.minValue,
          max: state.usVCA4.maxValue,
        );
    RangeFloatPointInput usVCA4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA4] ?? '',
      minValue: usVCA4MinMax.min,
      maxValue: usVCA4MinMax.max,
    );

    MinMax eREQMinMax = values[DataKey.eREQ] ??
        MinMax(
          min: state.eREQ.minValue,
          max: state.eREQ.maxValue,
        );
    RangeFloatPointInput eREQ = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.eREQ] ?? '',
      minValue: eREQMinMax.min,
      maxValue: eREQMinMax.max,
    );

    String ingressSetting2 =
        characteristicDataCache[DataKey.ingressSetting2] ?? '';
    String ingressSetting3 =
        characteristicDataCache[DataKey.ingressSetting3] ?? '';
    String ingressSetting4 =
        characteristicDataCache[DataKey.ingressSetting4] ?? '';
    String tgcCableLength =
        characteristicDataCache[DataKey.tgcCableLength] ?? '';
    // String usTGC = characteristicDataCache[DataKey.usTGC] ?? '';

    String firstChannelLoadingFrequency =
        characteristicDataCache[DataKey.firstChannelLoadingFrequency] ?? '';
    String lastChannelLoadingFrequency =
        characteristicDataCache[DataKey.lastChannelLoadingFrequency] ?? '';
    String firstChannelLoadingLevel =
        characteristicDataCache[DataKey.firstChannelLoadingLevel] ?? '';
    String lastChannelLoadingLevel =
        characteristicDataCache[DataKey.lastChannelLoadingLevel] ?? '';
    String pilotFrequencyMode =
        characteristicDataCache[DataKey.pilotFrequencyMode] ?? '';
    String pilotFrequency1 =
        characteristicDataCache[DataKey.pilotFrequency1] ?? '';
    String pilotFrequency2 =
        characteristicDataCache[DataKey.pilotFrequency2] ?? '';

    String manualModePilot1RFOutputPower =
        characteristicDataCache[DataKey.manualModePilot1RFOutputPower] ?? '';
    String manualModePilot2RFOutputPower =
        characteristicDataCache[DataKey.manualModePilot2RFOutputPower] ?? '';

    String agcMode = characteristicDataCache[DataKey.agcMode] ?? '';
    String alcMode = characteristicDataCache[DataKey.alcMode] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      dsVVA4: dsVVA4,
      dsVVA5: dsVVA5,
      dsSlope1: dsSlope1,
      dsSlope3: dsSlope3,
      dsSlope4: dsSlope4,
      usVCA1: usVCA1,
      usVCA2: usVCA2,
      usVCA3: usVCA3,
      usVCA4: usVCA4,
      eREQ: eREQ,
      returnIngressSetting2: ingressSetting2,
      returnIngressSetting3: ingressSetting3,
      returnIngressSetting4: ingressSetting4,
      tgcCableLength: tgcCableLength,
      // usTGC: usTGC,
      splitOption: splitOption,
      pilotFrequencyMode: pilotFrequencyMode,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency.isNotEmpty
          ? RangeIntegerInput.dirty(firstChannelLoadingFrequency)
          : const RangeIntegerInput.pure(),
      firstChannelLoadingLevel:
          RangeFloatPointInput.dirty(firstChannelLoadingLevel),
      lastChannelLoadingFrequency:
          RangeIntegerInput.dirty(lastChannelLoadingFrequency),
      lastChannelLoadingLevel:
          RangeFloatPointInput.dirty(lastChannelLoadingLevel),
      pilotFrequency1: RangeIntegerInput.dirty(pilotFrequency1),
      pilotFrequency2: RangeIntegerInput.dirty(pilotFrequency2),
      manualModePilot1RFOutputPower: manualModePilot1RFOutputPower,
      manualModePilot2RFOutputPower: manualModePilot2RFOutputPower,
      agcMode: agcMode,
      alcMode: alcMode,
      isInitialize: true,
      isInitialPilotFrequencyLevelValues: false,
      initialValues: characteristicDataCache,
      editMode: _editable,
      enableSubmission: false,
      tappedSet: const {},
      settingResult: const [],
    ));
  }

  void _onDSVVA1Changed(
    DSVVA1Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput dsVVA1 = RangeFloatPointInput.dirty(
      event.dsVVA1,
      minValue: state.dsVVA1.minValue,
      maxValue: state.dsVVA1.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsVVA1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
      ),
    ));
  }

  void _onDSVVA4Changed(
    DSVVA4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput dsVVA4 = RangeFloatPointInput.dirty(
      event.dsVVA4,
      minValue: state.dsVVA4.minValue,
      maxValue: state.dsVVA4.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsVVA4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA4: dsVVA4,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsVVA4: dsVVA4,
      ),
    ));
  }

  void _onDSVVA5Changed(
    DSVVA5Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput dsVVA5 = RangeFloatPointInput.dirty(
      event.dsVVA5,
      minValue: state.dsVVA5.minValue,
      maxValue: state.dsVVA5.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsVVA5);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA5: dsVVA5,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsVVA5: dsVVA5,
      ),
    ));
  }

  void _onDSSlope1Changed(
    DSSlope1Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput dsSlope1 = RangeFloatPointInput.dirty(
      event.dsSlope1,
      minValue: state.dsSlope1.minValue,
      maxValue: state.dsSlope1.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsSlope1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope1: dsSlope1,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsSlope1: dsSlope1,
      ),
    ));
  }

  void _onDSSlope3Changed(
    DSSlope3Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput dsSlope3 = RangeFloatPointInput.dirty(
      event.dsSlope3,
      minValue: state.dsSlope3.minValue,
      maxValue: state.dsSlope3.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsSlope3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope3: dsSlope3,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsSlope3: dsSlope3,
      ),
    ));
  }

  void _onDSSlope4Changed(
    DSSlope4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput dsSlope4 = RangeFloatPointInput.dirty(
      event.dsSlope4,
      minValue: state.dsSlope4.minValue,
      maxValue: state.dsSlope4.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsSlope4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope4: dsSlope4,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsSlope4: dsSlope4,
      ),
    ));
  }

  void _onUSVCA1Changed(
    USVCA1Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput usVCA1 = RangeFloatPointInput.dirty(
      event.usVCA1,
      minValue: state.usVCA1.minValue,
      maxValue: state.usVCA1.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.usVCA1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        usVCA1: usVCA1,
      ),
    ));
  }

  void _onUSVCA2Changed(
    USVCA2Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput usVCA2 = RangeFloatPointInput.dirty(
      event.usVCA2,
      minValue: state.usVCA2.minValue,
      maxValue: state.usVCA2.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.usVCA2);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA2: usVCA2,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        usVCA2: usVCA2,
      ),
    ));
  }

  void _onUSVCA3Changed(
    USVCA3Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput usVCA3 = RangeFloatPointInput.dirty(
      event.usVCA3,
      minValue: state.usVCA3.minValue,
      maxValue: state.usVCA3.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.usVCA3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA3: usVCA3,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        usVCA3: usVCA3,
      ),
    ));
  }

  void _onUSVCA4Changed(
    USVCA4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput usVCA4 = RangeFloatPointInput.dirty(
      event.usVCA4,
      minValue: state.usVCA4.minValue,
      maxValue: state.usVCA4.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.usVCA4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA4: usVCA4,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        usVCA4: usVCA4,
      ),
    ));
  }

  void _onEREQChanged(
    EREQChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput eREQ = RangeFloatPointInput.dirty(
      event.eREQ,
      minValue: state.eREQ.minValue,
      maxValue: state.eREQ.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.eREQ);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      eREQ: eREQ,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        eREQ: eREQ,
      ),
    ));
  }

  void _onRtnIngressSetting2Changed(
    RtnIngressSetting2Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.ingressSetting2);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting2: event.returnIngressSetting2,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting2: event.returnIngressSetting2,
      ),
    ));
  }

  void _onRtnIngressSetting3Changed(
    RtnIngressSetting3Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.ingressSetting3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting3: event.returnIngressSetting3,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting3: event.returnIngressSetting3,
      ),
    ));
  }

  void _onRtnIngressSetting4Changed(
    RtnIngressSetting4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.ingressSetting4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting4: event.returnIngressSetting4,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting4: event.returnIngressSetting4,
      ),
    ));
  }

  // void _onTGCCableLengthChanged(
  //   TGCCableLengthChanged event,
  //   Emitter<Setting18GraphModuleState> emit,
  // ) {
  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     tgcCableLength: event.tgcCableLength,
  //     isInitialize: false,
  //     enableSubmission: _isEnabledSubmission(
  //       tgcCableLength: event.tgcCableLength,
  //     ),
  //   ));
  // }

  // void _onUSTGCChanged(
  //   USTGCChanged event,
  //   Emitter<Setting18GraphModuleState> emit,
  // ) {
  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     usTGC: event.usTGC,
  //     isInitialize: false,
  //     enableSubmission: _isEnabledSubmission(
  //       fwdInputAttenuation: state.fwdInputAttenuation,
  //       dsSlope1: state.dsSlope1,
  //       usVCA1: state.usVCA1,
  //       returnInputAttenuation3: state.returnInputAttenuation3,
  //       returnInputAttenuation4: state.returnInputAttenuation4,
  //       usVCA2: state.usVCA2,
  //       eREQ: state.eREQ,
  //       returnIngressSetting2: state.returnIngressSetting2,
  //       returnIngressSetting3: state.returnIngressSetting3,
  //       returnIngressSetting4: state.returnIngressSetting4,
  //       tgcCableLength: state.tgcCableLength,
  //       dsVVA2: state.dsVVA2,
  //       dsSlope2: state.dsSlope2,
  //       dsVVA3: state.dsVVA3,
  //       dsVVA4: state.dsVVA4,
  //       usTGC: event.usTGC,
  //       splitOption: state.splitOption,
  //       pilotFrequencyMode: state.pilotFrequencyMode,
  //       firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
  //       firstChannelLoadingLevel: state.firstChannelLoadingLevel,
  //       lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
  //       lastChannelLoadingLevel: state.lastChannelLoadingLevel,
  //       pilotFrequency1: state.pilotFrequency1,
  //       pilotFrequency2: state.pilotFrequency2,
  //     ),
  //   ));
  // }

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.splitOption);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      splitOption: event.splitOption,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        splitOption: event.splitOption,
      ),
    ));
  }

  void _onPilotFrequencyModeChanged(
    PilotFrequencyModeChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.pilotFrequencyMode);

    tappedSet.remove(DataKey.firstChannelLoadingFrequency);
    tappedSet.remove(DataKey.firstChannelLoadingLevel);
    tappedSet.remove(DataKey.lastChannelLoadingFrequency);
    tappedSet.remove(DataKey.lastChannelLoadingLevel);
    tappedSet.remove(DataKey.pilotFrequency1);
    tappedSet.remove(DataKey.pilotFrequency2);

    String firstChannelLoadingFrequencyValue = '';
    String firstChannelLoadingLevelValue = '';
    String lastChannelLoadingFrequencyValue = '';
    String lastChannelLoadingLevelValue = '';
    String pilotFrequency1Value = '';
    String pilotFrequency2Value = '';

    if (event.pilotFrequencyMode != state.pilotFrequencyMode) {
      firstChannelLoadingFrequencyValue =
          state.initialValues[DataKey.firstChannelLoadingFrequency] ?? '';
      firstChannelLoadingLevelValue =
          state.initialValues[DataKey.firstChannelLoadingLevel] ?? '';
      lastChannelLoadingFrequencyValue =
          state.initialValues[DataKey.lastChannelLoadingFrequency] ?? '';
      lastChannelLoadingLevelValue =
          state.initialValues[DataKey.lastChannelLoadingLevel] ?? '';
      pilotFrequency1Value = state.initialValues[DataKey.pilotFrequency1] ?? '';
      pilotFrequency2Value = state.initialValues[DataKey.pilotFrequency2] ?? '';
    } else {
      firstChannelLoadingFrequencyValue =
          state.firstChannelLoadingFrequency.value;
      firstChannelLoadingLevelValue = state.firstChannelLoadingLevel.value;
      lastChannelLoadingFrequencyValue =
          state.lastChannelLoadingFrequency.value;
      lastChannelLoadingLevelValue = state.lastChannelLoadingLevel.value;
      pilotFrequency1Value = state.pilotFrequency1.value;
      pilotFrequency2Value = state.pilotFrequency2.value;
    }

    int forwardStartFrequency = _getMinForwardStartFrequency();

    RangeIntegerInput firstChannelLoadingFrequency = RangeIntegerInput.dirty(
      firstChannelLoadingFrequencyValue,
      minValue: forwardStartFrequency,
      maxValue: 1794,
    );

    RangeFloatPointInput firstChannelLoadingLevel = RangeFloatPointInput.dirty(
      firstChannelLoadingLevelValue,
      minValue: 20.0,
      maxValue: 61.0,
    );

    RangeIntegerInput lastChannelLoadingFrequency = RangeIntegerInput.dirty(
      lastChannelLoadingFrequencyValue,
      minValue: forwardStartFrequency,
      maxValue: 1794,
    );

    RangeFloatPointInput lastChannelLoadingLevel = RangeFloatPointInput.dirty(
      lastChannelLoadingLevelValue,
      minValue: 20.0,
      maxValue: 61.0,
    );

    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      pilotFrequency1Value,
      minValue: forwardStartFrequency,
      maxValue: 1794,
    );

    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      pilotFrequency2Value,
      minValue: forwardStartFrequency,
      maxValue: 1794,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequencyMode: event.pilotFrequencyMode,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      pilotFrequency1: pilotFrequency1,
      pilotFrequency2: pilotFrequency2,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: true,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        pilotFrequencyMode: event.pilotFrequencyMode,
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
        pilotFrequency1: pilotFrequency1,
        pilotFrequency2: pilotFrequency2,
      ),
    ));
  }

  int _getMinForwardStartFrequency() {
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String currentDetectedSplitOption =
        characteristicDataCache[DataKey.currentDetectedSplitOption] ?? '0';

    int startFrequency = splitBaseLine[currentDetectedSplitOption]?.$2 ?? 0;

    return startFrequency;
  }

  void _onFirstChannelLoadingFrequencyChanged(
    FirstChannelLoadingFrequencyChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    int forwardStartFrequency = _getMinForwardStartFrequency();

    // 偵測到的splitOption的起始頻率 <= event.firstChannelLoadingFrequency <= 偵測到的splitOption的截止頻率\
    // 截止頻率輸入內容不符時, event.lastChannelLoadingFrequency <= 1794
    RangeIntegerInput firstChannelLoadingFrequency = RangeIntegerInput.dirty(
      event.firstChannelLoadingFrequency,
      minValue: forwardStartFrequency,
      maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ?? 1794,
    );

    // 輸入的起始頻率 <= event.lastChannelLoadingFrequency <= 1794
    // 起始頻率輸入內容不符時, 偵測到的splitOption的起始頻率 <= event.lastChannelLoadingFrequency
    RangeIntegerInput lastChannelLoadingFrequency = RangeIntegerInput.dirty(
      state.lastChannelLoadingFrequency.value,
      minValue: int.tryParse(event.firstChannelLoadingFrequency) ??
          forwardStartFrequency,
      maxValue: 1794,
    );

    // minValue 判斷優先順序
    // firstChannelLoadingFrequency <= pilotFrequency1
    // 如果也沒輸入 firstChannelLoadingFrequency 則 forwardStartFrequency <= pilotFrequency1

    // maxValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency2 則 pilotFrequency1 <= lastChannelLoadingFrequency
    // 如果也沒輸入 lastChannelLoadingFrequency 則 pilotFrequency1 <= 1794
    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      state.pilotFrequency1.value,
      minValue: int.tryParse(event.firstChannelLoadingFrequency) ??
          forwardStartFrequency,
      maxValue: int.tryParse(state.pilotFrequency2.value) ??
          int.tryParse(state.lastChannelLoadingFrequency.value) ??
          1794,
    );

    // minValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency1 則 firstChannelLoadingFrequency <= pilotFrequency2
    // 如果也沒輸入 firstChannelLoadingFrequency 則 forwardStartFrequency <= pilotFrequency2

    // maxValue 判斷優先順序
    // pilotFrequency2 <= lastChannelLoadingFrequency
    // 如果沒輸入 lastChannelLoadingFrequency 則 pilotFrequency2 <= 1794
    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      state.pilotFrequency2.value,
      minValue: int.tryParse(state.pilotFrequency1.value) ??
          int.tryParse(event.firstChannelLoadingFrequency) ??
          forwardStartFrequency,
      maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ?? 1794,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.firstChannelLoadingFrequency);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      pilotFrequency1: pilotFrequency1,
      pilotFrequency2: pilotFrequency2,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        pilotFrequency1: pilotFrequency1,
        pilotFrequency2: pilotFrequency2,
      ),
    ));
  }

  void _onFirstChannelLoadingLevelChanged(
    FirstChannelLoadingLevelChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    // 20.0 <= firstChannelLoadingLevel <= lastChannelLoadingLevel
    // 如果沒輸入 lastChannelLoadingLevel 時 lastChannelLoadingLevel <= 61.0
    RangeFloatPointInput firstChannelLoadingLevel = RangeFloatPointInput.dirty(
      event.firstChannelLoadingLevel,
      minValue: 20.0,
      maxValue: double.tryParse(state.lastChannelLoadingLevel.value) ?? 61.0,
    );

    // 輸入的起始頻率 <= event.lastChannelLoadingFrequency <= 1794
    // 起始頻率輸入內容不符時, 偵測到的splitOption的起始頻率 <= event.lastChannelLoadingFrequency
    RangeFloatPointInput lastChannelLoadingLevel = RangeFloatPointInput.dirty(
      state.lastChannelLoadingLevel.value,
      minValue: double.tryParse(
            event.firstChannelLoadingLevel,
          ) ??
          20.0,
      maxValue: 61.0,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.firstChannelLoadingLevel);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
      ),
    ));
  }

  void _onLastChannelLoadingFrequencyChanged(
    LastChannelLoadingFrequencyChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    int forwardStartFrequency = _getMinForwardStartFrequency();

    // 偵測到的splitOption的起始頻率 <= event.firstChannelLoadingFrequency <= 輸入的截止頻率
    // 截止頻率輸入內容不符時, event.lastChannelLoadingFrequency <= 1794
    RangeIntegerInput firstChannelLoadingFrequency = RangeIntegerInput.dirty(
      state.firstChannelLoadingFrequency.value,
      minValue: forwardStartFrequency,
      maxValue: int.tryParse(event.lastChannelLoadingFrequency) ?? 1794,
    );

    // 輸入的起始頻率 <= event.lastChannelLoadingFrequency <= 1794
    // 起始頻率輸入內容不符時, 偵測到的splitOption的起始頻率 <= event.lastChannelLoadingFrequency
    RangeIntegerInput lastChannelLoadingFrequency = RangeIntegerInput.dirty(
      event.lastChannelLoadingFrequency,
      minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
          forwardStartFrequency,
      maxValue: 1794,
    );

    // minValue 判斷優先順序
    // firstChannelLoadingFrequency <= pilotFrequency1
    // 如果也沒輸入 firstChannelLoadingFrequency 則 forwardStartFrequency <= pilotFrequency1

    // maxValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency2 則 pilotFrequency1 <= lastChannelLoadingFrequency
    // 如果也沒輸入 lastChannelLoadingFrequency 則 pilotFrequency1 <= 1794
    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      state.pilotFrequency1.value,
      minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
          forwardStartFrequency,
      maxValue: int.tryParse(state.pilotFrequency2.value) ??
          int.tryParse(state.lastChannelLoadingFrequency.value) ??
          1794,
    );

    // minValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency1 則 firstChannelLoadingFrequency <= pilotFrequency2
    // 如果也沒輸入 firstChannelLoadingFrequency 則 forwardStartFrequency <= pilotFrequency2

    // maxValue 判斷優先順序
    // pilotFrequency2 <= lastChannelLoadingFrequency
    // 如果沒輸入 lastChannelLoadingFrequency 則 pilotFrequency2 <= 1794
    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      state.pilotFrequency2.value,
      minValue: int.tryParse(state.pilotFrequency1.value) ??
          int.tryParse(state.firstChannelLoadingFrequency.value) ??
          forwardStartFrequency,
      maxValue: int.tryParse(event.lastChannelLoadingFrequency) ?? 1794,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.lastChannelLoadingFrequency);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      pilotFrequency1: pilotFrequency1,
      pilotFrequency2: pilotFrequency2,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        pilotFrequency1: pilotFrequency1,
        pilotFrequency2: pilotFrequency2,
      ),
    ));
  }

  void _onLastChannelLoadingLevelChanged(
    LastChannelLoadingLevelChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    // 20.0 <= firstChannelLoadingLevel <= lastChannelLoadingLevel
    // 如果沒輸入 lastChannelLoadingLevel 時 lastChannelLoadingLevel <= 61.0
    RangeFloatPointInput firstChannelLoadingLevel = RangeFloatPointInput.dirty(
      state.firstChannelLoadingLevel.value,
      minValue: 20.0,
      maxValue: double.tryParse(event.lastChannelLoadingLevel) ?? 61.0,
    );

    // 輸入的起始頻率 <= event.lastChannelLoadingFrequency <= 1794
    // 起始頻率輸入內容不符時, 偵測到的splitOption的起始頻率 <= event.lastChannelLoadingFrequency
    RangeFloatPointInput lastChannelLoadingLevel = RangeFloatPointInput.dirty(
      event.lastChannelLoadingLevel,
      minValue: double.tryParse(
            state.firstChannelLoadingLevel.value,
          ) ??
          20.0,
      maxValue: 61.0,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.lastChannelLoadingLevel);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
      ),
    ));
  }

  void _onPilotFrequency1Changed(
    PilotFrequency1Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    // minValue 判斷優先順序
    // firstChannelLoadingFrequency <= pilotFrequency1
    // 如果也沒輸入 firstChannelLoadingFrequency 則 forwardStartFrequency <= pilotFrequency1

    // maxValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency2 則 pilotFrequency1 <= lastChannelLoadingFrequency
    // 如果也沒輸入 lastChannelLoadingFrequency 則 pilotFrequency1 <= 1794
    int forwardStartFrequency = _getMinForwardStartFrequency();
    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      event.pilotFrequency1,
      minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
          forwardStartFrequency,
      maxValue: int.tryParse(state.pilotFrequency2.value) ??
          int.tryParse(state.lastChannelLoadingFrequency.value) ??
          1794,
    );

    // minValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency1 則 firstChannelLoadingFrequency <= pilotFrequency2
    // 如果也沒輸入 firstChannelLoadingFrequency 則 forwardStartFrequency <= pilotFrequency2

    // maxValue 判斷優先順序
    // pilotFrequency2 <= lastChannelLoadingFrequency
    // 如果沒輸入 lastChannelLoadingFrequency 則 pilotFrequency2 <= 1794
    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      state.pilotFrequency2.value,
      minValue: int.tryParse(event.pilotFrequency1) ??
          int.tryParse(state.firstChannelLoadingFrequency.value) ??
          forwardStartFrequency,
      maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ?? 1794,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.pilotFrequency1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequency1: pilotFrequency1,
      pilotFrequency2: pilotFrequency2,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        pilotFrequency1: pilotFrequency1,
        pilotFrequency2: pilotFrequency2,
      ),
    ));
  }

  void _onPilotFrequency2Changed(
    PilotFrequency2Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    // minValue 判斷優先順序
    // firstChannelLoadingFrequency <= pilotFrequency1
    // 如果也沒輸入 firstChannelLoadingFrequency 則 forwardStartFrequency <= pilotFrequency1

    // maxValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency2 則 pilotFrequency1 <= lastChannelLoadingFrequency
    // 如果也沒輸入 lastChannelLoadingFrequency 則 pilotFrequency1 <= 1794
    int forwardStartFrequency = _getMinForwardStartFrequency();
    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      state.pilotFrequency1.value,
      minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
          forwardStartFrequency,
      maxValue: int.tryParse(event.pilotFrequency2) ??
          int.tryParse(state.lastChannelLoadingFrequency.value) ??
          1794,
    );

    // minValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency1 則 firstChannelLoadingFrequency <= pilotFrequency2
    // 如果也沒輸入 firstChannelLoadingFrequency 則 forwardStartFrequency <= pilotFrequency2

    // maxValue 判斷優先順序
    // pilotFrequency2 <= lastChannelLoadingFrequency
    // 如果沒輸入 lastChannelLoadingFrequency 則 pilotFrequency2 <= 1794
    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      event.pilotFrequency2,
      minValue: int.tryParse(state.pilotFrequency1.value) ??
          int.tryParse(state.firstChannelLoadingFrequency.value) ??
          forwardStartFrequency,
      maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ?? 1794,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.pilotFrequency2);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequency1: pilotFrequency1,
      pilotFrequency2: pilotFrequency2,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        pilotFrequency1: pilotFrequency1,
        pilotFrequency2: pilotFrequency2,
      ),
    ));
  }

  void _onAGCModeChanged(
    AGCModeChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.agcMode);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      agcMode: event.agcMode,
      alcMode: event.agcMode,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        agcMode: event.agcMode,
        alcMode: event.agcMode,
      ),
    ));
  }

  void _onALCModeChanged(
    ALCModeChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.alcMode);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      agcMode: event.alcMode,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        alcMode: event.alcMode,
      ),
    ));
  }

  bool _isEnabledSubmission({
    RangeFloatPointInput? dsVVA1,
    RangeFloatPointInput? dsVVA4,
    RangeFloatPointInput? dsVVA5,
    RangeFloatPointInput? dsSlope1,
    RangeFloatPointInput? dsSlope3,
    RangeFloatPointInput? dsSlope4,
    RangeFloatPointInput? usVCA1,
    RangeFloatPointInput? usVCA2,
    RangeFloatPointInput? usVCA3,
    RangeFloatPointInput? usVCA4,
    RangeFloatPointInput? eREQ,
    String? returnIngressSetting2,
    String? returnIngressSetting3,
    String? returnIngressSetting4,
    String? tgcCableLength,
    //  String usTGC,
    String? splitOption,
    RangeIntegerInput? firstChannelLoadingFrequency,
    RangeFloatPointInput? firstChannelLoadingLevel,
    RangeIntegerInput? lastChannelLoadingFrequency,
    RangeFloatPointInput? lastChannelLoadingLevel,
    String? pilotFrequencyMode,
    RangeIntegerInput? pilotFrequency1,
    RangeIntegerInput? pilotFrequency2,
    String? agcMode,
    String? alcMode,
  }) {
    dsVVA1 ??= state.dsVVA1;
    dsVVA4 ??= state.dsVVA4;
    dsVVA5 ??= state.dsVVA5;
    dsSlope1 ??= state.dsSlope1;
    dsSlope3 ??= state.dsSlope3;
    dsSlope4 ??= state.dsSlope4;
    usVCA1 ??= state.usVCA1;
    usVCA2 ??= state.usVCA2;
    usVCA3 ??= state.usVCA3;
    usVCA4 ??= state.usVCA4;
    eREQ ??= state.eREQ;
    returnIngressSetting2 ??= state.returnIngressSetting2;
    returnIngressSetting3 ??= state.returnIngressSetting3;
    returnIngressSetting4 ??= state.returnIngressSetting4;
    tgcCableLength ??= tgcCableLength;
    splitOption ??= state.splitOption;
    firstChannelLoadingFrequency ??= state.firstChannelLoadingFrequency;
    firstChannelLoadingLevel ??= state.firstChannelLoadingLevel;
    lastChannelLoadingFrequency ??= state.lastChannelLoadingFrequency;
    lastChannelLoadingLevel ??= state.lastChannelLoadingLevel;
    pilotFrequencyMode ??= state.pilotFrequencyMode;
    pilotFrequency1 ??= state.pilotFrequency1;
    pilotFrequency2 ??= state.pilotFrequency2;
    agcMode ??= state.agcMode;
    alcMode ??= state.alcMode;

    bool isValid = false;

    if (pilotFrequencyMode == '0') {
      isValid = Formz.validate([
        dsVVA1,
        dsVVA4,
        dsVVA5,
        dsSlope1,
        dsSlope3,
        dsSlope4,
        usVCA1,
        usVCA2,
        usVCA3,
        usVCA4,
        eREQ,
        firstChannelLoadingFrequency,
        firstChannelLoadingLevel,
        lastChannelLoadingFrequency,
        lastChannelLoadingLevel,
      ]);
    } else if (pilotFrequencyMode == '1') {
      isValid = Formz.validate([
        dsVVA1,
        dsVVA4,
        dsVVA5,
        dsSlope1,
        dsSlope3,
        dsSlope4,
        usVCA1,
        usVCA2,
        usVCA3,
        usVCA4,
        eREQ,
        firstChannelLoadingFrequency,
        firstChannelLoadingLevel,
        lastChannelLoadingFrequency,
        lastChannelLoadingLevel,
        pilotFrequency1,
        pilotFrequency2,
      ]);
    } else {
      isValid = true;
    }

    if (isValid) {
      if (dsVVA1.value != state.initialValues[DataKey.dsVVA1] ||
          dsVVA4.value != state.initialValues[DataKey.dsVVA4] ||
          dsVVA5.value != state.initialValues[DataKey.dsVVA5] ||
          dsSlope1.value != state.initialValues[DataKey.dsSlope1] ||
          dsSlope3.value != state.initialValues[DataKey.dsSlope3] ||
          dsSlope4.value != state.initialValues[DataKey.dsSlope4] ||
          usVCA1.value != state.initialValues[DataKey.usVCA1] ||
          usVCA2.value != state.initialValues[DataKey.usVCA2] ||
          usVCA3.value != state.initialValues[DataKey.usVCA3] ||
          usVCA4.value != state.initialValues[DataKey.usVCA4] ||
          eREQ.value != state.initialValues[DataKey.eREQ] ||
          returnIngressSetting2 !=
              state.initialValues[DataKey.ingressSetting2] ||
          returnIngressSetting3 !=
              state.initialValues[DataKey.ingressSetting3] ||
          returnIngressSetting4 !=
              state.initialValues[DataKey.ingressSetting4] ||
          // usTGC != state.initialValues[DataKey.usTGC] ||
          splitOption != state.initialValues[DataKey.splitOption] ||
          firstChannelLoadingFrequency.value !=
              state.initialValues[DataKey.firstChannelLoadingFrequency] ||
          firstChannelLoadingLevel.value !=
              state.initialValues[DataKey.firstChannelLoadingLevel] ||
          lastChannelLoadingFrequency.value !=
              state.initialValues[DataKey.lastChannelLoadingFrequency] ||
          lastChannelLoadingLevel.value !=
              state.initialValues[DataKey.lastChannelLoadingLevel] ||
          pilotFrequencyMode !=
              state.initialValues[DataKey.pilotFrequencyMode] ||
          pilotFrequency1.value !=
              state.initialValues[DataKey.pilotFrequency1] ||
          pilotFrequency2.value !=
              state.initialValues[DataKey.pilotFrequency2] ||
          agcMode != state.initialValues[DataKey.agcMode] ||
          alcMode != state.initialValues[DataKey.alcMode]) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18GraphModuleState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];

    if (state.dsVVA1.value != state.initialValues[DataKey.dsVVA1]) {
      bool resultOfSetDSVVA1 =
          await _amp18Repository.set1p8GDSVVA1(state.dsVVA1.value);

      settingResult.add('${DataKey.dsVVA1.name},$resultOfSetDSVVA1');
    }

    if (state.dsVVA4.value != state.initialValues[DataKey.dsVVA4]) {
      bool resultOfSetDSVVA4 =
          await _amp18Repository.set1p8GDSVVA4(state.dsVVA4.value);

      settingResult.add('${DataKey.dsVVA4.name},$resultOfSetDSVVA4');
    }

    if (state.dsVVA5.value != state.initialValues[DataKey.dsVVA5]) {
      bool resultOfSetDSVVA5 =
          await _amp18Repository.set1p8GDSVVA5(state.dsVVA5.value);

      settingResult.add('${DataKey.dsVVA5.name},$resultOfSetDSVVA5');
    }

    if (state.dsSlope1.value != state.initialValues[DataKey.dsSlope1]) {
      bool resultOfSetDSSlope1 =
          await _amp18Repository.set1p8GDSSlope1(state.dsSlope1.value);

      settingResult.add('${DataKey.dsSlope1.name},$resultOfSetDSSlope1');
    }

    if (state.dsSlope3.value != state.initialValues[DataKey.dsSlope3]) {
      bool resultOfSetDSSlope3 =
          await _amp18Repository.set1p8GDSSlope3(state.dsSlope3.value);

      settingResult.add('${DataKey.dsSlope3.name},$resultOfSetDSSlope3');
    }

    if (state.dsSlope4.value != state.initialValues[DataKey.dsSlope4]) {
      bool resultOfSetDSSlope4 =
          await _amp18Repository.set1p8GDSSlope4(state.dsSlope4.value);

      settingResult.add('${DataKey.dsSlope4.name},$resultOfSetDSSlope4');
    }

    if (state.usVCA1.value != state.initialValues[DataKey.usVCA1]) {
      bool resultOfSetUSVCA1Cmd =
          await _amp18Repository.set1p8GUSVCA1(state.usVCA1.value);

      settingResult.add('${DataKey.usVCA1.name},$resultOfSetUSVCA1Cmd');
    }

    if (state.usVCA2.value != state.initialValues[DataKey.usVCA2]) {
      bool resultOfSetUSVCA2 =
          await _amp18Repository.set1p8GUSVCA2(state.usVCA2.value);

      settingResult.add('${DataKey.usVCA2.name},$resultOfSetUSVCA2');
    }

    if (state.usVCA3.value != state.initialValues[DataKey.usVCA3]) {
      bool resultOfSetUSVCA3 =
          await _amp18Repository.set1p8GUSVCA3(state.usVCA3.value);

      settingResult.add('${DataKey.usVCA3.name},$resultOfSetUSVCA3');
    }

    if (state.usVCA4.value != state.initialValues[DataKey.usVCA4]) {
      bool resultOfSetUSVCA4 =
          await _amp18Repository.set1p8GUSVCA4(state.usVCA4.value);

      settingResult.add('${DataKey.usVCA4.name},$resultOfSetUSVCA4');
    }

    if (state.eREQ.value != state.initialValues[DataKey.eREQ]) {
      bool resultOfSetEREQ =
          await _amp18Repository.set1p8GEREQ(state.eREQ.value);

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

    if (state.tgcCableLength != state.initialValues[DataKey.tgcCableLength]) {
      bool resultOfSetTGCCableLength =
          await _amp18Repository.set1p8GTGCCableLength(state.tgcCableLength);

      settingResult
          .add('${DataKey.tgcCableLength.name},$resultOfSetTGCCableLength');
    }

    // if (state.usTGC != state.initialValues[DataKey.usTGC]) {
    //   bool resultOfSetUSTGC = await _amp18Repository.set1p8USTGC(state.usTGC);

    //   settingResult.add('${DataKey.usTGC.name},$resultOfSetUSTGC');
    // }

    if (state.splitOption != state.initialValues[DataKey.splitOption]) {
      bool resultOfSetSplitOption =
          await _amp18Repository.set1p8GSplitOption(state.splitOption);

      settingResult.add('${DataKey.splitOption.name},$resultOfSetSplitOption');
    }

    if (state.pilotFrequencyMode !=
        state.initialValues[DataKey.pilotFrequencyMode]) {
      bool resultOfSetPilotFrequencyMode = await _amp18Repository
          .set1p8GPilotFrequencyMode(state.pilotFrequencyMode);

      settingResult.add(
          '${DataKey.pilotFrequencyMode.name},$resultOfSetPilotFrequencyMode');
    }

    if (state.firstChannelLoadingFrequency.value !=
        state.initialValues[DataKey.firstChannelLoadingFrequency]) {
      bool resultOfSetFirstChannelLoadingFrequency =
          await _amp18Repository.set1p8GFirstChannelLoadingFrequency(
              state.firstChannelLoadingFrequency.value);

      settingResult.add(
          '${DataKey.firstChannelLoadingFrequency.name},$resultOfSetFirstChannelLoadingFrequency');
    }

    if (state.firstChannelLoadingLevel.value !=
        state.initialValues[DataKey.firstChannelLoadingLevel]) {
      bool resultOfSetFirstChannelLoadingLevel =
          await _amp18Repository.set1p8GFirstChannelLoadingLevel(
              state.firstChannelLoadingLevel.value);

      settingResult.add(
          '${DataKey.firstChannelLoadingLevel.name},$resultOfSetFirstChannelLoadingLevel');
    }

    if (state.lastChannelLoadingFrequency.value !=
        state.initialValues[DataKey.lastChannelLoadingFrequency]) {
      bool resultOfSetLastChannelLoadingFrequency =
          await _amp18Repository.set1p8GLastChannelLoadingFrequency(
              state.lastChannelLoadingFrequency.value);

      settingResult.add(
          '${DataKey.lastChannelLoadingFrequency.name},$resultOfSetLastChannelLoadingFrequency');
    }

    if (state.lastChannelLoadingLevel.value !=
        state.initialValues[DataKey.lastChannelLoadingLevel]) {
      bool resultOfSetLastChannelLoadingLevel = await _amp18Repository
          .set1p8GLastChannelLoadingLevel(state.lastChannelLoadingLevel.value);

      settingResult.add(
          '${DataKey.lastChannelLoadingLevel.name},$resultOfSetLastChannelLoadingLevel');
    }

    if (state.pilotFrequency1.value !=
        state.initialValues[DataKey.pilotFrequency1]) {
      bool resultOfSetPilotFrequency1 = await _amp18Repository
          .set1p8GPilotFrequency1(state.pilotFrequency1.value);

      settingResult
          .add('${DataKey.pilotFrequency1.name},$resultOfSetPilotFrequency1');
    }

    if (state.pilotFrequency2.value !=
        state.initialValues[DataKey.pilotFrequency2]) {
      bool resultOfSetPilotFrequency2 = await _amp18Repository
          .set1p8GPilotFrequency2(state.pilotFrequency2.value);

      settingResult
          .add('${DataKey.pilotFrequency2.name},$resultOfSetPilotFrequency2');
    }

    if (state.agcMode != state.initialValues[DataKey.agcMode]) {
      bool resultOfSetForwardAGCMode =
          await _amp18Repository.set1p8GForwardAGCMode(state.agcMode);

      settingResult.add('${DataKey.agcMode.name},$resultOfSetForwardAGCMode');
    }

    if (state.alcMode != state.initialValues[DataKey.alcMode]) {
      bool resultOfSetALCMode =
          await _amp18Repository.set1p8GALCMode(state.alcMode);

      // 20240516 不顯示設定的結果, 之後不具備 ALC 功能
      // settingResult.add('${DataKey.alcMode.name},$resultOfSetALCMode');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      isInitialize: true,
      tappedSet: const {},
      initialValues: _amp18Repository.characteristicDataCache,
    ));
  }

  void _onCurrentForwardCEQPeriodicUpdateRequested(
    CurrentForwardCEQPeriodicUpdateRequested event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      print('CurrentForwardCEQUpdate timer: ${timer.tick}');

      add(const CurrentForwardCEQUpdated());
    });

    print('CurrentForwardCEQUpdate started');
  }

  Future<void> _onCurrentForwardCEQUpdated(
    CurrentForwardCEQUpdated event,
    Emitter<Setting18GraphModuleState> emit,
  ) async {
    // 一開始插著 1.8 模組, app 在其他頁面, 換成 1.2, 切到 setting 頁面
    // forwardCEQType 狀態  1.8 -> 1.2

    // 一開始插著 1.2 模組, app 在其他頁面, 換成 1.8, 切到 setting 頁面
    // forwardCEQType 狀態  1.2 -> 1.8

    // 一開始插著 1.2 or 1.8 模組, app 在其他頁面, 不插模組, 切到 setting 頁面
    // forwardCEQType 狀態  1.2 or 1.8 不變

    // 一開始沒有插模組, app 在其他頁面, 換成 1.8, 切到 setting 頁面
    // forwardCEQType 狀態  N/A -> 1.8

    // 一開始沒有插模組, app 在其他頁面, 換成 1.2, 切到 setting 頁面
    // forwardCEQType 狀態  N/A -> 1.2

    // app 在 setting 頁面不換頁, 一開始插著 1.8 模組,  換成 1.2,
    // forwardCEQType 狀態  1.8 -> 1.2 (換的過程中沒有插的狀態是 N/A, 就不改變)

    // app 在 setting 頁面不換頁, 一開始插著 1.2 模組,  換成 1.8,
    // forwardCEQType 狀態  1.2 -> 1.8 (換的過程中沒有插的狀態是 N/A, 就不改變)

    emit(state.copyWith(
      forwardCEQStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> resultOf1p8G2 = await _amp18Repository.requestCommand1p8G2();

    if (resultOf1p8G2[0]) {
      Map<DataKey, String> characteristicData = resultOf1p8G2[1];

      String currentCEQType = getCEQTypeFromForwardCEQIndex(
          characteristicData[DataKey.currentForwardCEQIndex] ?? '255');

      if (currentCEQType != 'N/A') {
        bool isForwardCEQIndexChanged =
            ForwardCEQFlag.forwardCEQType != currentCEQType;

        if (isForwardCEQIndexChanged) {
          ForwardCEQFlag.forwardCEQType = currentCEQType;

          emit(state.copyWith(
            forwardCEQStatus: FormStatus.requestSuccess,
            isInitialize: false,
            isForwardCEQIndexChanged: isForwardCEQIndexChanged,
          ));
        }
      }
    }
  }

  Future<void> _onCurrentForwardCEQPeriodicUpdateCanceled(
    CurrentForwardCEQPeriodicUpdateCanceled event,
    Emitter<Setting18GraphModuleState> emit,
  ) async {
    if (_timer != null) {
      _timer!.cancel();
      print('CurrentForwardCEQUpdate timer is canceled');
    }
  }

  @override
  Future<void> close() {
    if (_timer != null) {
      _timer!.cancel();

      print('CurrentForwardCEQUpdate timer is canceled due to bloc closing.');
    }

    return super.close();
  }
}

import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/config_api.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'setting18_config_edit_event.dart';
part 'setting18_config_edit_state.dart';

class Setting18ConfigEditBloc
    extends Bloc<Setting18ConfigEditEvent, Setting18ConfigEditState> {
  Setting18ConfigEditBloc({
    required Amp18Repository amp18Repository,
    required String selectedPartId,
    required bool isShortcut,
  })  : _amp18Repository = amp18Repository,
        _selectedPartId = selectedPartId,
        _isShortcut = isShortcut,
        _configApi = ConfigApi(),
        super(const Setting18ConfigEditState()) {
    on<ConfigIntitialized>(_onConfigIntitialized);
    on<ConfigSaved>(_onConfigSaved);
    on<ConfigSavedAndSubmitted>(_onConfigSavedAndSubmitted);
    on<FirstChannelLoadingFrequencyChanged>(
        _onFirstChannelLoadingFrequencyChanged);
    on<FirstChannelLoadingLevelChanged>(_onFirstChannelLoadingLevelChanged);
    on<LastChannelLoadingFrequencyChanged>(
        _onLastChannelLoadingFrequencyChanged);
    on<LastChannelLoadingLevelChanged>(_onLastChannelLoadingLevelChanged);

    add(const ConfigIntitialized());
  }

  final Amp18Repository _amp18Repository;
  final String _selectedPartId;
  final ConfigApi _configApi;
  final bool _isShortcut;

  Future<void> _onConfigIntitialized(
    ConfigIntitialized event,
    Emitter<Setting18ConfigEditState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
    ));

    List<dynamic> result = _configApi.getConfigByPartId(_selectedPartId);

    if (result[0]) {
      Config config = result[1];
      IntegerInput firstChannelLoadingFrequency =
          IntegerInput.dirty(config.firstChannelLoadingFrequency);
      FloatPointInput firstChannelLoadingLevel =
          FloatPointInput.dirty(config.firstChannelLoadingLevel);
      IntegerInput lastChannelLoadingFrequency =
          IntegerInput.dirty(config.lastChannelLoadingFrequency);
      FloatPointInput lastChannelLoadingLevel =
          FloatPointInput.dirty(config.lastChannelLoadingLevel);

      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        saveStatus: SubmissionStatus.none,
        settingStatus: SubmissionStatus.none,
        selectedPartId: _selectedPartId,
        isShortcut: _isShortcut,
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
        isInitialize: true,
        initialValues: {
          DataKey.firstChannelLoadingFrequency:
              config.firstChannelLoadingFrequency,
          DataKey.firstChannelLoadingLevel: config.firstChannelLoadingLevel,
          DataKey.lastChannelLoadingFrequency:
              config.lastChannelLoadingFrequency,
          DataKey.lastChannelLoadingLevel: config.lastChannelLoadingLevel,
        },
        enableSubmission: _isEnabledSubmission(
          firstChannelLoadingFrequency: firstChannelLoadingFrequency,
          firstChannelLoadingLevel: firstChannelLoadingLevel,
          lastChannelLoadingFrequency: lastChannelLoadingFrequency,
          lastChannelLoadingLevel: lastChannelLoadingLevel,
        ),
      ));
    } else {
      Map<DataKey, String> characteristicDataCache =
          _amp18Repository.characteristicDataCache;

      String partId = characteristicDataCache[DataKey.partId] ?? '';
      String initFirstChannelLoadingFrequency =
          characteristicDataCache[DataKey.firstChannelLoadingFrequency] ?? '';
      String initFirstChannelLoadingLevel =
          characteristicDataCache[DataKey.firstChannelLoadingLevel] ?? '';
      String initLastChannelLoadingFrequency =
          characteristicDataCache[DataKey.lastChannelLoadingFrequency] ?? '';
      String initLastChannelLoadingLevel =
          characteristicDataCache[DataKey.lastChannelLoadingLevel] ?? '';

      // 如果 config 不存在而且 partId == _selectedPartId,
      // 則寫入 device 上的參數值到手機端資料庫, 並使用 device 上的參數值為初始值
      if (partId == _selectedPartId) {
        await _configApi.addConfigByPartId(
          partId: _selectedPartId,
          firstChannelLoadingFrequency: initFirstChannelLoadingFrequency,
          firstChannelLoadingLevel: initFirstChannelLoadingLevel,
          lastChannelLoadingFrequency: initLastChannelLoadingFrequency,
          lastChannelLoadingLevel: initLastChannelLoadingLevel,
        );

        IntegerInput firstChannelLoadingFrequency =
            IntegerInput.dirty(initFirstChannelLoadingFrequency);
        FloatPointInput firstChannelLoadingLevel =
            FloatPointInput.dirty(initFirstChannelLoadingLevel);
        IntegerInput lastChannelLoadingFrequency =
            IntegerInput.dirty(initLastChannelLoadingFrequency);
        FloatPointInput lastChannelLoadingLevel =
            FloatPointInput.dirty(initLastChannelLoadingLevel);

        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          saveStatus: SubmissionStatus.none,
          settingStatus: SubmissionStatus.none,
          selectedPartId: _selectedPartId,
          firstChannelLoadingFrequency: firstChannelLoadingFrequency,
          firstChannelLoadingLevel: firstChannelLoadingLevel,
          lastChannelLoadingFrequency: lastChannelLoadingFrequency,
          lastChannelLoadingLevel: lastChannelLoadingLevel,
          isInitialize: true,
          initialValues: {
            DataKey.firstChannelLoadingFrequency:
                initFirstChannelLoadingFrequency,
            DataKey.firstChannelLoadingLevel: initFirstChannelLoadingLevel,
            DataKey.lastChannelLoadingFrequency:
                initLastChannelLoadingFrequency,
            DataKey.lastChannelLoadingLevel: initLastChannelLoadingLevel,
          },
          enableSubmission: _isEnabledSubmission(
            firstChannelLoadingFrequency: firstChannelLoadingFrequency,
            firstChannelLoadingLevel: firstChannelLoadingLevel,
            lastChannelLoadingFrequency: lastChannelLoadingFrequency,
            lastChannelLoadingLevel: lastChannelLoadingLevel,
          ),
        ));
      } else {
        // 如果 config 不存在而且 partId != _selectedPartId,
        // 則初始化為空值

        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          saveStatus: SubmissionStatus.none,
          settingStatus: SubmissionStatus.none,
          selectedPartId: _selectedPartId,
          isInitialize: true,
          initialValues: {
            DataKey.firstChannelLoadingFrequency: '',
            DataKey.firstChannelLoadingLevel: '',
            DataKey.lastChannelLoadingFrequency: '',
            DataKey.lastChannelLoadingLevel: '',
          },
          enableSubmission: _isEnabledSubmission(
            firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
            firstChannelLoadingLevel: state.firstChannelLoadingLevel,
            lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
            lastChannelLoadingLevel: state.lastChannelLoadingLevel,
          ),
        ));
      }
    }
  }

  void _onFirstChannelLoadingFrequencyChanged(
    FirstChannelLoadingFrequencyChanged event,
    Emitter<Setting18ConfigEditState> emit,
  ) {
    IntegerInput firstChannelLoadingFrequency =
        IntegerInput.dirty(event.firstChannelLoadingFrequency);
    emit(state.copyWith(
      formStatus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
      ),
    ));
  }

  void _onFirstChannelLoadingLevelChanged(
    FirstChannelLoadingLevelChanged event,
    Emitter<Setting18ConfigEditState> emit,
  ) {
    FloatPointInput firstChannelLoadingLevel =
        FloatPointInput.dirty(event.firstChannelLoadingLevel);
    emit(state.copyWith(
      formStatus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
      ),
    ));
  }

  void _onLastChannelLoadingFrequencyChanged(
    LastChannelLoadingFrequencyChanged event,
    Emitter<Setting18ConfigEditState> emit,
  ) {
    IntegerInput lastChannelLoadingFrequency =
        IntegerInput.dirty(event.lastChannelLoadingFrequency);
    emit(state.copyWith(
      formStatus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
      ),
    ));
  }

  void _onLastChannelLoadingLevelChanged(
    LastChannelLoadingLevelChanged event,
    Emitter<Setting18ConfigEditState> emit,
  ) {
    FloatPointInput lastChannelLoadingLevel =
        FloatPointInput.dirty(event.lastChannelLoadingLevel);
    emit(state.copyWith(
      formStatus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
      ),
    ));
  }

  Future<void> _onConfigSaved(
    ConfigSaved event,
    Emitter<Setting18ConfigEditState> emit,
  ) async {
    emit(state.copyWith(
      saveStatus: SubmissionStatus.submissionInProgress,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
    ));

    await _configApi.addConfigByPartId(
      partId: _selectedPartId,
      firstChannelLoadingFrequency: state.firstChannelLoadingFrequency.value,
      firstChannelLoadingLevel: state.firstChannelLoadingLevel.value,
      lastChannelLoadingFrequency: state.lastChannelLoadingFrequency.value,
      lastChannelLoadingLevel: state.lastChannelLoadingLevel.value,
    );

    emit(state.copyWith(
      saveStatus: SubmissionStatus.submissionSuccess,
    ));
  }

  Future<void> _onConfigSavedAndSubmitted(
    ConfigSavedAndSubmitted event,
    Emitter<Setting18ConfigEditState> emit,
  ) async {
    emit(state.copyWith(
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.submissionInProgress,
      isInitialize: false,
    ));

    List<String> settingResult = [];

    await _configApi.addConfigByPartId(
      partId: _selectedPartId,
      firstChannelLoadingFrequency: state.firstChannelLoadingFrequency.value,
      firstChannelLoadingLevel: state.firstChannelLoadingLevel.value,
      lastChannelLoadingFrequency: state.lastChannelLoadingFrequency.value,
      lastChannelLoadingLevel: state.lastChannelLoadingLevel.value,
    );

    bool resultOfSetPilotFrequencyMode = await _amp18Repository
        .set1p8GPilotFrequencyMode('0'); // Full mode (auto mode)

    settingResult.add(
        '${DataKey.pilotFrequencyMode.name},$resultOfSetPilotFrequencyMode');

    if (state.firstChannelLoadingFrequency.value.isNotEmpty) {
      bool resultOfSetFirstChannelLoadingFrequency =
          await _amp18Repository.set1p8GFirstChannelLoadingFrequency(
              state.firstChannelLoadingFrequency.value);

      settingResult.add(
          '${DataKey.firstChannelLoadingFrequency.name},$resultOfSetFirstChannelLoadingFrequency');
    }

    if (state.firstChannelLoadingLevel.value.isNotEmpty) {
      bool resultOfSetFirstChannelLoadingLevel =
          await _amp18Repository.set1p8GFirstChannelLoadingLevel(
              state.firstChannelLoadingLevel.value);

      settingResult.add(
          '${DataKey.firstChannelLoadingLevel.name},$resultOfSetFirstChannelLoadingLevel');
    }

    if (state.lastChannelLoadingFrequency.value.isNotEmpty) {
      bool resultOfSetLastChannelLoadingFrequency =
          await _amp18Repository.set1p8GLastChannelLoadingFrequency(
              state.lastChannelLoadingFrequency.value);

      settingResult.add(
          '${DataKey.lastChannelLoadingFrequency.name},$resultOfSetLastChannelLoadingFrequency');
    }

    if (state.lastChannelLoadingLevel.value.isNotEmpty) {
      bool resultOfSetLastChannelLoadingLevel = await _amp18Repository
          .set1p8GLastChannelLoadingLevel(state.lastChannelLoadingLevel.value);

      settingResult.add(
          '${DataKey.lastChannelLoadingLevel.name},$resultOfSetLastChannelLoadingLevel');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      settingStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
    ));
  }

  bool _isEnabledSubmission({
    required IntegerInput firstChannelLoadingFrequency,
    required FloatPointInput firstChannelLoadingLevel,
    required IntegerInput lastChannelLoadingFrequency,
    required FloatPointInput lastChannelLoadingLevel,
  }) {
    bool isValid = Formz.validate([
      firstChannelLoadingFrequency,
      firstChannelLoadingLevel,
      lastChannelLoadingFrequency,
      lastChannelLoadingLevel,
    ]);

    if (isValid) {
      if (firstChannelLoadingFrequency.value.isNotEmpty ||
          firstChannelLoadingLevel.value.isNotEmpty ||
          lastChannelLoadingFrequency.value.isNotEmpty ||
          lastChannelLoadingLevel.value.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

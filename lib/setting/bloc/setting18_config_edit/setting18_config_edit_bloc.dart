import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/config_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_config_edit_event.dart';
part 'setting18_config_edit_state.dart';

class Setting18ConfigEditBloc
    extends Bloc<Setting18ConfigEditEvent, Setting18ConfigEditState> {
  Setting18ConfigEditBloc({
    required Amp18Repository amp18Repository,
    required String selectedPartId,
  })  : _amp18Repository = amp18Repository,
        _selectedPartId = selectedPartId,
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

  Future<void> _onConfigIntitialized(
    ConfigIntitialized event,
    Emitter<Setting18ConfigEditState> emit,
  ) async {
    emit(state.copyWith(
        formStatus: FormStatus.requestInProgress,
        saveStatus: SubmissionStatus.none,
        settingStatus: SubmissionStatus.none));

    List<dynamic> result = _configApi.getConfigByPartId(_selectedPartId);

    if (result[0]) {
      Config config = result[1];
      emit(state.copyWith(
        formStatus: FormStatus.requestSuccess,
        saveStatus: SubmissionStatus.none,
        settingStatus: SubmissionStatus.none,
        selectedPartId: _selectedPartId,
        firstChannelLoadingFrequency: config.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: config.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: config.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: config.lastChannelLoadingLevel,
        isInitialize: true,
        initialValues: {
          DataKey.firstChannelLoadingFrequency:
              config.firstChannelLoadingFrequency,
          DataKey.firstChannelLoadingLevel: config.firstChannelLoadingFrequency,
          DataKey.lastChannelLoadingFrequency:
              config.firstChannelLoadingFrequency,
          DataKey.lastChannelLoadingLevel: config.firstChannelLoadingFrequency,
        },
      ));
    } else {
      Map<DataKey, String> characteristicDataCache =
          _amp18Repository.characteristicDataCache;

      String partId = characteristicDataCache[DataKey.partId] ?? '';
      String firstChannelLoadingFrequency =
          characteristicDataCache[DataKey.firstChannelLoadingFrequency] ?? '';
      String lastChannelLoadingFrequency =
          characteristicDataCache[DataKey.lastChannelLoadingFrequency] ?? '';
      String firstChannelLoadingLevel =
          characteristicDataCache[DataKey.firstChannelLoadingLevel] ?? '';
      String lastChannelLoadingLevel =
          characteristicDataCache[DataKey.lastChannelLoadingLevel] ?? '';

      // 如果 config 不存在, 則寫入 device 上的參數值到手機端資料庫

      if (partId == _selectedPartId) {
        await _configApi.addConfigByPartId(
          partId: _selectedPartId,
          firstChannelLoadingFrequency: firstChannelLoadingFrequency,
          firstChannelLoadingLevel: firstChannelLoadingLevel,
          lastChannelLoadingFrequency: lastChannelLoadingFrequency,
          lastChannelLoadingLevel: lastChannelLoadingLevel,
        );

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
            DataKey.firstChannelLoadingFrequency: firstChannelLoadingFrequency,
            DataKey.firstChannelLoadingLevel: firstChannelLoadingFrequency,
            DataKey.lastChannelLoadingFrequency: firstChannelLoadingFrequency,
            DataKey.lastChannelLoadingLevel: firstChannelLoadingFrequency,
          },
        ));
      } else {
        emit(state.copyWith(
          formStatus: FormStatus.requestSuccess,
          saveStatus: SubmissionStatus.none,
          settingStatus: SubmissionStatus.none,
          selectedPartId: _selectedPartId,
          firstChannelLoadingFrequency: '',
          firstChannelLoadingLevel: '',
          lastChannelLoadingFrequency: '',
          lastChannelLoadingLevel: '',
          isInitialize: true,
          initialValues: {
            DataKey.firstChannelLoadingFrequency: '',
            DataKey.firstChannelLoadingLevel: '',
            DataKey.lastChannelLoadingFrequency: '',
            DataKey.lastChannelLoadingLevel: '',
          },
        ));
      }
    }
  }

  void _onFirstChannelLoadingFrequencyChanged(
    FirstChannelLoadingFrequencyChanged event,
    Emitter<Setting18ConfigEditState> emit,
  ) {
    emit(state.copyWith(
      formStatus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      firstChannelLoadingFrequency: event.firstChannelLoadingFrequency,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: event.firstChannelLoadingFrequency,
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
    emit(state.copyWith(
      formStatus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      firstChannelLoadingLevel: event.firstChannelLoadingLevel,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: event.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
      ),
    ));
  }

  void _onLastChannelLoadingFrequencyChanged(
    LastChannelLoadingFrequencyChanged event,
    Emitter<Setting18ConfigEditState> emit,
  ) {
    emit(state.copyWith(
      formStatus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      lastChannelLoadingFrequency: event.lastChannelLoadingFrequency,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: event.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
      ),
    ));
  }

  void _onLastChannelLoadingLevelChanged(
    LastChannelLoadingLevelChanged event,
    Emitter<Setting18ConfigEditState> emit,
  ) {
    emit(state.copyWith(
      formStatus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      lastChannelLoadingLevel: event.lastChannelLoadingLevel,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: event.lastChannelLoadingLevel,
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
      firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
      firstChannelLoadingLevel: state.firstChannelLoadingLevel,
      lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
      lastChannelLoadingLevel: state.lastChannelLoadingLevel,
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
      firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
      firstChannelLoadingLevel: state.firstChannelLoadingLevel,
      lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
      lastChannelLoadingLevel: state.lastChannelLoadingLevel,
    );

    bool resultOfSetFirstChannelLoadingFrequency =
        await _amp18Repository.set1p8GFirstChannelLoadingFrequency(
            state.firstChannelLoadingFrequency);

    settingResult.add(
        '${DataKey.firstChannelLoadingFrequency.name},$resultOfSetFirstChannelLoadingFrequency');

    bool resultOfSetFirstChannelLoadingLevel = await _amp18Repository
        .set1p8GFirstChannelLoadingLevel(state.firstChannelLoadingLevel);

    settingResult.add(
        '${DataKey.firstChannelLoadingLevel.name},$resultOfSetFirstChannelLoadingLevel');

    bool resultOfSetLastChannelLoadingFrequency = await _amp18Repository
        .set1p8GLastChannelLoadingFrequency(state.lastChannelLoadingFrequency);

    settingResult.add(
        '${DataKey.lastChannelLoadingFrequency.name},$resultOfSetLastChannelLoadingFrequency');

    bool resultOfSetLastChannelLoadingLevel = await _amp18Repository
        .set1p8GLastChannelLoadingLevel(state.lastChannelLoadingLevel);

    settingResult.add(
        '${DataKey.lastChannelLoadingLevel.name},$resultOfSetLastChannelLoadingLevel');

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      settingStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
    ));
  }

  bool _isEnabledSubmission({
    required String firstChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingFrequency,
    required String lastChannelLoadingLevel,
  }) {
    if (firstChannelLoadingFrequency.isNotEmpty &&
        firstChannelLoadingLevel.isNotEmpty &&
        lastChannelLoadingFrequency.isNotEmpty &&
        lastChannelLoadingLevel.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}

import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'setting18_config_edit_event.dart';
part 'setting18_config_edit_state.dart';

class Setting18ConfigEditBloc
    extends Bloc<Setting18ConfigEditEvent, Setting18ConfigEditState> {
  Setting18ConfigEditBloc({
    required Amp18Repository amp18Repository,
    required ConfigRepository configRepository,
    required String groupId,
    Config? config,
  })  : _amp18Repository = amp18Repository,
        _configRepository = configRepository,
        _config = config,
        _groupId = groupId,
        super(const Setting18ConfigEditState()) {
    on<ConfigIntitialized>(_onConfigIntitialized);
    on<ConfigAdded>(_onConfigAdded);
    on<ConfigSubmitted>(_onConfigSubmitted);
    on<ConfigUpdated>(_onConfigUpdated);
    // on<QRCodeDataScanned>(_onQRCodeDataScanned);
    // on<QRCodeDataGenerated>(_onQRCodeDataGenerated);
    on<NameChanged>(_onNameChanged);
    on<SplitOptionChanged>(_onSplitOptionChanged);
    on<FirstChannelLoadingFrequencyChanged>(
        _onFirstChannelLoadingFrequencyChanged);
    on<FirstChannelLoadingLevelChanged>(_onFirstChannelLoadingLevelChanged);
    on<LastChannelLoadingFrequencyChanged>(
        _onLastChannelLoadingFrequencyChanged);
    on<LastChannelLoadingLevelChanged>(_onLastChannelLoadingLevelChanged);

    add(const ConfigIntitialized());
  }

  final Amp18Repository _amp18Repository;
  final ConfigRepository _configRepository;
  final Config? _config;
  final String _groupId;

  Future<void> _onConfigIntitialized(
    ConfigIntitialized event,
    Emitter<Setting18ConfigEditState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
      // encodeStaus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
    ));

    // int id = await _configRepository.getConfigAutoIncrementId();

    String groupId = _groupId;
    String rawName = '';
    String splitOption = '1';
    String rawFirstChannelLoadingFrequency = '258';
    String rawFirstChannelLoadingLevel = '34.0';
    String rawLastChannelLoadingFrequency = '1794';
    String rawLastChannelLoadingLevel = '51.1';

    if (_config != null) {
      rawName = _config!.name;
      splitOption = _config!.splitOption;
      rawFirstChannelLoadingFrequency = _config!.firstChannelLoadingFrequency;
      rawFirstChannelLoadingLevel = _config!.firstChannelLoadingLevel;
      rawLastChannelLoadingFrequency = _config!.lastChannelLoadingFrequency;
      rawLastChannelLoadingLevel = _config!.lastChannelLoadingLevel;
    } else {
      int newId = _configRepository.getEmptyNameId(groupId: groupId) ?? -1;
      rawName = 'Config$newId';
    }

    NameInput name = NameInput.dirty(rawName);
    IntegerInput firstChannelLoadingFrequency =
        rawFirstChannelLoadingFrequency.isNotEmpty
            ? IntegerInput.dirty(rawFirstChannelLoadingFrequency)
            : const IntegerInput.pure();
    FloatPointInput firstChannelLoadingLevel =
        rawFirstChannelLoadingLevel.isNotEmpty
            ? FloatPointInput.dirty(rawFirstChannelLoadingLevel)
            : const FloatPointInput.pure();
    IntegerInput lastChannelLoadingFrequency =
        rawLastChannelLoadingFrequency.isNotEmpty
            ? IntegerInput.dirty(rawLastChannelLoadingFrequency)
            : const IntegerInput.pure();
    FloatPointInput lastChannelLoadingLevel =
        rawLastChannelLoadingLevel.isNotEmpty
            ? FloatPointInput.dirty(rawLastChannelLoadingLevel)
            : const FloatPointInput.pure();

    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      groupId: groupId,
      name: name,
      splitOption: splitOption,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      isInitialize: true,
      enableSubmission: _isEnabledSubmission(
        name: name,
        splitOption: splitOption,
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
      ),
    ));
  }

  // void _onQRCodeDataScanned(
  //   QRCodeDataScanned event,
  //   Emitter<Setting18ConfigEditState> emit,
  // ) {
  //   emit(state.copyWith(
  //     isInitialize: false,
  //     encodeStaus: FormStatus.none,
  //   ));
  //   List<String> raws = event.rawData.split(',');

  //   if (raws.length == 4) {
  //     IntegerInput firstChannelLoadingFrequency = raws[0].isNotEmpty
  //         ? IntegerInput.dirty(raws[0])
  //         : const IntegerInput.pure();
  //     FloatPointInput firstChannelLoadingLevel = raws[1].isNotEmpty
  //         ? FloatPointInput.dirty(raws[1])
  //         : const FloatPointInput.pure();
  //     IntegerInput lastChannelLoadingFrequency = raws[2].isNotEmpty
  //         ? IntegerInput.dirty(raws[2])
  //         : const IntegerInput.pure();
  //     FloatPointInput lastChannelLoadingLevel = raws[3].isNotEmpty
  //         ? FloatPointInput.dirty(raws[3])
  //         : const FloatPointInput.pure();

  //     emit(
  //       state.copyWith(
  //         firstChannelLoadingFrequency: firstChannelLoadingFrequency,
  //         firstChannelLoadingLevel: firstChannelLoadingLevel,
  //         lastChannelLoadingFrequency: lastChannelLoadingFrequency,
  //         lastChannelLoadingLevel: lastChannelLoadingLevel,
  //         isInitialize: true,
  //         enableSubmission: _isEnabledSubmission(
  //           firstChannelLoadingFrequency: firstChannelLoadingFrequency,
  //           firstChannelLoadingLevel: firstChannelLoadingLevel,
  //           lastChannelLoadingFrequency: lastChannelLoadingFrequency,
  //           lastChannelLoadingLevel: lastChannelLoadingLevel,
  //         ),
  //       ),
  //     );
  //   }
  // }

  // void _onQRCodeDataGenerated(
  //   QRCodeDataGenerated event,
  //   Emitter<Setting18ConfigEditState> emit,
  // ) {
  //   emit(state.copyWith(
  //     encodeStaus: FormStatus.requestInProgress,
  //   ));

  //   StringBuffer stringBuffer = StringBuffer();

  //   stringBuffer.write('${state.firstChannelLoadingFrequency.value},');
  //   stringBuffer.write('${state.firstChannelLoadingLevel.value},');
  //   stringBuffer.write('${state.lastChannelLoadingFrequency.value},');
  //   stringBuffer.write(state.lastChannelLoadingLevel.value);

  //   String encodedData = stringBuffer.toString();

  //   emit(state.copyWith(
  //     encodeStaus: FormStatus.requestSuccess,
  //     encodedData: encodedData,
  //   ));
  // }

  void _onNameChanged(
    NameChanged event,
    Emitter<Setting18ConfigEditState> emit,
  ) {
    NameInput name = NameInput.dirty(event.name);

    emit(state.copyWith(
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      name: name,
      enableSubmission: _isEnabledSubmission(
        name: name,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
      ),
    ));
  }

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18ConfigEditState> emit,
  ) {
    emit(state.copyWith(
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      splitOption: event.splitOption,
      enableSubmission: _isEnabledSubmission(
        name: state.name,
        splitOption: event.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
      ),
    ));
  }

  void _onFirstChannelLoadingFrequencyChanged(
    FirstChannelLoadingFrequencyChanged event,
    Emitter<Setting18ConfigEditState> emit,
  ) {
    IntegerInput firstChannelLoadingFrequency =
        IntegerInput.dirty(event.firstChannelLoadingFrequency);

    bool isValid = isValidFirstChannelLoadingFrequency(
      currentDetectedSplitOption: event.currentDetectedSplitOption,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
    );

    emit(state.copyWith(
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      enableSubmission: isValid &&
          _isEnabledSubmission(
            name: state.name,
            splitOption: state.splitOption,
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
      // encodeStaus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      enableSubmission: _isEnabledSubmission(
        name: state.name,
        splitOption: state.splitOption,
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
      // encodeStaus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      enableSubmission: _isEnabledSubmission(
        name: state.name,
        splitOption: state.splitOption,
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
      // encodeStaus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      enableSubmission: _isEnabledSubmission(
        name: state.name,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
      ),
    ));
  }

  Future<void> _onConfigAdded(
    ConfigAdded event,
    Emitter<Setting18ConfigEditState> emit,
  ) async {
    emit(state.copyWith(
      // encodeStaus: FormStatus.none,
      saveStatus: SubmissionStatus.submissionInProgress,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
    ));

    await _configRepository.putConfig(
      groupId: state.groupId,
      name: state.name.value,
      splitOption: state.splitOption,
      firstChannelLoadingFrequency: state.firstChannelLoadingFrequency.value,
      firstChannelLoadingLevel: state.firstChannelLoadingLevel.value,
      lastChannelLoadingFrequency: state.lastChannelLoadingFrequency.value,
      lastChannelLoadingLevel: state.lastChannelLoadingLevel.value,
      // isDefault: '0',
    );

    emit(state.copyWith(
      saveStatus: SubmissionStatus.submissionSuccess,
    ));
  }

  void _onConfigUpdated(
    ConfigUpdated event,
    Emitter<Setting18ConfigEditState> emit,
  ) async {
    emit(state.copyWith(
      // encodeStaus: FormStatus.none,
      saveStatus: SubmissionStatus.submissionInProgress,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
    ));

    await _configRepository.updateConfig(
      id: _config!.id,
      groupId: _groupId,
      name: state.name.value,
      splitOption: state.splitOption,
      firstChannelLoadingFrequency: state.firstChannelLoadingFrequency.value,
      firstChannelLoadingLevel: state.firstChannelLoadingLevel.value,
      lastChannelLoadingFrequency: state.lastChannelLoadingFrequency.value,
      lastChannelLoadingLevel: state.lastChannelLoadingLevel.value,
      // isDefault: _config!.isDefault,
    );

    emit(state.copyWith(
      saveStatus: SubmissionStatus.submissionSuccess,
    ));
  }

  Future<void> _onConfigSubmitted(
    ConfigSubmitted event,
    Emitter<Setting18ConfigEditState> emit,
  ) async {
    emit(state.copyWith(
      // encodeStaus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.submissionInProgress,
      isInitialize: false,
    ));

    List<String> settingResult = [];

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
    required NameInput name,
    required String splitOption,
    required IntegerInput firstChannelLoadingFrequency,
    required FloatPointInput firstChannelLoadingLevel,
    required IntegerInput lastChannelLoadingFrequency,
    required FloatPointInput lastChannelLoadingLevel,
  }) {
    bool isValid = Formz.validate([
      name,
      firstChannelLoadingFrequency,
      firstChannelLoadingLevel,
      lastChannelLoadingFrequency,
      lastChannelLoadingLevel,
    ]);

    if (isValid) {
      if (name.value.isNotEmpty &&
          splitOption != '0' &&
          firstChannelLoadingFrequency.value.isNotEmpty &&
          firstChannelLoadingLevel.value.isNotEmpty &&
          lastChannelLoadingFrequency.value.isNotEmpty &&
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

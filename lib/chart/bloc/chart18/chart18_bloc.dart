import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'chart18_event.dart';
part 'chart18_state.dart';

class Chart18Bloc extends Bloc<Chart18Event, Chart18State> {
  Chart18Bloc({
    required AppLocalizations appLocalizations,
    required Amp18Repository amp18Repository,
  })  : _appLocalizations = appLocalizations,
        _amp18Repository = amp18Repository,
        super(const Chart18State()) {
    on<TabChangedEnabled>(_onTabChangedEnabled);
    on<TabChangedDisabled>(_onTabChangedDisabled);
    on<DataExported>(_onDataExported);
    on<DataShared>(_onDataShared);
    on<AllDataExported>(_onAllDataExported);
    on<RFLevelShared>(_onRFLevelShared);
    on<RFLevelExported>(_onRFLevelExported);
    on<AllRFOutputLogExported>(_onAllRFOutputLogExported);
  }

  final AppLocalizations _appLocalizations;
  final Amp18Repository _amp18Repository;

  void _onTabChangedEnabled(
    TabChangedEnabled event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.none,
      rfLevelExportStatus: FormStatus.none,
      rfLevelShareStatus: FormStatus.none,
      enableTabChange: true,
    ));
  }

  void _onTabChangedDisabled(
    TabChangedDisabled event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.none,
      rfLevelExportStatus: FormStatus.none,
      rfLevelShareStatus: FormStatus.none,
      enableTabChange: false,
    ));
  }

  void _onDataExported(
    DataExported event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.requestInProgress,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.none,
      rfLevelExportStatus: FormStatus.none,
      rfLevelShareStatus: FormStatus.none,
    ));

    final List<dynamic> result = await _amp18Repository.export1p8GRecords(
      code: event.code,
      attributeData: _getAttributeData(),
      regulationData: _getRegulationData(),
      controlData: _getControlData(),
    );

    if (result[0]) {
      emit(state.copyWith(
        dataExportStatus: FormStatus.requestSuccess,
        dataExportPath: result[2],
      ));
    } else {
      emit(state.copyWith(
        dataExportStatus: FormStatus.requestFailure,
        dataExportPath: result[2],
      ));
    }
  }

  void _onDataShared(
    DataShared event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.requestInProgress,
      allDataExportStatus: FormStatus.none,
      rfLevelExportStatus: FormStatus.none,
      rfLevelShareStatus: FormStatus.none,
    ));

    final List<dynamic> result = await _amp18Repository.export1p8GRecords(
      code: event.code,
      attributeData: _getAttributeData(),
      regulationData: _getRegulationData(),
      controlData: _getControlData(),
    );

    if (result[0]) {
      emit(state.copyWith(
        dataShareStatus: FormStatus.requestSuccess,
        exportFileName: result[1],
        dataExportPath: result[2],
      ));
    } else {
      emit(state.copyWith(
        dataShareStatus: FormStatus.requestFailure,
        exportFileName: result[1],
        dataExportPath: result[2],
      ));
    }
  }

  void _onAllDataExported(
    AllDataExported event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.requestInProgress,
      rfLevelExportStatus: FormStatus.none,
      rfLevelShareStatus: FormStatus.none,
    ));

    if (event.isSuccessful) {
      // 清除 cache
      _amp18Repository.clearAllLog1p8Gs();

      // 將所有 log 寫入 cache
      _amp18Repository.writeAllLog1p8Gs(event.log1p8Gs);
      final List<dynamic> result = await _amp18Repository.exportAll1p8GRecords(
        code: event.code,
        attributeData: _getAttributeData(),
        regulationData: _getRegulationData(),
        controlData: _getControlData(),
      );

      if (result[0]) {
        emit(state.copyWith(
          allDataExportStatus: FormStatus.requestSuccess,
          dataExportPath: result[2],
        ));
      } else {
        emit(state.copyWith(
          allDataExportStatus: FormStatus.requestFailure,
          dataExportPath: result[2],
        ));
      }
    } else {
      emit(state.copyWith(
        allDataExportStatus: FormStatus.requestFailure,
        errorMessage: event.errorMessage,
      ));
    }
  }

  void _onAllRFOutputLogExported(
    AllRFOutputLogExported event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.requestInProgress,
      rfLevelExportStatus: FormStatus.none,
      rfLevelShareStatus: FormStatus.none,
    ));

    if (event.isSuccessful) {
      // 清除 cache
      _amp18Repository.clearRFOutputLogs();

      // 將所有 rfOuts 寫入 cache
      _amp18Repository.writeRFOutputLogs(event.rfOutputLog1p8Gs);
      final List<dynamic> result =
          await _amp18Repository.export1p8GAllRFOutputLogs(
        code: event.code,
        attributeData: _getAttributeData(),
        regulationData: _getRegulationData(),
        controlData: _getControlData(),
      );

      if (result[0]) {
        emit(state.copyWith(
          allDataExportStatus: FormStatus.requestSuccess,
          dataExportPath: result[2],
        ));
      } else {
        emit(state.copyWith(
          allDataExportStatus: FormStatus.requestFailure,
          dataExportPath: result[2],
        ));
      }
    } else {
      emit(state.copyWith(
        allDataExportStatus: FormStatus.requestFailure,
        errorMessage: event.errorMessage,
      ));
    }
  }

  void _onRFLevelExported(
    RFLevelExported event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.none,
      rfLevelExportStatus: FormStatus.requestInProgress,
      rfLevelShareStatus: FormStatus.none,
    ));

    final List<dynamic> result = await _amp18Repository.export1p8GRFInOuts(
      code: event.code,
      attributeData: _getAttributeData(),
      regulationData: _getRegulationData(),
      controlData: _getControlData(),
    );

    if (result[0]) {
      emit(state.copyWith(
        rfLevelExportStatus: FormStatus.requestSuccess,
        dataExportPath: result[2],
      ));
    } else {
      emit(state.copyWith(
        rfLevelExportStatus: FormStatus.requestFailure,
        dataExportPath: result[2],
      ));
    }
  }

  void _onRFLevelShared(
    RFLevelShared event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.none,
      rfLevelExportStatus: FormStatus.none,
      rfLevelShareStatus: FormStatus.requestInProgress,
    ));

    final List<dynamic> result = await _amp18Repository.export1p8GRFInOuts(
      code: event.code,
      attributeData: _getAttributeData(),
      regulationData: _getRegulationData(),
      controlData: _getControlData(),
    );

    if (result[0]) {
      emit(state.copyWith(
        rfLevelShareStatus: FormStatus.requestSuccess,
        exportFileName: result[1],
        dataExportPath: result[2],
      ));
    } else {
      emit(state.copyWith(
        rfLevelShareStatus: FormStatus.requestFailure,
        exportFileName: result[1],
        dataExportPath: result[2],
      ));
    }
  }

  Map<String, String> _getAttributeData() {
    Map<DataKey, String> characteristicData =
        _amp18Repository.characteristicDataCache;

    String location = characteristicData[DataKey.location] ?? '';
    String coordinates = characteristicData[DataKey.coordinates] ?? '';
    String technicianID = characteristicData[DataKey.technicianID] ?? '';
    String inputSignalLevel =
        characteristicData[DataKey.inputSignalLevel] ?? '';
    String inputAttenuation =
        characteristicData[DataKey.inputAttenuation] ?? '';
    String inputEqualizer = characteristicData[DataKey.inputEqualizer] ?? '';
    String cascadePosition = characteristicData[DataKey.cascadePosition] ?? '';
    String deviceName = characteristicData[DataKey.deviceName] ?? '';
    String deviceNote = characteristicData[DataKey.deviceNote] ?? '';

    int firmwareVersion = convertFirmwareVersionStringToInt(
        characteristicData[DataKey.firmwareVersion] ?? '0');

    Map<String, String> attributeValues = {
      // 因為 l10n 內有位了tabbar 顯示而多加空白, 所以刪除空白
      _appLocalizations.device.trim(): '',
      _appLocalizations.location: location,
      _appLocalizations.coordinates: coordinates,
      if (firmwareVersion >= 148) ...{
        _appLocalizations.technicianID: technicianID,
        _appLocalizations.inputSignalLevel: inputSignalLevel,
        _appLocalizations.inputAttenuation: inputAttenuation,
        _appLocalizations.inputEqualizer: inputEqualizer,
        _appLocalizations.cascadePosition: cascadePosition,
        _appLocalizations.deviceName: deviceName,
        _appLocalizations.deviceNote: deviceNote,
      }
    };

    return attributeValues;
  }

  Map<String, String> _getRegulationData() {
    Map<DataKey, String> characteristicData =
        _amp18Repository.characteristicDataCache;

    Map<String, String> pilotFrequencyModeTexts = {
      '0': _appLocalizations.pilotFrequencyBandwidthSettings,
      '1': _appLocalizations.pilotFrequencyUserSettings,
      //  _appLocalizations.pilotFrequencySmartSettings,
    };

    Map<String, String> onOffTexts = {
      '0': _appLocalizations.off,
      '1': _appLocalizations.on,
    };

    String pilotFrequencyMode =
        characteristicData[DataKey.pilotFrequencyMode] ?? '';

    String pilotFrequencyModeText = pilotFrequencyMode != ''
        ? pilotFrequencyModeTexts[pilotFrequencyMode] ?? 'N/A'
        : '';

    String firstChannelLoadingFrequency =
        characteristicData[DataKey.firstChannelLoadingFrequency] ?? '';
    String lastChannelLoadingFrequency =
        characteristicData[DataKey.lastChannelLoadingFrequency] ?? '';
    String firstChannelLoadingLevel =
        characteristicData[DataKey.firstChannelLoadingLevel] ?? '';
    String lastChannelLoadingLevel =
        characteristicData[DataKey.lastChannelLoadingLevel] ?? '';

    String pilotFrequency1 = characteristicData[DataKey.pilotFrequency1] ?? '';
    String pilotFrequency2 = characteristicData[DataKey.pilotFrequency2] ?? '';

    String manualModePilot1RFOutputPower =
        characteristicData[DataKey.manualModePilot1RFOutputPower] ?? '';
    String manualModePilot2RFOutputPower =
        characteristicData[DataKey.manualModePilot2RFOutputPower] ?? '';

    String agcMode = characteristicData[DataKey.agcMode] ?? '';
    String agcModeText = agcMode != '' ? onOffTexts[agcMode]! : '';
    // String alcMode = characteristicData[DataKey.alcMode] ?? '';
    // String alcModeText = alcMode != '' ? onOffTexts[alcMode]! : '';
    String logInterval = characteristicData[DataKey.logInterval] ?? '';
    String rfOutputLogInterval =
        characteristicData[DataKey.rfOutputLogInterval] ?? '';

    Map<String, String> configurationValues = {
      _appLocalizations.pilotFrequencySelect: pilotFrequencyModeText,
      _appLocalizations.startFrequency:
          '$firstChannelLoadingFrequency ${CustomStyle.mHz}',
      _appLocalizations.startLevel:
          '$firstChannelLoadingLevel ${CustomStyle.dBmV}',
      _appLocalizations.stopFrequency:
          '$lastChannelLoadingFrequency ${CustomStyle.mHz}',
      _appLocalizations.stopLevel:
          '$lastChannelLoadingLevel ${CustomStyle.dBmV}',
      _appLocalizations.pilotFrequency1: '$pilotFrequency1 ${CustomStyle.mHz}',
      _appLocalizations.pilotLevel1:
          '$manualModePilot1RFOutputPower ${CustomStyle.dBmV}',
      _appLocalizations.pilotFrequency2: '$pilotFrequency2 ${CustomStyle.mHz}',
      _appLocalizations.pilotLevel2:
          '$manualModePilot2RFOutputPower ${CustomStyle.dBmV}',
      _appLocalizations.agcMode: agcModeText,
      // _appLocalizations.alcMode: alcModeText,
      _appLocalizations.logInterval: '$logInterval ${_appLocalizations.minute}',
      _appLocalizations.rfOutputLogInterval:
          '$rfOutputLogInterval ${_appLocalizations.minute}',
    };

    return configurationValues;
  }

  List<Map<String, String>> _getControlData() {
    Map<DataKey, String> characteristicData =
        _amp18Repository.characteristicDataCache;

    Map<String, String> ingressSettingTexts = {
      '0': '0${CustomStyle.dB}',
      '1': '-3${CustomStyle.dB}',
      '2': '-6${CustomStyle.dB}',
      '4': _appLocalizations.ingressOpen,
    };

    Map<Enum, String> controlItemTexts = {
      SettingControl.forwardInputAttenuation1:
          _appLocalizations.forwardInputAttenuation1,
      SettingControl.forwardInputEqualizer1:
          _appLocalizations.forwardInputEqualizer1,
      SettingControl.forwardOutputAttenuation3:
          _appLocalizations.forwardOutputAttenuation3,
      SettingControl.forwardOutputAttenuation4:
          _appLocalizations.forwardOutputAttenuation4,
      SettingControl.forwardOutputAttenuation2And3:
          _appLocalizations.forwardOutputAttenuation2And3,
      SettingControl.forwardOutputAttenuation3And4:
          _appLocalizations.forwardOutputAttenuation3And4,
      SettingControl.forwardOutputAttenuation5And6:
          _appLocalizations.forwardOutputAttenuation5And6,
      SettingControl.forwardOutputEqualizer3:
          _appLocalizations.forwardOutputEqualizer3,
      SettingControl.forwardOutputEqualizer4:
          _appLocalizations.forwardOutputEqualizer4,
      SettingControl.forwardOutputEqualizer2And3:
          _appLocalizations.forwardOutputEqualizer2And3,
      SettingControl.forwardOutputEqualizer5And6:
          _appLocalizations.forwardOutputEqualizer5And6,
      SettingControl.returnOutputAttenuation1:
          _appLocalizations.returnOutputAttenuation1,
      SettingControl.returnOutputEqualizer1:
          _appLocalizations.returnOutputEqualizer1,
      SettingControl.returnInputAttenuation2:
          _appLocalizations.returnInputAttenuation2,
      SettingControl.returnInputAttenuation3:
          _appLocalizations.returnInputAttenuation3,
      SettingControl.returnInputAttenuation4:
          _appLocalizations.returnInputAttenuation4,
      SettingControl.returnInputAttenuation2And3:
          _appLocalizations.returnInputAttenuation2And3,
      SettingControl.returnInputAttenuation5And6:
          _appLocalizations.returnInputAttenuation5And6,
      SettingControl.returnIngressSetting2:
          _appLocalizations.returnIngressSetting2,
      SettingControl.returnIngressSetting3:
          _appLocalizations.returnIngressSetting3,
      SettingControl.returnIngressSetting4:
          _appLocalizations.returnIngressSetting4,
      SettingControl.returnIngressSetting2And3:
          _appLocalizations.returnIngressSetting2And3,
      SettingControl.returnIngressSetting5And6:
          _appLocalizations.returnIngressSetting5And6,
    };

    String partId = characteristicData[DataKey.partId]!;

    List<Map<String, String>> controlValues = [
      {
        // 因為 l10n 內有位了tabbar 顯示而多加空白, 所以刪除空白
        _appLocalizations.balance.trim(): '',
      }
    ];

    Map<Enum, DataKey> forwardControlItemMap =
        SettingItemTable.controlItemDataMapCollection[partId]![0];

    Map<Enum, DataKey> returnControlItemMap =
        SettingItemTable.controlItemDataMapCollection[partId]![1];

    controlValues.add({_appLocalizations.forwardControlParameters: ''});

    for (MapEntry entry in forwardControlItemMap.entries) {
      Enum key = entry.key;
      DataKey value = entry.value;

      String controlName = controlItemTexts[key] ?? '';
      String controlValue = characteristicData[value] ?? '';

      String alcMode = characteristicData[DataKey.alcMode]!;
      String agcMode = characteristicData[DataKey.agcMode]!;

      if (key.name == SettingControl.forwardInputAttenuation1.name) {
        controlValue = getInputAttenuation(
          alcMode: alcMode,
          inputAttenuation: controlValue,
          currentInputAttenuation:
              characteristicData[DataKey.currentDSVVA1] ?? '',
        );
      }

      if (key.name == SettingControl.forwardInputEqualizer1.name) {
        controlValue = getInputEqualizer(
          alcMode: alcMode,
          agcMode: agcMode,
          inputEqualizer: controlValue,
          currentInputEqualizer:
              characteristicData[DataKey.currentDSSlope1] ?? '',
        );
      }

      controlValue = '$controlValue ${CustomStyle.dB}';

      controlValues.add({controlName: controlValue});
    }

    controlValues.add({_appLocalizations.returnControlParameters: ''});

    for (MapEntry entry in returnControlItemMap.entries) {
      Enum key = entry.key;
      DataKey value = entry.value;

      String controlName = controlItemTexts[key] ?? '';
      String controlValue = characteristicData[value] ?? '';

      if (value.name.startsWith('ingressSetting')) {
        controlValue = ingressSettingTexts[controlValue] ?? '';
      } else {
        controlValue = '$controlValue ${CustomStyle.dB}';
      }

      controlValues.add({controlName: controlValue});
    }

    return controlValues;
  }
}

import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'alarm_description_event.dart';
part 'alarm_description_state.dart';

class AlarmDescriptionBloc
    extends Bloc<AlarmDescriptionEvent, AlarmDescriptionState> {
  AlarmDescriptionBloc({
    required this.severityIndexList,
    required this.aciDeviceType,
    required Amp18Repository amp18Repository,
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
    required UnitRepository unitRepository,
  })  : _amp18Repository = amp18Repository,
        _amp18CCorNodeRepository = amp18CCorNodeRepository,
        _unitRepository = unitRepository,
        super(const AlarmDescriptionState()) {
    on<AlarmDescriptionRequested>(_onAlarmDescriptionRequested);
    on<NodeAlarmDescriptionRequested>(_onNodeAlarmDescriptionRequested);

    if (aciDeviceType == ACIDeviceType.amp1P8G) {
      add(const AlarmDescriptionRequested());
    } else if (aciDeviceType == ACIDeviceType.ampCCorNode1P8G) {
      add(const NodeAlarmDescriptionRequested());
    } else {
      // 沒有辨識出ACIDeviceType, 不做任何事
    }
  }

  final List<int> severityIndexList;
  final ACIDeviceType aciDeviceType;
  final Amp18Repository _amp18Repository;
  final Amp18CCorNodeRepository _amp18CCorNodeRepository;
  final UnitRepository _unitRepository;

  void _onNodeAlarmDescriptionRequested(
    NodeAlarmDescriptionRequested event,
    Emitter<AlarmDescriptionState> emit,
  ) {
    TemperatureUnit temperatureUnit = _unitRepository.temperatureUnit;

    Map<DataKey, String> characteristicDataCache =
        _amp18CCorNodeRepository.characteristicDataCache;

    String currentTemperatureC =
        characteristicDataCache[DataKey.currentTemperatureC] ?? '';

    String currentTemperatureF =
        characteristicDataCache[DataKey.currentTemperatureF] ?? '';

    String currentVoltage =
        characteristicDataCache[DataKey.currentVoltage] ?? '';

    String currentRFOutputPower1 =
        characteristicDataCache[DataKey.currentRFOutputPower1] ?? '';

    String currentRFOutputPower3 =
        characteristicDataCache[DataKey.currentRFOutputPower3] ?? '';

    String currentRFOutputPower4 =
        characteristicDataCache[DataKey.currentRFOutputPower4] ?? '';

    String currentRFOutputPower6 =
        characteristicDataCache[DataKey.currentRFOutputPower6] ?? '';

    List<String> severityValueList = [
      temperatureUnit == TemperatureUnit.celsius
          ? currentTemperatureC
          : currentTemperatureF,
      currentVoltage,
      currentRFOutputPower1,
      currentRFOutputPower3,
      currentRFOutputPower4,
      currentRFOutputPower6,
    ];

    List<SeverityIndex> severityIndexValueList = [];

    for (int i = 0; i < severityIndexList.length; i++) {
      severityIndexValueList.add(SeverityIndex(
        index: severityIndexList[i],
        value: severityValueList[severityIndexList[i]],
      ));
    }

    emit(state.copyWith(
      aciDeviceType: aciDeviceType,
      temperatureUnit: temperatureUnit,
      severityIndexValueList: severityIndexValueList,
    ));
  }

  void _onAlarmDescriptionRequested(
    AlarmDescriptionRequested event,
    Emitter<AlarmDescriptionState> emit,
  ) {
    TemperatureUnit temperatureUnit = _unitRepository.temperatureUnit;

    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String currentTemperatureC =
        characteristicDataCache[DataKey.currentTemperatureC] ?? '';

    String currentTemperatureF =
        characteristicDataCache[DataKey.currentTemperatureF] ?? '';

    String currentVoltage =
        characteristicDataCache[DataKey.currentVoltage] ?? '';

    String currentVoltageRipple =
        characteristicDataCache[DataKey.currentVoltageRipple] ?? '';

    String currentRFOutputPower =
        characteristicDataCache[DataKey.currentRFOutputPower] ?? '';

    String rfOutputLowChannelPower =
        characteristicDataCache[DataKey.rfOutputLowChannelPower] ?? '';

    String rfOutputHighChannelPower =
        characteristicDataCache[DataKey.rfOutputHighChannelPower] ?? '';

    List<String> severityValueList = [
      temperatureUnit == TemperatureUnit.celsius
          ? currentTemperatureC
          : currentTemperatureF,
      currentVoltage,
      currentVoltageRipple,
      currentRFOutputPower,
      rfOutputLowChannelPower,
      rfOutputHighChannelPower,
    ];

    List<SeverityIndex> severityIndexValueList = [];

    for (int i = 0; i < severityIndexList.length; i++) {
      severityIndexValueList.add(SeverityIndex(
        index: severityIndexList[i],
        value: severityValueList[severityIndexList[i]],
      ));
    }

    emit(state.copyWith(
      aciDeviceType: aciDeviceType,
      temperatureUnit: temperatureUnit,
      severityIndexValueList: severityIndexValueList,
    ));
  }
}

// create a class that keep the severityIndex and the corresponting value
class SeverityIndex {
  const SeverityIndex({
    required this.index,
    required this.value,
  });

  final int index;
  final String value;
}

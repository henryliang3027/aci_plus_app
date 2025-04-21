import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
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
    required ACIDeviceRepository aciDeviceRepository,
    required Amp18Repository amp18Repository,
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
    required UnitRepository unitRepository,
  })  : _aciDeviceRepository = aciDeviceRepository,
        _amp18Repository = amp18Repository,
        _amp18CCorNodeRepository = amp18CCorNodeRepository,
        _unitRepository = unitRepository,
        super(const AlarmDescriptionState()) {
    on<AlarmDescriptionRequested>(_onAlarmDescriptionRequested);

    add(const AlarmDescriptionRequested());
  }

  final List<int> severityIndexList;
  final ACIDeviceRepository _aciDeviceRepository;
  final Amp18Repository _amp18Repository;
  final Amp18CCorNodeRepository _amp18CCorNodeRepository;
  final UnitRepository _unitRepository;

  // Alarm _getSeverity(String alarmState, String alarmSeverity) {
  //   if (alarmState == '0') {
  //     if (alarmSeverity == Alarm.success.name) {
  //       return Alarm.success;
  //     } else if (alarmSeverity == Alarm.danger.name) {
  //       return Alarm.danger;
  //     } else {
  //       //  Alarm.medium
  //       return Alarm.success;
  //     }
  //   } else {
  //     // alarmState == '1'
  //     return Alarm.success;
  //   }
  // }

  void _onAlarmDescriptionRequested(
    AlarmDescriptionRequested event,
    Emitter<AlarmDescriptionState> emit,
  ) {
    TemperatureUnit temperatureUnit = _unitRepository.temperatureUnit;

    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String temperatureAlarmSeverity =
        characteristicDataCache[DataKey.temperatureAlarmSeverity] ?? '';

    String voltageAlarmSeverity =
        characteristicDataCache[DataKey.voltageAlarmSeverity] ?? '';

    String voltageRippleAlarmSeverity =
        characteristicDataCache[DataKey.voltageRippleAlarmSeverity] ?? '';

    String rfOutputPowerAlarmSeverity =
        characteristicDataCache[DataKey.outputPowerAlarmSeverity] ?? '';

    String rfOutputPilotLowFrequencyAlarmSeverity = characteristicDataCache[
            DataKey.rfOutputPilotLowFrequencyAlarmSeverity] ??
        '';

    String rfOutputPilotHighFrequencyAlarmSeverity = characteristicDataCache[
            DataKey.rfOutputPilotHighFrequencyAlarmSeverity] ??
        '';

    String temperatureAlarmState =
        characteristicDataCache[DataKey.temperatureAlarmState] ?? '1';

    String voltageAlarmState =
        characteristicDataCache[DataKey.voltageAlarmState] ?? '1';

    String voltageRippleAlarmState =
        characteristicDataCache[DataKey.voltageRippleAlarmState] ?? '1';

    String rfOutputPowerAlarmState =
        characteristicDataCache[DataKey.rfOutputPowerAlarmState] ?? '1';

    String rfOutputPilotLowFrequencyAlarmState =
        characteristicDataCache[DataKey.rfOutputPilotLowFrequencyAlarmState] ??
            '1';

    String rfOutputPilotHighFrequencyAlarmState =
        characteristicDataCache[DataKey.rfOutputPilotHighFrequencyAlarmState] ??
            '1';

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
      currentTemperatureC,
      currentVoltage,
      currentVoltageRipple,
      currentRFOutputPower,
      rfOutputLowChannelPower,
      rfOutputHighChannelPower,
    ];

    List<SeverityIndex> severityIndexValueList = [];

    for (int i = 0; i < severityIndexList.length; i++) {
      if (severityIndexList[i] == 0) {
        if (temperatureUnit == TemperatureUnit.celsius) {
          severityIndexValueList.add(SeverityIndex(
            index: severityIndexList[i],
            value: currentTemperatureC,
          ));
        } else {
          severityIndexValueList.add(SeverityIndex(
            index: severityIndexList[i],
            value: currentTemperatureF,
          ));
        }
      } else {
        severityIndexValueList.add(SeverityIndex(
          index: severityIndexList[i],
          value: severityValueList[severityIndexList[i]],
        ));
      }
    }

    // if (dataKey == DataKey.temperatureAlarmSeverity) {
    //   severityIndexList = [severityIndexList[0]];
    // } else if (dataKey == DataKey.voltageAlarmSeverity) {
    //   severityIndexList = [severityIndexList[1]];
    // } else {}

    emit(state.copyWith(
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

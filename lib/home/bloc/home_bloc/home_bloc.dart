import 'dart:async';

import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_speed_chart/speed_chart.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const HomeState()) {
    on<SplashStateChanged>(_onSplashStateChanged);
    on<DiscoveredDeviceChanged>(_onDiscoveredDeviceChanged);
    on<DataRequested>(_onDataRequested);
    on<DeviceCharacteristicChanged>(_onDeviceCharacteristicChanged);
    on<DeviceRefreshed>(_onDeviceRefreshed);
    on<DeviceConnectionChanged>(_onDeviceConnectionChanged);
    on<DataExported>(_onDataExported);
    on<DataShared>(_onDataShared);

    on<BaudRateTestRequested>(_onBaudRateTestRequested);
    on<BaudRateTest2Requested>(_onBaudRateTest2Requested);

    add(const SplashStateChanged());
  }

  final DsimRepository _dsimRepository;
  StreamSubscription<ScanReport>? _scanStreamSubscription;
  StreamSubscription<ConnectionReport>? _connectionReportStreamSubscription;
  StreamSubscription<Map<DataKey, String>>?
      _characteristicDataStreamSubscription;

  // 進入首頁時播放動畫，動畫播完後掃描藍芽裝置
  Future<void> _onSplashStateChanged(
    SplashStateChanged event,
    Emitter<HomeState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 2500));

    _scanStreamSubscription = _dsimRepository.scannedDevices.listen(
      (scanReport) {
        add(DiscoveredDeviceChanged(scanReport));
      },
    );

    emit(state.copyWith(
      showSplash: false,
      scanStatus: FormStatus.requestInProgress,
      connectionStatus: FormStatus.requestInProgress,
      loadingStatus: FormStatus.requestInProgress,
    ));
  }

  Future<void> _onDiscoveredDeviceChanged(
    DiscoveredDeviceChanged event,
    Emitter<HomeState> emit,
  ) async {
    switch (event.scanReport.scanStatus) {
      case ScanStatus.success:
        emit(state.copyWith(
          scanStatus: FormStatus.requestSuccess,
          device: event.scanReport.discoveredDevice,
        ));

        _connectionReportStreamSubscription =
            _dsimRepository.connectionStateReport.listen((connectionReport) {
          add(DeviceConnectionChanged(connectionReport));
        });
        break;
      case ScanStatus.failure:
        emit(state.copyWith(
            scanStatus: FormStatus.requestFailure,
            connectionStatus: FormStatus.requestFailure,
            // loadingStatus: FormStatus.requestFailure,
            device: null,
            errorMassage: 'Device not found.'));
        break;
      case ScanStatus.disable:
        emit(state.copyWith(
            scanStatus: FormStatus.requestFailure,
            device: null,
            errorMassage: 'Bluetooth is disabled.'));
        break;
    }

    await _dsimRepository.closeScanStream();
    await _scanStreamSubscription?.cancel();
    _scanStreamSubscription = null;
  }

  void _onDeviceConnectionChanged(
    DeviceConnectionChanged event,
    Emitter<HomeState> emit,
  ) {
    switch (event.connectionReport.connectionState) {
      case DeviceConnectionState.connecting:
        emit(state.copyWith(
          scanStatus: FormStatus.requestSuccess,
          connectionStatus: FormStatus.requestInProgress,
        ));
        break;
      case DeviceConnectionState.connected:
        emit(state.copyWith(
          scanStatus: FormStatus.requestSuccess,
          connectionStatus: FormStatus.requestSuccess,
        ));

        add(const DataRequested());

        _characteristicDataStreamSubscription =
            _dsimRepository.characteristicData.listen(
          (data) {
            add(DeviceCharacteristicChanged(data.entries.first));
          },
          onDone: () {},
        );

        // _loadingResultStreamSubscription =
        //     _dsimRepository.loadingResult.listen((data) {
        //   add(LoadingResultChanged(data));
        // });

        break;
      case DeviceConnectionState.disconnecting:
        emit(state.copyWith(
          scanStatus: FormStatus.requestSuccess,
          connectionStatus: FormStatus.requestFailure,
          // loadingStatus: FormStatus.requestFailure,
        ));
        break;
      case DeviceConnectionState.disconnected:
        emit(state.copyWith(
          scanStatus: FormStatus.requestSuccess,
          connectionStatus: FormStatus.requestFailure,
          // loadingStatus: FormStatus.requestFailure,
        ));
        break;
    }
  }

  void _onDeviceCharacteristicChanged(
    DeviceCharacteristicChanged event,
    Emitter<HomeState> emit,
  ) {
    Map<DataKey, String> newCharacteristicData = {};
    newCharacteristicData.addEntries(state.characteristicData.entries);
    newCharacteristicData[event.dataMapEntry.key] = event.dataMapEntry.value;
    emit(state.copyWith(
      characteristicData: newCharacteristicData,
    ));
  }

  Future<void> _onBaudRateTestRequested(
    BaudRateTestRequested event,
    Emitter<HomeState> emit,
  ) async {
    List<int> data = await _dsimRepository.requestCommandTest1();

    // print('result: ${data.length}, ${data[data.length - 1]}');
  }

  Future<void> _onBaudRateTest2Requested(
    BaudRateTest2Requested event,
    Emitter<HomeState> emit,
  ) async {
    List<int> data = await _dsimRepository.requestCommandTest2();

    // print('result: ${data.length}, ${data[data.length - 1]}');
  }

  Future<void> _onDataRequested(
    DataRequested event,
    Emitter<HomeState> emit,
  ) async {
    Map<DataKey, String> characteristicData = {};

    emit(state.copyWith(
      loadingStatus: FormStatus.requestInProgress,
      characteristicData: characteristicData,
    ));

    List<Function> requestCommands = [
      // _dsimRepository.requestCommand0,
      // _dsimRepository.requestCommand1,
      // _dsimRepository.requestCommand2,
      // _dsimRepository.requestCommand3,
      // _dsimRepository.requestCommand4,
      // _dsimRepository.requestCommand5,
      // _dsimRepository.requestCommand6,
      // _dsimRepository.requestCommand9To12,
      // _dsimRepository.requestCommand14To29,
      // _dsimRepository.requestCommand30To37,
    ];

    for (int i = 0; i < requestCommands.length; i++) {
      List<dynamic> result = await requestCommands[i]();

      if (result[0]) {
        if (i == 0) {
          characteristicData[DataKey.typeNo] = result[1];
          emit(state.copyWith(
            characteristicData: characteristicData,
          ));
        } else if (i == 1) {
          characteristicData[DataKey.partNo] = result[1];
          emit(state.copyWith(
            characteristicData: characteristicData,
          ));
        } else if (i == 2) {
          characteristicData[DataKey.serialNumber] = result[1];
          emit(state.copyWith(
            characteristicData: characteristicData,
          ));
        } else if (i == 3) {
          characteristicData[DataKey.logInterval] = result[1];
          characteristicData[DataKey.firmwareVersion] = result[2];
          emit(state.copyWith(
            characteristicData: characteristicData,
          ));
        } else if (i == 4) {
          characteristicData[DataKey.currentAttenuation] = result[1];
          characteristicData[DataKey.minAttenuation] = result[2];
          characteristicData[DataKey.maxAttenuation] = result[3];
          characteristicData[DataKey.tgcCableLength] = result[4];
          emit(state.copyWith(
            characteristicData: characteristicData,
          ));
        } else if (i == 5) {
          characteristicData[DataKey.workingMode] = result[1];
          characteristicData[DataKey.currentPilot] = result[2];
          characteristicData[DataKey.currentPilotMode] = result[3];
          characteristicData[DataKey.alarmRServerity] = result[4];
          characteristicData[DataKey.alarmTServerity] = result[5];
          characteristicData[DataKey.alarmPServerity] = result[6];
          characteristicData[DataKey.currentTemperatureF] = result[7];
          characteristicData[DataKey.currentTemperatureC] = result[8];
          characteristicData[DataKey.currentVoltage] = result[9];
          emit(state.copyWith(
            characteristicData: characteristicData,
          ));
        } else if (i == 6) {
          characteristicData[DataKey.centerAttenuation] = result[1];
          characteristicData[DataKey.currentVoltageRipple] = result[2];
          emit(state.copyWith(
            characteristicData: characteristicData,
          ));
        } else if (i == 7) {
          characteristicData[DataKey.location] = result[1];
          emit(state.copyWith(
            characteristicData: characteristicData,
          ));
        } else if (i == 8) {
          characteristicData[DataKey.minTemperatureF] = result[1];
          characteristicData[DataKey.maxTemperatureF] = result[2];
          characteristicData[DataKey.minTemperatureC] = result[3];
          characteristicData[DataKey.maxTemperatureC] = result[4];
          characteristicData[DataKey.historicalMinAttenuation] = result[5];
          characteristicData[DataKey.historicalMaxAttenuation] = result[6];
          characteristicData[DataKey.minVoltage] = result[7];
          characteristicData[DataKey.maxVoltage] = result[8];
          characteristicData[DataKey.minVoltageRipple] = result[9];
          characteristicData[DataKey.maxVoltageRipple] = result[10];

          List<List<DateValuePair>> dateValueCollectionOfLog =
              _dsimRepository.getDateValueCollectionOfLogs();

          emit(state.copyWith(
            loadingStatus: FormStatus.requestSuccess,
            characteristicData: characteristicData,
            dateValueCollectionOfLog: dateValueCollectionOfLog,
          ));
        }
      } else {
        emit(state.copyWith(
          loadingStatus: FormStatus.requestFailure,
          characteristicData: characteristicData,
        ));
        break;
      }
    }
  }

  Future<void> _onDeviceRefreshed(
    DeviceRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      scanStatus: FormStatus.requestInProgress,
      connectionStatus: FormStatus.requestInProgress,
      loadingStatus: FormStatus.requestInProgress,
      dataExportStatus: FormStatus.none,
      device: null,
      characteristicData: const {},
    ));

    _dsimRepository.clearCache();
    print('cache cleaned');
    await _dsimRepository.closeConnectionStream();
    print('connectionStream closed');

    if (_connectionReportStreamSubscription != null) {
      await _connectionReportStreamSubscription?.cancel();
      _connectionReportStreamSubscription = null;
      print('connectionReportStreamSubscription closed');
    }

    if (_characteristicDataStreamSubscription != null) {
      await _characteristicDataStreamSubscription?.cancel();
      _characteristicDataStreamSubscription = null;
      print('_characteristicDataStreamSubscription closed');
    }

    _scanStreamSubscription =
        _dsimRepository.scannedDevices.listen((scanReport) async {
      add(DiscoveredDeviceChanged(scanReport));
    });
  }

  void _onDataExported(
    DataExported event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      dataShareStatus: FormStatus.none,
      dataExportStatus: FormStatus.requestInProgress,
    ));

    final List<dynamic> result = await _dsimRepository.exportRecords();

    if (result[0]) {
      emit(state.copyWith(
        dataExportStatus: FormStatus.requestSuccess,
        dataExportPath: result[1],
      ));
    } else {
      emit(state.copyWith(
        dataExportStatus: FormStatus.requestFailure,
        dataExportPath: result[1],
      ));
    }
  }

  void _onDataShared(
    DataShared event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.requestInProgress,
    ));

    final List<dynamic> result = await _dsimRepository.exportRecords();

    if (result[0]) {
      emit(state.copyWith(
        dataShareStatus: FormStatus.requestSuccess,
        dataExportPath: result[1],
      ));
    } else {
      emit(state.copyWith(
        dataShareStatus: FormStatus.requestFailure,
        dataExportPath: result[1],
      ));
    }
  }
}

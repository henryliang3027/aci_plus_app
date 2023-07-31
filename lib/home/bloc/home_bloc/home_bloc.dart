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
    // on<DataExported>(_onDataExported);
    // on<DataShared>(_onDataShared);

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
            loadingStatus: FormStatus.requestFailure,
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
        // emit(state.copyWith(
        //   scanStatus: FormStatus.requestSuccess,
        //   connectionStatus: FormStatus.requestInProgress,
        // ));
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
        // emit(state.copyWith(
        //   scanStatus: FormStatus.requestSuccess,
        //   connectionStatus: FormStatus.requestFailure,
        //   // loadingStatus: FormStatus.requestFailure,
        // ));
        break;
      case DeviceConnectionState.disconnected:
        emit(state.copyWith(
          scanStatus: FormStatus.requestSuccess,
          connectionStatus: FormStatus.requestFailure,
          loadingStatus: FormStatus.none,
          errorMassage: 'Device connection failed',
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
    var data = await _dsimRepository.requestCommand0();

    print('result: $data');
  }

  Future<void> _onBaudRateTest2Requested(
    BaudRateTest2Requested event,
    Emitter<HomeState> emit,
  ) async {
    var data = await _dsimRepository.requestCommandTest2();
    // _dsimRepository.requestCommand14To29();

    // print('result: ${data.length}, ${data[data.length - 1]}');
  }

  Future<void> _onDataRequested(
    DataRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      loadingStatus: FormStatus.requestInProgress,
      characteristicData: {},
    ));

    List<Function> requestCommands = [
      _dsimRepository.requestCommand0,
      _dsimRepository.requestCommand1,
      _dsimRepository.requestCommand2,
      _dsimRepository.requestCommand3,
      _dsimRepository.requestCommand4,
      _dsimRepository.requestCommand5,
      _dsimRepository.requestCommand6,
      _dsimRepository.requestCommand9To12,
      _dsimRepository.requestCommand14To29,
      // _dsimRepository.requestCommand30To37,
    ];

    for (int i = 0; i < requestCommands.length; i++) {
      List<dynamic> result = await requestCommands[i]();

      if (result[0]) {
        if (i == 0) {
          // 因為 state 是 immutable, 所以要創一個新的 map, copy 原來的 element, 加上新的 element,
          // emit 的 state 才算新的, 才會觸發 bloc builder
          Map<DataKey, String> newCharacteristicData = {};
          newCharacteristicData[DataKey.typeNo] = result[1];
          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
        } else if (i == 1) {
          Map<DataKey, String> newCharacteristicData = {};
          newCharacteristicData.addEntries(state.characteristicData.entries);
          newCharacteristicData[DataKey.partNo] = result[1];

          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
        } else if (i == 2) {
          Map<DataKey, String> newCharacteristicData = {};
          newCharacteristicData.addEntries(state.characteristicData.entries);
          newCharacteristicData[DataKey.serialNumber] = result[1];
          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
        } else if (i == 3) {
          Map<DataKey, String> newCharacteristicData = {};
          newCharacteristicData.addEntries(state.characteristicData.entries);
          newCharacteristicData[DataKey.logInterval] = result[1];
          newCharacteristicData[DataKey.firmwareVersion] = result[2];
          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
        } else if (i == 4) {
          Map<DataKey, String> newCharacteristicData = {};
          newCharacteristicData.addEntries(state.characteristicData.entries);
          newCharacteristicData[DataKey.currentAttenuation] = result[1];
          newCharacteristicData[DataKey.minAttenuation] = result[2];
          newCharacteristicData[DataKey.maxAttenuation] = result[3];
          newCharacteristicData[DataKey.tgcCableLength] = result[4];
          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
        } else if (i == 5) {
          Map<DataKey, String> newCharacteristicData = {};
          newCharacteristicData.addEntries(state.characteristicData.entries);
          newCharacteristicData[DataKey.workingMode] = result[1];
          newCharacteristicData[DataKey.currentPilot] = result[2];
          newCharacteristicData[DataKey.currentPilotMode] = result[3];
          newCharacteristicData[DataKey.alarmRServerity] = result[4];
          newCharacteristicData[DataKey.alarmTServerity] = result[5];
          newCharacteristicData[DataKey.alarmPServerity] = result[6];
          newCharacteristicData[DataKey.currentTemperatureF] = result[7];
          newCharacteristicData[DataKey.currentTemperatureC] = result[8];
          newCharacteristicData[DataKey.currentVoltage] = result[9];
          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
        } else if (i == 6) {
          Map<DataKey, String> newCharacteristicData = {};
          newCharacteristicData.addEntries(state.characteristicData.entries);
          newCharacteristicData[DataKey.centerAttenuation] = result[1];
          newCharacteristicData[DataKey.currentVoltageRipple] = result[2];
          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
        } else if (i == 7) {
          Map<DataKey, String> newCharacteristicData = {};
          newCharacteristicData.addEntries(state.characteristicData.entries);
          newCharacteristicData[DataKey.location] = result[1];
          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
        } else if (i == 8) {
          Map<DataKey, String> newCharacteristicData = {};
          newCharacteristicData.addEntries(state.characteristicData.entries);

          List<List<DateValuePair>> dateValueCollectionOfLog =
              _dsimRepository.getDateValueCollectionOfLogs();

          List<DateValuePair> allValues = dateValueCollectionOfLog
              .expand(
                (dateValuePair) => dateValuePair,
              )
              .toList();

          if (allValues.isNotEmpty) {
            newCharacteristicData[DataKey.minTemperatureF] = result[1];
            newCharacteristicData[DataKey.maxTemperatureF] = result[2];
            newCharacteristicData[DataKey.minTemperatureC] = result[3];
            newCharacteristicData[DataKey.maxTemperatureC] = result[4];
            newCharacteristicData[DataKey.historicalMinAttenuation] = result[5];
            newCharacteristicData[DataKey.historicalMaxAttenuation] = result[6];
            newCharacteristicData[DataKey.minVoltage] = result[7];
            newCharacteristicData[DataKey.maxVoltage] = result[8];
            newCharacteristicData[DataKey.minVoltageRipple] = result[9];
            newCharacteristicData[DataKey.maxVoltageRipple] = result[10];
          } else {
            newCharacteristicData[DataKey.minTemperatureF] =
                newCharacteristicData[DataKey.currentTemperatureF] ?? '';
            newCharacteristicData[DataKey.maxTemperatureF] =
                newCharacteristicData[DataKey.currentTemperatureF] ?? '';
            newCharacteristicData[DataKey.minTemperatureC] =
                newCharacteristicData[DataKey.currentTemperatureC] ?? '';
            newCharacteristicData[DataKey.maxTemperatureC] =
                newCharacteristicData[DataKey.currentTemperatureC] ?? '';
            newCharacteristicData[DataKey.historicalMinAttenuation] =
                newCharacteristicData[DataKey.currentAttenuation] ?? '';
            newCharacteristicData[DataKey.historicalMaxAttenuation] =
                newCharacteristicData[DataKey.currentAttenuation] ?? '';
            newCharacteristicData[DataKey.minVoltage] =
                newCharacteristicData[DataKey.currentVoltage] ?? '';
            newCharacteristicData[DataKey.maxVoltage] =
                newCharacteristicData[DataKey.currentVoltage] ?? '';
            newCharacteristicData[DataKey.minVoltageRipple] =
                newCharacteristicData[DataKey.currentVoltageRipple] ?? '';
            newCharacteristicData[DataKey.maxVoltageRipple] =
                newCharacteristicData[DataKey.currentVoltageRipple] ?? '';
          }

          emit(state.copyWith(
            loadingStatus: FormStatus.requestSuccess,
            characteristicData: newCharacteristicData,
            dateValueCollectionOfLog: dateValueCollectionOfLog,
          ));
        } else if (i == 9) {
          // 取得 event 資料完成
          // emit(state.copyWith(
          //   loadingStatus: FormStatus.requestSuccess,
          // ));
        }
      } else {
        emit(state.copyWith(
          loadingStatus: FormStatus.requestFailure,
          characteristicData: state.characteristicData,
          errorMassage: 'Data loading failed',
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

    if (state.device != null) {
      _dsimRepository.connectToDevice(state.device!);

      _connectionReportStreamSubscription =
          _dsimRepository.connectionStateReport.listen((connectionReport) {
        add(DeviceConnectionChanged(connectionReport));
      });
    } else {
      _scanStreamSubscription =
          _dsimRepository.scannedDevices.listen((scanReport) async {
        add(DiscoveredDeviceChanged(scanReport));
      });
    }
  }

  // void _onDataExported(
  //   DataExported event,
  //   Emitter<HomeState> emit,
  // ) async {
  //   emit(state.copyWith(
  //     dataShareStatus: FormStatus.none,
  //     dataExportStatus: FormStatus.requestInProgress,
  //   ));

  //   final List<dynamic> result = await _dsimRepository.exportRecords();

  //   if (result[0]) {
  //     emit(state.copyWith(
  //       dataExportStatus: FormStatus.requestSuccess,
  //       dataExportPath: result[2],
  //     ));
  //   } else {
  //     emit(state.copyWith(
  //       dataExportStatus: FormStatus.requestFailure,
  //       dataExportPath: result[2],
  //     ));
  //   }
  // }

  // void _onDataShared(
  //   DataShared event,
  //   Emitter<HomeState> emit,
  // ) async {
  //   emit(state.copyWith(
  //     dataExportStatus: FormStatus.none,
  //     dataShareStatus: FormStatus.requestInProgress,
  //   ));

  //   final List<dynamic> result = await _dsimRepository.exportRecords();

  //   if (result[0]) {
  //     emit(state.copyWith(
  //       dataShareStatus: FormStatus.requestSuccess,
  //       exportFileName: result[1],
  //       dataExportPath: result[2],
  //     ));
  //   } else {
  //     emit(state.copyWith(
  //       dataShareStatus: FormStatus.requestFailure,
  //       exportFileName: result[1],
  //       dataExportPath: result[2],
  //     ));
  //   }
  // }
}

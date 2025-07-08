import 'dart:async';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/connection_client_factory.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:aci_plus_app/repositories/code_repository.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftdi_serial/serial_device.dart';
import 'package:flutter_speed_chart/speed_chart.dart';
import 'package:intl/intl.dart';

// import 'package:assets_audio_player/assets_audio_player.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required ACIDeviceRepository aciDeviceRepository,
    required DsimRepository dsimRepository,
    required Amp18Repository amp18Repository,
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
    required FirmwareRepository firmwareRepository,
    required CodeRepository codeRepository,
    required UnitRepository unitRepository,
  })  : _aciDeviceRepository = aciDeviceRepository,
        _dsimRepository = dsimRepository,
        _amp18Repository = amp18Repository,
        _amp18CCorNodeRepository = amp18CCorNodeRepository,
        _firmwareRepository = firmwareRepository,
        _codeRepository = codeRepository,
        _unitRepository = unitRepository,
        super(const HomeState()) {
    on<SplashStateChanged>(_onSplashStateChanged);
    on<DiscoveredDeviceChanged>(_onDiscoveredDeviceChanged);
    on<DeviceSelected>(_onDeviceSelected);
    on<DeviceSelectionCanceled>(_onDeviceSelectionCanceled);
    on<DataRequested>(_onDataRequested);
    on<Data18Requested>(_onData18Requested);
    on<Data18CCorNodeRequested>(_onData18CCorNodeRequested);
    on<EventRequested>(_onEventRequested);
    on<DeviceCharacteristicChanged>(_onDeviceCharacteristicChanged);
    on<DeviceRefreshed>(_onDeviceRefreshed);
    on<DeviceConnectionChanged>(_onDeviceConnectionChanged);
    on<DevicePeriodicUpdateRequested>(_onDevicePeriodicUpdateRequested);
    on<DevicePeriodicUpdateCanceled>(_onDevicePeriodicUpdateCanceled);
    on<DevicePeriodicUpdate>(_onDevicePeriodicUpdate);
    on<ModeChanged>(_onModeChanged);
    on<USBAttached>(_onUSBAttached);
    on<ConnectionTypeChanged>(_onConnectionTypeChanged);
  }

  final ACIDeviceRepository _aciDeviceRepository;
  final DsimRepository _dsimRepository;
  final Amp18Repository _amp18Repository;
  final Amp18CCorNodeRepository _amp18CCorNodeRepository;
  final FirmwareRepository _firmwareRepository;
  final CodeRepository _codeRepository;
  final UnitRepository _unitRepository;
  StreamSubscription<ScanReport>? _scanStreamSubscription;
  StreamSubscription<ConnectionReport>? _connectionReportStreamSubscription;
  StreamSubscription<Map<DataKey, String>>?
      _characteristicDataStreamSubscription;

  Timer? _timer;
  final List<String> fakeData = [
    '1.8',
    '1.2',
    '1.8',
    '1.2',
    '1.2',
    '1.8',
    '1.8',
    '1.2'
  ];
  String fakePreviousCEQ = '';

  // final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  // Future<void> _onTestTimeout(
  //   testTimeout event,
  //   Emitter<HomeState> emit,
  // ) async {
  //   try {
  //     // Future result = await _dsimRepository.getCompleter();
  //     _dsimRepository.testTimeout();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // 進入首頁時播放動畫，動畫播完後掃描藍芽裝置
  Future<void> _onSplashStateChanged(
    SplashStateChanged event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      showSplash: false,
      scanStatus: FormStatus.requestInProgress,
      connectionStatus: FormStatus.requestInProgress,
      loadingStatus: FormStatus.requestInProgress,
    ));

    ConnectionClientFactory.connectionTypeStream.listen((connectionType) {
      add(ConnectionTypeChanged(connectionType));
    });

    ConnectionType connectionType = _aciDeviceRepository.checkConnectionType();

    if (connectionType == ConnectionType.usb) {
      add(const USBAttached());
    } else {
      // BLE 連線
      _scanStreamSubscription = _aciDeviceRepository.scanReport.listen(
        (scanReport) {
          print(scanReport);
          add(DiscoveredDeviceChanged(scanReport));
        },
      );
    }
  }

  void _onConnectionTypeChanged(
    ConnectionTypeChanged event,
    Emitter<HomeState> emit,
  ) {
    print('ConnectionTypeChanged: ${event.connectionType}');
    if (event.connectionType == ConnectionType.usb) {
      if (state.connectionStatus.isRequestFailure ||
          state.connectionStatus.isNone) {
        add(const DeviceRefreshed());
      }
    }
  }

  void _onUSBAttached(
    USBAttached event,
    Emitter<HomeState> emit,
  ) async {
    SerialDevice serialDevice = await _aciDeviceRepository.getUsbDevice();
    Peripheral peripheral = Peripheral(
      id: serialDevice.vendorId.toString(),
      name: serialDevice.deviceName,
    );

    _connectionReportStreamSubscription =
        _aciDeviceRepository.connectionStateReport.listen((connectionReport) {
      print('connectionReport : ${connectionReport.connectStatus}');
      add(DeviceConnectionChanged(connectionReport));
    });
    _aciDeviceRepository.connectToDevice(peripheral);

    emit(state.copyWith(
      showSplash: false,
      scanStatus: FormStatus.requestSuccess,
      connectionStatus: FormStatus.requestInProgress,
      loadingStatus: FormStatus.requestInProgress,
      connectionType: ConnectionType.usb,
      device: peripheral,
    ));
  }

  Future<void> _onDiscoveredDeviceChanged(
    DiscoveredDeviceChanged event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      connectionType: ConnectionType.ble,
    ));

    switch (event.scanReport.scanStatus) {
      case ScanStatus.scanning:
        List<Peripheral> peripherals = List.from(state.peripherals);

        if (event.scanReport.peripheral != null) {
          bool isExist = false;
          for (int i = 0; i < peripherals.length; i++) {
            Peripheral peripheral = peripherals[i];
            if (peripheral.name == event.scanReport.peripheral!.name) {
              isExist = true;
              peripherals[i] = event.scanReport.peripheral!;
              break;
            }
          }

          if (!isExist) {
            peripherals.add(event.scanReport.peripheral!);
          }
        }

        emit(state.copyWith(
          scanStatus: FormStatus.requestInProgress,
          connectionStatus: FormStatus.requestInProgress,
          loadingStatus: FormStatus.requestInProgress,
          peripherals: peripherals,
        ));

      // print('=====Peripherals======');
      // print(peripherals.length);
      // for (Peripheral peripheral in peripherals) {
      //   print('P: ${peripheral.name}, ${peripheral.rssi}');
      // }
      // print('======================');

      // _connectionReportStreamSubscription =
      //     _dsimRepository.connectionStateReport.listen((connectionReport) {
      //   add(DeviceConnectionChanged(connectionReport));
      // });

      // _dsimRepository.connectToDevice(event.scanReport.discoveredDevice!);

      // _connectionReportStreamSubscription = _aciDeviceRepository
      //     .connectionStateReport
      //     .listen((connectionReport) {
      //   add(DeviceConnectionChanged(connectionReport));
      // });

      // _aciDeviceRepository.connectToDevice();
      case ScanStatus.complete:
        if (state.peripherals.isEmpty) {
          emit(state.copyWith(
              scanStatus: FormStatus.requestFailure,
              connectionStatus: FormStatus.requestFailure,
              loadingStatus: FormStatus.requestFailure,
              device: const Peripheral.empty(),
              errorMassage: 'Device not found.'));
        }
        // else if (state.peripherals.length == 1) {
        //   emit(state.copyWith(
        //     scanStatus: FormStatus.requestSuccess,
        //     connectionStatus: FormStatus.requestInProgress,
        //     loadingStatus: FormStatus.requestInProgress,
        //     device: state.peripherals[0],
        //   ));

        //   _connectionReportStreamSubscription = _aciDeviceRepository
        //       .connectionStateReport
        //       .listen((connectionReport) {
        //     print('received connectionReport');
        //     add(DeviceConnectionChanged(connectionReport));
        //   });

        //   _aciDeviceRepository.closeScanStream();
        //   _aciDeviceRepository.connectToDevice(state.peripherals[0]);
        // }
        else {
          emit(state.copyWith(
            scanStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestInProgress,
            loadingStatus: FormStatus.requestInProgress,
            device: const Peripheral.empty(),
          ));
        }

        break;
      case ScanStatus.failure:
        emit(state.copyWith(
            scanStatus: FormStatus.requestFailure,
            connectionStatus: FormStatus.requestFailure,
            loadingStatus: FormStatus.requestFailure,
            device: const Peripheral.empty(),
            errorMassage: 'Device not found.'));
        break;
      case ScanStatus.disable:
        emit(state.copyWith(
            scanStatus: FormStatus.requestFailure,
            connectionStatus: FormStatus.requestFailure,
            loadingStatus: FormStatus.requestFailure,
            device: const Peripheral.empty(),
            errorMassage: 'Bluetooth is disabled.'));
        break;
    }

    // await _dsimRepository.closeScanStream();

    // await _aciDeviceRepository.closeScanStream();

    // if (_scanStreamSubscription != null) {
    //   await _scanStreamSubscription?.cancel();
    //   _scanStreamSubscription = null;
    //   print('_scanStreamSubscription closed');
    // }
  }

  void _onDeviceSelected(
    DeviceSelected event,
    Emitter<HomeState> emit,
  ) {
    _connectionReportStreamSubscription =
        _aciDeviceRepository.connectionStateReport.listen((connectionReport) {
      add(DeviceConnectionChanged(connectionReport));
    });

    _aciDeviceRepository.closeScanStream();
    _aciDeviceRepository.connectToDevice(event.peripheral);

    emit(state.copyWith(
      scanStatus: FormStatus.requestSuccess,
      connectionStatus: FormStatus.requestInProgress,
      loadingStatus: FormStatus.requestInProgress,
      device: event.peripheral,
    ));
  }

  void _onDeviceSelectionCanceled(
    DeviceSelectionCanceled event,
    Emitter<HomeState> emit,
  ) {
    _aciDeviceRepository.closeScanStream();

    emit(state.copyWith(
      scanStatus: FormStatus.none,
      connectionStatus: FormStatus.none,
      loadingStatus: FormStatus.none,
      device: const Peripheral.empty(),
    ));
  }

  Future<void> _onDeviceConnectionChanged(
    DeviceConnectionChanged event,
    Emitter<HomeState> emit,
  ) async {
    switch (event.connectionReport.connectStatus) {
      case ConnectStatus.connecting:
        // emit(state.copyWith(
        //   scanStatus: FormStatus.requestSuccess,
        //   connectionStatus: FormStatus.requestInProgress,
        // ));
        break;
      case ConnectStatus.connected:
        emit(state.copyWith(
          scanStatus: FormStatus.requestSuccess,
          connectionStatus: FormStatus.requestSuccess,
          loadingStatus: FormStatus.requestInProgress,
        ));

        List<dynamic> result = await _aciDeviceRepository.getACIDeviceType(
            deviceId: state.device.id);

        if (result[0]) {
          ACIDeviceType aciDeviceType = result[1];
          emit(state.copyWith(
            scanStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestSuccess,
            loadingStatus: FormStatus.requestInProgress,
            aciDeviceType: aciDeviceType,
          ));

          if (aciDeviceType == ACIDeviceType.amp1P8G) {
            print('1.8G _characteristicDataStreamSubscription');
            _amp18Repository.createCharacteristicDataStream();
            add(const Data18Requested());

            //當在設定頁面設定資料時, 用來更新Information page 對應的資料欄位
            _characteristicDataStreamSubscription =
                _amp18Repository.characteristicData.listen(
              (data) {
                add(DeviceCharacteristicChanged(data));
              },
              onDone: () {},
            );
          } else if (aciDeviceType == ACIDeviceType.ampCCorNode1P8G) {
            print('1.8G _characteristicDataStreamSubscription');
            _amp18CCorNodeRepository.createCharacteristicDataStream();
            add(const Data18CCorNodeRequested());
            //當在設定頁面設定資料時, 用來更新Information page 對應的資料欄位
            _characteristicDataStreamSubscription =
                _amp18CCorNodeRepository.characteristicData.listen(
              (data) {
                add(DeviceCharacteristicChanged(data));
              },
              onDone: () {},
            );
          } else {
            print('1G/1.2G _characteristicDataStreamSubscription');
            _dsimRepository.createCharacteristicDataStream();
            add(const DataRequested());

            //當在設定頁面設定資料時, 用來更新Information page 對應的資料欄位
            _characteristicDataStreamSubscription =
                _dsimRepository.characteristicData.listen(
              (data) {
                add(DeviceCharacteristicChanged(data));
              },
              onDone: () {},
            );
          }
        } else {
          emit(state.copyWith(
            scanStatus: FormStatus.requestSuccess,
            connectionStatus: FormStatus.requestSuccess,
            loadingStatus: FormStatus.requestFailure,
            characteristicData: state.characteristicData,
            errorMassage: 'Failed to load data',
          ));
        }

        break;
      case ConnectStatus.disconnecting:
        // emit(state.copyWith(
        //   scanStatus: FormStatus.requestSuccess,
        //   connectionStatus: FormStatus.requestFailure,
        //   // loadingStatus: FormStatus.requestFailure,
        // ));
        break;
      case ConnectStatus.disconnected:
        // emit(state.copyWith(
        //   scanStatus: FormStatus.requestSuccess,
        //   connectionStatus: FormStatus.requestFailure,
        //   loadingStatus: FormStatus.none,
        //   errorMassage: 'Device connection failed',
        // ));

        // 藍牙斷線時停止定期更新
        _cancelUpdateTimer();
        _amp18Repository.clearCharacteristics();
        _amp18CCorNodeRepository.clearCharacteristics();

        emit(state.copyWith(
          scanStatus: FormStatus.requestFailure,
          connectionStatus: FormStatus.requestFailure,
          loadingStatus: FormStatus.requestFailure,
          errorMassage: event.connectionReport.errorMessage,
          peripherals: [],
          device: const Peripheral.empty(),
          periodicUpdateEnabled: false,
          characteristicData: const {},
          dateValueCollectionOfLog: const [],
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
    newCharacteristicData.addEntries(event.dataMap.entries);
    emit(state.copyWith(
      characteristicData: newCharacteristicData,
    ));
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

      for (int i = 0; i < 16; i++) ...[
        _dsimRepository.requestCommandForLogChunk
      ]
      // _dsimRepository.requestCommand14To29,
      // _dsimRepository.requestCommand30To37,
    ];

    for (int i = 0; i < requestCommands.length; i++) {
      List<dynamic> result = [];
      if (i >= 8) {
        result = await requestCommands[i](i + 6);
      } else {
        result = await requestCommands[i]();
      }
      if (result[0]) {
        switch (i) {
          case 0:
            // 因為 state 是 immutable, 所以要創一個新的 map, copy 原來的 element, 加上新的 element,
            // emit 的 state 才算新的, 才會觸發 bloc builder
            Map<DataKey, String> newCharacteristicData = {};
            newCharacteristicData[DataKey.partName] = result[1];
            emit(state.copyWith(
              characteristicData: newCharacteristicData,
            ));
            break;
          case 1:
            Map<DataKey, String> newCharacteristicData = {};
            newCharacteristicData.addEntries(state.characteristicData.entries);
            newCharacteristicData[DataKey.partNo] = result[1];
            newCharacteristicData[DataKey.hasDualPilot] = result[2];

            emit(state.copyWith(
              characteristicData: newCharacteristicData,
            ));
            break;
          case 2:
            Map<DataKey, String> newCharacteristicData = {};
            newCharacteristicData.addEntries(state.characteristicData.entries);
            newCharacteristicData[DataKey.serialNumber] = result[1];
            emit(state.copyWith(
              characteristicData: newCharacteristicData,
            ));
            break;
          case 3:
            Map<DataKey, String> newCharacteristicData = {};
            newCharacteristicData.addEntries(state.characteristicData.entries);
            newCharacteristicData[DataKey.logInterval] = result[1];
            newCharacteristicData[DataKey.firmwareVersion] = result[2];
            emit(state.copyWith(
              characteristicData: newCharacteristicData,
            ));
            break;
          case 4:
            Map<DataKey, String> newCharacteristicData = {};
            newCharacteristicData.addEntries(state.characteristicData.entries);
            newCharacteristicData[DataKey.currentAttenuation] = result[1];
            newCharacteristicData[DataKey.minAttenuation] = result[2];
            newCharacteristicData[DataKey.maxAttenuation] = result[3];
            newCharacteristicData[DataKey.tgcCableLength] = result[4];
            emit(state.copyWith(
              characteristicData: newCharacteristicData,
            ));
            break;
          case 5:
            Map<DataKey, String> newCharacteristicData = {};
            newCharacteristicData.addEntries(state.characteristicData.entries);
            newCharacteristicData[DataKey.workingMode] = result[1];
            newCharacteristicData[DataKey.currentPilot] = result[2];
            newCharacteristicData[DataKey.currentPilotMode] = result[3];
            newCharacteristicData[DataKey.alarmRSeverity] = result[4];
            newCharacteristicData[DataKey.alarmTSeverity] = result[5];
            newCharacteristicData[DataKey.alarmPSeverity] = result[6];
            newCharacteristicData[DataKey.currentTemperatureF] = result[7];
            newCharacteristicData[DataKey.currentTemperatureC] = result[8];
            newCharacteristicData[DataKey.currentVoltage] = result[9];
            emit(state.copyWith(
              characteristicData: newCharacteristicData,
            ));
            break;
          case 6:
            Map<DataKey, String> newCharacteristicData = {};
            newCharacteristicData.addEntries(state.characteristicData.entries);
            newCharacteristicData[DataKey.centerAttenuation] = result[1];
            newCharacteristicData[DataKey.currentVoltageRipple] = result[2];
            emit(state.copyWith(
              characteristicData: newCharacteristicData,
            ));
            break;
          case 7:
            Map<DataKey, String> newCharacteristicData = {};
            newCharacteristicData.addEntries(state.characteristicData.entries);
            newCharacteristicData[DataKey.location] = result[1];
            emit(state.copyWith(
              characteristicData: newCharacteristicData,
            ));
            break;
          case 8:
          case 9:
          case 10:
          case 11:
          case 12:
          case 13:
          case 14:
          case 15:
          case 16:
          case 17:
          case 18:
          case 19:
          case 20:
          case 21:
          case 22:
            // request log command 14 ~ 29
            Map<DataKey, String> newCharacteristicData = {};
            newCharacteristicData.addEntries(state.characteristicData.entries);
            List<List<ValuePair>> dateValueCollectionOfLog =
                _dsimRepository.getDateValueCollectionOfLogs();

            emit(state.copyWith(
              characteristicData: newCharacteristicData,
              dateValueCollectionOfLog: dateValueCollectionOfLog,
            ));
            break;
          case 23:
            Map<DataKey, String> newCharacteristicData = {};
            newCharacteristicData.addEntries(state.characteristicData.entries);

            List<List<ValuePair>> dateValueCollectionOfLog =
                _dsimRepository.getDateValueCollectionOfLogs();

            List<ValuePair> allValues = dateValueCollectionOfLog
                .expand(
                  (dateValuePair) => dateValuePair,
                )
                .toList();

            if (allValues.isNotEmpty) {
              newCharacteristicData[DataKey.minTemperatureF] = result[1];
              newCharacteristicData[DataKey.maxTemperatureF] = result[2];
              newCharacteristicData[DataKey.minTemperatureC] = result[3];
              newCharacteristicData[DataKey.maxTemperatureC] = result[4];
              newCharacteristicData[DataKey.historicalMinAttenuation] =
                  result[5];
              newCharacteristicData[DataKey.historicalMaxAttenuation] =
                  result[6];
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
            break;
        }
      } else {
        emit(state.copyWith(
          loadingStatus: FormStatus.requestFailure,
          characteristicData: state.characteristicData,
          errorMassage: 'Failed to load data',
        ));
        break;
      }
    }
  }

  Future<void> _writeFirmwareUpdateLog({
    required int previousFirmwareVersion,
    required int currentFirmwareVersion,
  }) async {
    List<dynamic> resultOgGetUpdateLogs =
        await _firmwareRepository.requestCommand1p8GUpdateLogs();

    if (resultOgGetUpdateLogs[0]) {
      List<UpdateLog> updateLogs = resultOgGetUpdateLogs[1];
      String userCode = await _codeRepository.readUserCode();

      UpdateLog updateLog = UpdateLog(
        type: currentFirmwareVersion >= previousFirmwareVersion
            ? UpdateType.upgrade
            : UpdateType.downgrade,
        dateTime: DateTime.now(),
        firmwareVersion: currentFirmwareVersion.toString(),
        technicianID: userCode,
      );

      // 滿 32 筆時清除最舊的一筆
      if (updateLogs.length == 32) {
        updateLogs.removeLast();
      }
      updateLogs.insert(0, updateLog);

      await _firmwareRepository.set1p8GFirmwareUpdateLogs(updateLogs);
    } else {}
  }

  Future<void> _onData18Requested(
    Data18Requested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      loadingStatus: FormStatus.requestInProgress,
      characteristicData: {},
    ));

    ConnectionType connectionType = _aciDeviceRepository.checkConnectionType();

    if (connectionType == ConnectionType.usb) {
      // await _amp18Repository.set1p8GMTU(244);
      await _amp18Repository.set1p8GTransmitDelayTime(ms: 30);
    } else {
      // BLE 連線時, 根據 RSSI 設定 delay
      await _amp18Repository.set1p8GTransmitDelayTime();
    }

    Map<DataKey, String> newCharacteristicData = {};
    List<dynamic> resultOf1p8G0 = [];
    List<dynamic> resultOf1p8G1 = [];
    List<dynamic> resultOf1p8G2 = [];
    List<dynamic> resultOf1p8G3 = [];
    List<dynamic> resultOf1p8GForLogChunk = [];
    List<dynamic> resultOf1p8GUserAttribute = [];

    // 處理 resultOf1p8G0 讀取
    resultOf1p8G0 = await _amp18Repository.requestCommand1p8G0();
    if (resultOf1p8G0[0]) {
      Map<DataKey, String> characteristicDataOf1p8G0 = resultOf1p8G0[1];

      // 如果是 firmware update 完成之後, 重新讀取資料時才判斷版本並寫入 firmware update log
      if (event.isFirmwareUpdated) {
        int currentFirmwareVersion = convertFirmwareVersionStringToInt(
            characteristicDataOf1p8G0[DataKey.firmwareVersion] ?? '0');

        if (currentFirmwareVersion >= 148) {
          await _writeFirmwareUpdateLog(
            previousFirmwareVersion: FirmwareUpdateProperty.previousVersion,
            currentFirmwareVersion: currentFirmwareVersion,
          );
        }
      }

      // 讀取時將 firmware version 存入 FirmwareUpdateProperty.previousVersion (global variable)
      FirmwareUpdateProperty.previousVersion =
          convertFirmwareVersionStringToInt(
              characteristicDataOf1p8G0[DataKey.firmwareVersion] ?? '0');

      newCharacteristicData.addAll(characteristicDataOf1p8G0);
      emit(state.copyWith(
        characteristicData: newCharacteristicData,
      ));
    } else {
      emit(state.copyWith(
        loadingStatus: FormStatus.requestFailure,
        characteristicData: state.characteristicData,
        errorMassage: 'Device connection failed',
      ));

      return;
    }

    // 處理 resultOf1p8G1 讀取
    resultOf1p8G1 = await _amp18Repository.requestCommand1p8G1();
    if (resultOf1p8G1[0]) {
      int logInterval = int.parse(resultOf1p8G1[1][DataKey.logInterval]);
      int rfOutputLogInterval =
          int.parse(resultOf1p8G1[1][DataKey.rfOutputLogInterval]);

      bool needUpdateLogInterval = false;
      bool needUpdateRFOutputLogInterval = false;
      bool isUpdateLogInterval = false;
      bool isUpdateRFOutputLogInterval = false;

      // 如果讀取到 logInterval < 5, 則自動設定為 30 分鐘
      if (logInterval < 5) {
        needUpdateLogInterval = true;
        isUpdateLogInterval = await _amp18Repository.set1p8GLogInterval('30');

        if (!isUpdateLogInterval) {
          emit(state.copyWith(
            loadingStatus: FormStatus.requestFailure,
            characteristicData: state.characteristicData,
            errorMassage: 'Device connection failed',
          ));

          return;
        }
      }

      // 如果讀取到 RFOutputLogInterval < 30, 則自動設定為 30 分鐘
      if (rfOutputLogInterval < 30) {
        needUpdateRFOutputLogInterval = true;
        isUpdateRFOutputLogInterval =
            await _amp18Repository.set1p8GRFOutputLogInterval('30');

        if (!isUpdateRFOutputLogInterval) {
          emit(state.copyWith(
            loadingStatus: FormStatus.requestFailure,
            characteristicData: state.characteristicData,
            errorMassage: 'Device connection failed',
          ));

          return;
        }
      }

      // 當 LogInterval 或 RFOutputLogInterval 有被設定時, 再讀取一次獲取新的值
      if (needUpdateLogInterval || needUpdateRFOutputLogInterval) {
        List<dynamic> newResultOf1p8G1 =
            await _amp18Repository.requestCommand1p8G1();

        if (newResultOf1p8G1[0]) {
          newCharacteristicData.addAll(newResultOf1p8G1[1]);
          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
        } else {
          emit(state.copyWith(
            loadingStatus: FormStatus.requestFailure,
            characteristicData: state.characteristicData,
            errorMassage: 'Device connection failed',
          ));

          return;
        }
      } else {
        newCharacteristicData.addAll(resultOf1p8G1[1]);
        emit(state.copyWith(
          characteristicData: newCharacteristicData,
        ));
      }
    } else {
      emit(state.copyWith(
        loadingStatus: FormStatus.requestFailure,
        characteristicData: state.characteristicData,
        errorMassage: 'Device connection failed',
      ));

      return;
    }

    // 處理 resultOf1p8G2 讀取
    resultOf1p8G2 = await _amp18Repository.requestCommand1p8G2();

    if (resultOf1p8G2[0]) {
      ForwardCEQFlag.forwardCEQType = getCEQTypeFromForwardCEQIndex(
          resultOf1p8G2[1][DataKey.currentForwardCEQIndex] ?? '255');
      newCharacteristicData.addAll(resultOf1p8G2[1]);
      emit(state.copyWith(
        characteristicData: newCharacteristicData,
      ));
    } else {
      emit(state.copyWith(
        loadingStatus: FormStatus.requestFailure,
        characteristicData: state.characteristicData,
        errorMassage: 'Device connection failed',
      ));

      return;
    }

    // 處理 requestCommand1p8G3 RFInOut 讀取
    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      // if (connectionType == ConnectionType.ble) {
      //   // 根據RSSI設定每個 chunk 之間的 delay
      //   await _amp18Repository.set1p8GTransmitDelayTime();
      // }

      resultOf1p8G3 = await _amp18Repository.requestCommand1p8G3();

      if (resultOf1p8G3[0]) {
        newCharacteristicData.addAll(resultOf1p8G3[2]);

        emit(state.copyWith(
          characteristicData: newCharacteristicData,
        ));

        break;
      } else {
        if (i == 2) {
          emit(state.copyWith(
            loadingStatus: FormStatus.requestFailure,
            characteristicData: state.characteristicData,
            errorMassage: 'Device connection failed',
          ));
          return;
        }
      }
    }

    int firmwareVersion = convertFirmwareVersionStringToInt(
        newCharacteristicData[DataKey.firmwareVersion] ?? '0');

    if (firmwareVersion >= 148) {
      // 最多 retry 3 次, 連續失敗3次就視為失敗
      // 處理 resultOf1p8GUserAttribute 讀取
      for (int i = 0; i < 3; i++) {
        //休息一段時間再讀取, 比較不會有 data 收不完整的情況發生
        await Future.delayed(const Duration(milliseconds: 1000));

        resultOf1p8GUserAttribute =
            await _amp18Repository.requestCommand1p8GUserAttribute();

        if (resultOf1p8GUserAttribute[0]) {
          newCharacteristicData.addAll(resultOf1p8GUserAttribute[1]);
          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
          break;
        } else {
          if (i == 2) {
            emit(state.copyWith(
              loadingStatus: FormStatus.requestFailure,
              characteristicData: state.characteristicData,
              errorMassage: 'Device connection failed',
            ));
            return;
          }
        }
      }
    }

    // usb 連線時, 讀取 log chunk 時需要額外的 delay, 否則會傳出多餘的資料
    await Future.delayed(const Duration(milliseconds: 1000));

    // 處理 requestCommand1p8GForLogChunk 讀取
    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      // if (connectionType == ConnectionType.ble) {
      //   // 根據RSSI設定每個 chunk 之間的 delay
      //   await _amp18Repository.set1p8GTransmitDelayTime();
      // }

      //休息一段時間再讀取, 比較不會有 data 收不完整的情況發生
      await Future.delayed(const Duration(milliseconds: 1000));
      resultOf1p8GForLogChunk =
          await _amp18Repository.requestCommand1p8GForLogChunk(0);

      if (resultOf1p8GForLogChunk[0]) {
        newCharacteristicData.addAll(resultOf1p8GForLogChunk[3]);

        emit(state.copyWith(
          characteristicData: newCharacteristicData,
        ));

        break;
      } else {
        if (i == 2) {
          emit(state.copyWith(
            loadingStatus: FormStatus.requestFailure,
            characteristicData: state.characteristicData,
            errorMassage: 'Device connection failed',
          ));

          return;
        }
      }
    }

    // 讀取本地時區的日期時間
    String nowDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // 寫入目前日期時間 年yyyy 月MM 日dd 時HH 分mm
    await _amp18Repository.set1p8GNowDateTime(
      nowDateTime,
    );

    // 執行完上面的 寫入日期 後休息一段時間再進行任何讀取動作 比較不會有 data 收不完整的情況發生
    await Future.delayed(const Duration(milliseconds: 1000));

    emit(state.copyWith(
      loadingStatus: FormStatus.requestSuccess,
    ));
  }

  Future<void> _onData18CCorNodeRequested(
    Data18CCorNodeRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      loadingStatus: FormStatus.requestInProgress,
      characteristicData: {},
    ));

    ConnectionType connectionType = _aciDeviceRepository.checkConnectionType();

    if (connectionType == ConnectionType.usb) {
      await _amp18Repository.set1p8GTransmitDelayTime(ms: 58);
    } else {
      // BLE 連線時, 根據 RSSI 設定 delay
      await _amp18Repository.set1p8GTransmitDelayTime();
    }

    Map<DataKey, String> newCharacteristicData = {};
    List<dynamic> resultOf1p8GCCorNode80 = [];
    List<dynamic> resultOf1p8GCCorNode91 = [];
    List<dynamic> resultOf1p8GCCorNode92 = [];
    List<dynamic> resultOf1p8GCCorNodeA1 = [];
    List<dynamic> resultOf1p8GCCorNodeUserAttribute = [];
    List<dynamic> resultOf1p8GCCorNodeLogChunk = [];

    // 處理 resultOf1p8GCCorNode80 讀取
    resultOf1p8GCCorNode80 =
        await _amp18CCorNodeRepository.requestCommand1p8GCCorNode80();
    if (resultOf1p8GCCorNode80[0]) {
      Map<DataKey, String> characteristicDataOf1p8GCCorNode80 =
          resultOf1p8GCCorNode80[1];

      // 如果是 firmware update 完成之後, 重新讀取資料時才判斷版本並寫入 firmware update log
      if (event.isFirmwareUpdated) {
        int currentFirmwareVersion = convertFirmwareVersionStringToInt(
            characteristicDataOf1p8GCCorNode80[DataKey.firmwareVersion] ?? '0');

        if (currentFirmwareVersion >= 148) {
          await _writeFirmwareUpdateLog(
            previousFirmwareVersion: FirmwareUpdateProperty.previousVersion,
            currentFirmwareVersion: currentFirmwareVersion,
          );
        }
      }

      // 讀取時將 firmware version 存入 FirmwareUpdateProperty.previousVersion (global variable)
      FirmwareUpdateProperty.previousVersion =
          convertFirmwareVersionStringToInt(
              characteristicDataOf1p8GCCorNode80[DataKey.firmwareVersion] ??
                  '0');

      newCharacteristicData.addAll(characteristicDataOf1p8GCCorNode80);
      emit(state.copyWith(
        characteristicData: newCharacteristicData,
      ));
    } else {
      emit(state.copyWith(
        loadingStatus: FormStatus.requestFailure,
        characteristicData: state.characteristicData,
        errorMassage: 'Device connection failed',
      ));

      return;
    }

    // 處理 resultOf1p8GCCorNode91 讀取
    resultOf1p8GCCorNode91 =
        await _amp18CCorNodeRepository.requestCommand1p8GCCorNode91();

    if (resultOf1p8GCCorNode91[0]) {
      int logInterval =
          int.parse(resultOf1p8GCCorNode91[1][DataKey.logInterval]);

      // 如果讀取到 logInterval < 5, 則自動設定為 30 分鐘
      if (logInterval < 5) {
        bool isSuccess =
            await _amp18CCorNodeRepository.set1p8GCCorNodeLogInterval('30');

        if (isSuccess) {
          List<dynamic> newResultOf1p8GCCorNode91 =
              await _amp18CCorNodeRepository.requestCommand1p8GCCorNode91();

          if (newResultOf1p8GCCorNode91[0]) {
            newCharacteristicData.addAll(newResultOf1p8GCCorNode91[1]);
            emit(state.copyWith(
              characteristicData: newCharacteristicData,
            ));
          } else {
            emit(state.copyWith(
              loadingStatus: FormStatus.requestFailure,
              characteristicData: state.characteristicData,
              errorMassage: 'Device connection failed',
            ));

            return;
          }
        }
      } else {
        newCharacteristicData.addAll(resultOf1p8GCCorNode91[1]);
        emit(state.copyWith(
          characteristicData: newCharacteristicData,
        ));
      }
    } else {
      emit(state.copyWith(
        loadingStatus: FormStatus.requestFailure,
        characteristicData: state.characteristicData,
        errorMassage: 'Device connection failed',
      ));

      return;
    }

    // 處理 resultOf1p8GCCorNode92 讀取
    resultOf1p8GCCorNode92 =
        await _amp18CCorNodeRepository.requestCommand1p8GCCorNode92();

    if (resultOf1p8GCCorNode92[0]) {
      newCharacteristicData.addAll(resultOf1p8GCCorNode92[1]);
      emit(state.copyWith(
        characteristicData: newCharacteristicData,
      ));
    } else {
      emit(state.copyWith(
        loadingStatus: FormStatus.requestFailure,
        characteristicData: state.characteristicData,
        errorMassage: 'Device connection failed',
      ));

      return;
    }

    // 處理 resultOf1p8GCCorNodeA1 讀取
    resultOf1p8GCCorNodeA1 =
        await _amp18CCorNodeRepository.requestCommand1p8GCCorNodeA1();

    if (resultOf1p8GCCorNodeA1[0]) {
      newCharacteristicData.addAll(resultOf1p8GCCorNodeA1[1]);
      emit(state.copyWith(
        characteristicData: newCharacteristicData,
      ));
    } else {
      emit(state.copyWith(
        loadingStatus: FormStatus.requestFailure,
        characteristicData: state.characteristicData,
        errorMassage: 'Device connection failed',
      ));

      return;
    }

    int firmwareVersion = convertFirmwareVersionStringToInt(
        newCharacteristicData[DataKey.firmwareVersion] ?? '0');

    if (firmwareVersion >= 148) {
      // 最多 retry 3 次, 連續失敗3次就視為失敗
      // 處理 resultOf1p8GCCorNodeUserAttribute 讀取
      for (int i = 0; i < 3; i++) {
        //休息一段時間再讀取, 比較不會有 data 收不完整的情況發生
        await Future.delayed(const Duration(milliseconds: 1000));

        resultOf1p8GCCorNodeUserAttribute = await _amp18CCorNodeRepository
            .requestCommand1p8GCCorNodeUserAttribute();

        if (resultOf1p8GCCorNodeUserAttribute[0]) {
          newCharacteristicData.addAll(resultOf1p8GCCorNodeUserAttribute[1]);
          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
          break;
        } else {
          if (i == 2) {
            emit(state.copyWith(
              loadingStatus: FormStatus.requestFailure,
              characteristicData: state.characteristicData,
              errorMassage: 'Device connection failed',
            ));
            return;
          }
        }
      }
    }

    // usb 連線時, 讀取 log chunk 時需要額外的 delay, 否則會傳出多餘的資料
    await Future.delayed(const Duration(milliseconds: 1000));

    // 處理 requestCommand1p8GCCorNodeLogChunk 讀取
    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      // if (connectionType == ConnectionType.ble) {
      //   // 根據RSSI設定每個 chunk 之間的 delay
      //   await _amp18CCorNodeRepository.set1p8GCCorNodeTransmitDelayTime();
      // }

      //休息一段時間再讀取, 比較不會有 data 收不完整的情況發生
      await Future.delayed(const Duration(milliseconds: 1000));
      resultOf1p8GCCorNodeLogChunk =
          await _amp18CCorNodeRepository.requestCommand1p8GCCorNodeLogChunk(0);

      if (resultOf1p8GCCorNodeLogChunk[0]) {
        newCharacteristicData.addAll(resultOf1p8GCCorNodeLogChunk[3]);

        emit(state.copyWith(
          characteristicData: newCharacteristicData,
        ));

        break;
      } else {
        if (i == 2) {
          emit(state.copyWith(
            loadingStatus: FormStatus.requestFailure,
            characteristicData: state.characteristicData,
            errorMassage: 'Device connection failed',
          ));

          return;
        }
      }
    }

    // 讀取本地時區的日期時間
    String deviceNowTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // 寫入目前日期時間 年yyyy 月MM 日dd 時HH 分mm
    await _amp18CCorNodeRepository.set1p8GCCorNodeNowDateTime(deviceNowTime);

    // 執行完上面的 寫入日期 後休息一段時間再進行任何讀取動作 比較不會有 data 收不完整的情況發生
    await Future.delayed(const Duration(milliseconds: 1000));

    emit(state.copyWith(
      loadingStatus: FormStatus.requestSuccess,
    ));
  }

  Future<void> _onEventRequested(
    EventRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      eventLoadingStatus: FormStatus.requestInProgress,
    ));

    List<dynamic> result = await _dsimRepository.requestCommand30To37();

    if (result[0]) {
      // 取得 event 資料完成
      emit(state.copyWith(
        eventLoadingStatus: FormStatus.requestSuccess,
      ));
    } else {
      emit(state.copyWith(
        eventLoadingStatus: FormStatus.requestFailure,
      ));
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
      eventLoadingStatus: FormStatus.none,
      dataExportStatus: FormStatus.none,
      aciDeviceType: ACIDeviceType.undefined,
      peripherals: [],
      device: const Peripheral.empty(),
      periodicUpdateEnabled: false,
      characteristicData: const {},
      dateValueCollectionOfLog: const [],
    ));

    // 重新掃描與連線時停止定期更新
    _cancelUpdateTimer();
    _amp18Repository.clearCharacteristics();
    _amp18CCorNodeRepository.clearCharacteristics();

    _dsimRepository.clearCache();
    _dsimRepository.closeCharacteristicDataStream();
    _amp18Repository.closeCharacteristicDataStream();
    _amp18CCorNodeRepository.closeCharacteristicDataStream();
    print('cache cleaned');
    await _aciDeviceRepository.closeConnectionStream();
    print('connectionStream closed');

    if (_connectionReportStreamSubscription != null) {
      await _connectionReportStreamSubscription?.cancel();
      _connectionReportStreamSubscription = null;
      print('_connectionReportStreamSubscription closed');
    }

    if (_characteristicDataStreamSubscription != null) {
      await _characteristicDataStreamSubscription?.cancel();
      _characteristicDataStreamSubscription = null;
      print('_characteristicDataStreamSubscription closed');
    }

    // initialize client to determine if it is a USB or BLE connection
    await ConnectionClientFactory.initialize();

    _aciDeviceRepository.updateClient();
    _amp18Repository.updateClient();
    _amp18CCorNodeRepository.updateClient();
    _firmwareRepository.updateClient();

    ConnectionType connectionType = _aciDeviceRepository.checkConnectionType();

    if (connectionType == ConnectionType.usb) {
      add(const USBAttached());
    } else {
      // BLE 連線
      _scanStreamSubscription = _aciDeviceRepository.scanReport.listen(
        (scanReport) {
          print(scanReport);
          add(DiscoveredDeviceChanged(scanReport));
        },
      );
    }
  }

  void _onDevicePeriodicUpdateRequested(
    DevicePeriodicUpdateRequested event,
    Emitter<HomeState> emit,
  ) {
    //  啟動 timer 前先確定 timer 是關閉的
    _cancelUpdateTimer();

    // timer 啟動後 5 秒才會發 AlarmUpdated, 所以第0秒時先 AlarmUpdated

    String partId = state.characteristicData[DataKey.partId] ?? '';
    // add(DevicePeriodicUpdate(partId: partId));

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print('alarm trigger timer: ${timer.tick}');
      add(DevicePeriodicUpdate(partId: partId));
    });

    print('alarm trigger started');

    emit(state.copyWith(
      periodicUpdateEnabled: true,
    ));
  }

  Future<void> _onDevicePeriodicUpdate(
    DevicePeriodicUpdate event,
    Emitter<HomeState> emit,
  ) async {
    String partId = state.characteristicData[DataKey.partId] ?? '';
    if (partId == '4') {
      // CCor Node
      Stopwatch stopwatch = Stopwatch()..start();
      List<dynamic> resultOf1p8GCCorNodeA1 =
          await _amp18CCorNodeRepository.requestCommand1p8GCCorNodeA1(
        timeout: const Duration(seconds: 2),
      );
      print(
          'requestCommand1p8GCCorNodeA1() alarm executed in ${stopwatch.elapsed.inMilliseconds}');

      if (resultOf1p8GCCorNodeA1[0]) {
        Map<DataKey, String> currentValues = resultOf1p8GCCorNodeA1[1];
        _amp18CCorNodeRepository.updateDataWithGivenValuePairs(currentValues);
      } else {
        print('requestCommand1p8GCCorNodeA1() alarm updated failed');
      }
    } else {
      // Amp
      Stopwatch stopwatch1 = Stopwatch()..start();
      List<dynamic> resultOf1p8G1 = await _amp18Repository.requestCommand1p8G1(
        timeout: const Duration(seconds: 2),
      );
      stopwatch1.stop();
      print(
          'requestCommand1p8G1() alarm executed in ${stopwatch1.elapsed.inMilliseconds}');

      Stopwatch stopwatch2 = Stopwatch()..start();
      List<dynamic> resultOf1p8G2 = await _amp18Repository.requestCommand1p8G2(
        timeout: const Duration(seconds: 2),
      );
      stopwatch2.stop();
      print(
          'requestCommand1p8G2() alarm executed in ${stopwatch2.elapsed.inMilliseconds}');

      if (resultOf1p8G2[0]) {
        Map<DataKey, String> currentValues = resultOf1p8G2[1];
        _amp18Repository.updateDataWithGivenValuePairs(currentValues);

        /* 
        // 使用假資料測試 CEQStatus 的變化
        //
        // String currentForwardCEQ = fakeData[_timer!.tick % fakeData.length];

        // CEQStatus ceqStatus;
        // print('$fakePreviousCEQ, $currentForwardCEQ');
        // if (fakePreviousCEQ == '1.2' && currentForwardCEQ == '1.8') {
        //   ceqStatus = CEQStatus.from1P2GTo1P8G;
        // } else if (fakePreviousCEQ == '1.8' && currentForwardCEQ == '1.2') {
        //   ceqStatus = CEQStatus.from1P8GTo1P2G;
        // } else {
        //   ceqStatus = CEQStatus.none;
        // }

        // print(ceqStatus);

        // emit(state.copyWith(
        //   ceqStatus: ceqStatus,
        // ));

        // fakePreviousCEQ = currentForwardCEQ;
        */

        /*
        // 20250618 移除 CEQStatus 的判斷, 因為 EQ 模組會隨著 stop frequency 的變化而變化
        // stop frequency 小於等於 1218 MHz 時, CEQType 為 1.2
        // stop frequency 大於 1218 MHz 時, CEQType 為 1.8
        //
        // String currentCEQType = getCEQTypeFromForwardCEQIndex(
        //     currentValues[DataKey.currentForwardCEQIndex] ?? '255');

        // if (currentCEQType != 'N/A') {
        //   CEQStatus ceqStatus;
        //   if (ForwardCEQFlag.forwardCEQType == '1.2' &&
        //       currentCEQType == '1.8') {
        //     ceqStatus = CEQStatus.from1P2GTo1P8G;
        //   } else if (ForwardCEQFlag.forwardCEQType == '1.8' &&
        //       currentCEQType == '1.2') {
        //     ceqStatus = CEQStatus.from1P8GTo1P2G;
        //   } else {
        //     ceqStatus = CEQStatus.none;
        //   }

        //   if (ForwardCEQFlag.forwardCEQType != currentCEQType) {
        //     ForwardCEQFlag.forwardCEQType = currentCEQType;
        //   }

        //   emit(state.copyWith(
        //     ceqStatus: ceqStatus,
        //   ));
        // }
        */
      } else {
        print('requestCommand1p8G2() alarm updated failed');
      }

      if (resultOf1p8G1[0]) {
        Map<DataKey, String> currentValues = resultOf1p8G1[1];
        _amp18Repository.updateDataWithGivenValuePairs(currentValues);
      } else {
        print('requestCommand1p8G1() setting values updated failed');
      }
    }
  }

  void _onModeChanged(
    ModeChanged event,
    Emitter<HomeState> emit,
  ) {
    ModeProperty.mode = event.mode;

    // 這邊是為了讓 UI 可以即時更新 mode
    emit(state.copyWith(
      mode: event.mode,
    ));
  }

  void _cancelUpdateTimer() {
    if (_timer != null) {
      _timer!.cancel();
      print('alarm trigger timer is canceled');
    }
  }

  Future<void> _onDevicePeriodicUpdateCanceled(
    DevicePeriodicUpdateCanceled event,
    Emitter<HomeState> emit,
  ) async {
    _cancelUpdateTimer();

    String partId = state.characteristicData[DataKey.partId] ?? '';
    if (partId == '4') {
      _amp18CCorNodeRepository.cancelPeriodicUpdateCommand();
    } else {
      _amp18Repository.cancelPeriodicUpdateCommand();
    }
    emit(state.copyWith(
      periodicUpdateEnabled: false,
    ));
  }

  @override
  Future<void> close() {
    if (_timer != null) {
      _timer!.cancel();

      print('alarm trigger timer is canceled due to bloc closing.');
    }

    return super.close();
  }

  // void _onNeedsDataReloaded(
  //   NeedsDataReloaded event,
  //   Emitter<HomeState> emit,
  // ) {
  //   emit(state.copyWith(
  //     loadingStatus: FormStatus.none,
  //     isReloadData: event.isReloadData,
  //   ));
  // }
}

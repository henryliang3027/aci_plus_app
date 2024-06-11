import 'dart:async';
import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  })  : _aciDeviceRepository = aciDeviceRepository,
        _dsimRepository = dsimRepository,
        _amp18Repository = amp18Repository,
        _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(const HomeState()) {
    on<SplashStateChanged>(_onSplashStateChanged);
    on<DiscoveredDeviceChanged>(_onDiscoveredDeviceChanged);
    on<DataRequested>(_onDataRequested);
    on<Data18Requested>(_onData18Requested);
    on<CCorNode18DataRequested>(_onCCorNode18DataRequested);
    on<EventRequested>(_onEventRequested);
    on<DeviceCharacteristicChanged>(_onDeviceCharacteristicChanged);
    on<DeviceRefreshed>(_onDeviceRefreshed);
    on<DeviceConnectionChanged>(_onDeviceConnectionChanged);
    // on<NeedsDataReloaded>(_onNeedsDataReloaded);
    // on<testTimeout>(_onTestTimeout);
  }

  final ACIDeviceRepository _aciDeviceRepository;
  final DsimRepository _dsimRepository;
  final Amp18Repository _amp18Repository;
  final Amp18CCorNodeRepository _amp18CCorNodeRepository;
  StreamSubscription<ScanReport>? _scanStreamSubscription;
  StreamSubscription<ConnectionReport>? _connectionReportStreamSubscription;
  StreamSubscription<Map<DataKey, String>>?
      _characteristicDataStreamSubscription;

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
    // await _assetsAudioPlayer.open(
    //   Audio("assets/audios/splash_sound_final.mp3"),
    //   autoStart: false,
    // );
    // _assetsAudioPlayer.play();
    // await Future.delayed(const Duration(milliseconds: 6000));

    // _scanStreamSubscription = _dsimRepository.scanReport.listen(
    //   (scanReport) {
    //     add(DiscoveredDeviceChanged(scanReport));
    //   },
    // );

    _scanStreamSubscription = _aciDeviceRepository.scanReport.listen(
      (scanReport) {
        add(DiscoveredDeviceChanged(scanReport));
      },
    );

    // _dsimRepository.scanDevices();

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
          connectionStatus: FormStatus.requestInProgress,
          loadingStatus: FormStatus.requestInProgress,
          device: event.scanReport.perigheral,
        ));

        // _connectionReportStreamSubscription =
        //     _dsimRepository.connectionStateReport.listen((connectionReport) {
        //   add(DeviceConnectionChanged(connectionReport));
        // });

        // _dsimRepository.connectToDevice(event.scanReport.discoveredDevice!);

        _connectionReportStreamSubscription = _aciDeviceRepository
            .connectionStateReport
            .listen((connectionReport) {
          add(DeviceConnectionChanged(connectionReport));
        });

        _aciDeviceRepository.connectToDevice();

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
            connectionStatus: FormStatus.requestFailure,
            loadingStatus: FormStatus.requestFailure,
            device: null,
            errorMassage: 'Bluetooth is disabled.'));
        break;
    }

    // await _dsimRepository.closeScanStream();

    await _aciDeviceRepository.closeScanStream();

    if (_scanStreamSubscription != null) {
      await _scanStreamSubscription?.cancel();
      _scanStreamSubscription = null;
      print('_scanStreamSubscription closed');
    }
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
        // List<dynamic> result =
        //     await _dsimRepository.getACIDeviceType(deviceId: state.device!.id);

        List<dynamic> result = await _aciDeviceRepository.getACIDeviceType(
            deviceId: state.device!.id);

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
            add(const CCorNode18DataRequested());
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

        emit(state.copyWith(
          scanStatus: FormStatus.requestSuccess,
          connectionStatus: FormStatus.requestFailure,
          loadingStatus: FormStatus.none,
          errorMassage: event.connectionReport.errorMessage,
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

  Future<void> _onData18Requested(
    Data18Requested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      loadingStatus: FormStatus.requestInProgress,
      characteristicData: {},
    ));

    await _amp18Repository.set1p8GTransmitDelayTime();

    Map<DataKey, String> newCharacteristicData = {};
    List<dynamic> resultOf1p8G0 = [];
    List<dynamic> resultOf1p8G1 = [];
    List<dynamic> resultOf1p8G2 = [];
    List<dynamic> resultOf1p8G3 = [];
    List<dynamic> resultOf1p8GForLogChunk = [];

    resultOf1p8G0 = await _amp18Repository.requestCommand1p8G0();

    if (resultOf1p8G0[0]) {
      newCharacteristicData.addAll(resultOf1p8G0[1]);
      emit(state.copyWith(
        characteristicData: newCharacteristicData,
      ));
    } else {
      emit(state.copyWith(
        loadingStatus: FormStatus.requestFailure,
        characteristicData: state.characteristicData,
        errorMassage: 'Failed to load data',
      ));
    }

    if (resultOf1p8G0[0]) {
      resultOf1p8G1 = await _amp18Repository.requestCommand1p8G1();

      if (resultOf1p8G1[0]) {
        int logInterval = int.parse(resultOf1p8G1[1][DataKey.logInterval]);
        int rfOutputLogInterval =
            int.parse(resultOf1p8G1[1][DataKey.rfOutputLogInterval]);

        bool isUpdateLogInterval = false;
        bool isUpdateRFOutputLogInterval = false;

        // 如果讀取到 logInterval < 5, 則自動設定為 30 分鐘
        if (logInterval < 5) {
          isUpdateLogInterval = await _amp18Repository.set1p8GLogInterval('30');
        }

        // 如果讀取到 logInterval < 30, 則自動設定為 30 分鐘
        if (rfOutputLogInterval < 30) {
          isUpdateRFOutputLogInterval =
              await _amp18Repository.set1p8GRFOutputLogInterval('30');
        }

        if (isUpdateLogInterval || isUpdateRFOutputLogInterval) {
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
              errorMassage: 'Failed to load data',
            ));
          }
        } else {
          // 如果讀取到 logInterval != '0', 則 emit 讀取到的資料
          newCharacteristicData.addAll(resultOf1p8G1[1]);
          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
        }
      } else {
        emit(state.copyWith(
          loadingStatus: FormStatus.requestFailure,
          characteristicData: state.characteristicData,
          errorMassage: 'Failed to load data',
        ));
      }
    }

    if (resultOf1p8G1[0]) {
      resultOf1p8G2 = await _amp18Repository.requestCommand1p8G2();

      if (resultOf1p8G2[0]) {
        newCharacteristicData.addAll(resultOf1p8G2[1]);
        emit(state.copyWith(
          characteristicData: newCharacteristicData,
        ));
      } else {
        emit(state.copyWith(
          loadingStatus: FormStatus.requestFailure,
          characteristicData: state.characteristicData,
          errorMassage: 'Failed to load data',
        ));
      }
    }

    if (resultOf1p8G2[0]) {
      // 最多 retry 3 次, 連續失敗3次就視為失敗
      for (int i = 0; i < 3; i++) {
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
              errorMassage: 'Failed to load data',
            ));
          } else {
            if (resultOf1p8G3[1] == CharacteristicError.writeDataError.name) {
              emit(state.copyWith(
                loadingStatus: FormStatus.requestFailure,
                characteristicData: state.characteristicData,
                errorMassage: 'Failed to load data',
              ));
              break;
            } else {
              continue;
            }
          }
        }
      }
    }

    if (resultOf1p8G3[0]) {
      // 最多 retry 3 次, 連續失敗3次就視為失敗
      for (int i = 0; i < 3; i++) {
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
              errorMassage: 'Failed to load logs',
            ));
          } else {
            if (resultOf1p8GForLogChunk[2] ==
                CharacteristicError.writeDataError.name) {
              emit(state.copyWith(
                loadingStatus: FormStatus.requestFailure,
                characteristicData: state.characteristicData,
                errorMassage: 'Failed to load logs',
              ));
              break;
            } else {
              continue;
            }
          }
        }
      }
    }

    if (resultOf1p8GForLogChunk[0]) {
      String deviceNowDateTime =
          state.characteristicData[DataKey.nowDateTime] ??
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      // 寫入目前日期時間 年yyyy 月MM 日dd 時HH 分mm
      String partId = state.characteristicData[DataKey.partId] ?? '';
      await _amp18Repository.set1p8GNowDateTime(
        partId: partId,
        deviceNowDateTime: deviceNowDateTime,
      );
    }

    emit(state.copyWith(
      loadingStatus: FormStatus.requestSuccess,
    ));
  }

  Future<void> _onCCorNode18DataRequested(
    CCorNode18DataRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      loadingStatus: FormStatus.requestInProgress,
      characteristicData: {},
    ));

    await _amp18CCorNodeRepository.set1p8GCCorNodeTransmitDelayTime();

    Map<DataKey, String> newCharacteristicData = {};
    List<dynamic> resultOf1p8GCCorNode80 = [];
    List<dynamic> resultOf1p8GCCorNode91 = [];
    List<dynamic> resultOf1p8GCCorNode92 = [];
    List<dynamic> resultOf1p8GCCorNodeA1 = [];
    List<dynamic> resultOf1p8GCCorNodeLogChunk = [];

    resultOf1p8GCCorNode80 =
        await _amp18CCorNodeRepository.requestCommand1p8GCCorNode80();

    if (resultOf1p8GCCorNode80[0]) {
      newCharacteristicData.addAll(resultOf1p8GCCorNode80[1]);
      emit(state.copyWith(
        characteristicData: newCharacteristicData,
      ));
    } else {
      emit(state.copyWith(
        loadingStatus: FormStatus.requestFailure,
        characteristicData: state.characteristicData,
        errorMassage: 'Failed to load data',
      ));
    }

    if (resultOf1p8GCCorNode80[0]) {
      resultOf1p8GCCorNode91 =
          await _amp18CCorNodeRepository.requestCommand1p8GCCorNode91();

      if (resultOf1p8GCCorNode91[0]) {
        int logInterval =
            int.parse(resultOf1p8GCCorNode91[1][DataKey.logInterval]);

        // 如果讀取到 logInterval < 5, 則自動設定為 30 分鐘
        if (logInterval < 5) {
          bool isSuccess =
              await _amp18CCorNodeRepository.set1p8GCCorNodeLogInterval('30');

          // 如果設定失敗, 則顯示 dialog
          if (!isSuccess) {
            emit(state.copyWith(
              loadingStatus: FormStatus.requestFailure,
              characteristicData: state.characteristicData,
              errorMassage: 'Failed to initialize the log interval.',
            ));
          } else {
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
                errorMassage: 'Failed to load data',
              ));
            }
          }
        } else {
          // 如果讀取到 logInterval != '0', 則 emit 讀取到的資料
          newCharacteristicData.addAll(resultOf1p8GCCorNode91[1]);
          emit(state.copyWith(
            characteristicData: newCharacteristicData,
          ));
        }
      } else {
        emit(state.copyWith(
          loadingStatus: FormStatus.requestFailure,
          characteristicData: state.characteristicData,
          errorMassage: 'Failed to load data',
        ));
      }
    }

    if (resultOf1p8GCCorNode91[0]) {
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
          errorMassage: 'Failed to load data',
        ));
      }
    }

    if (resultOf1p8GCCorNode92[0]) {
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
          errorMassage: 'Failed to load data',
        ));
      }
    }

    if (resultOf1p8GCCorNodeA1[0]) {
      // 最多 retry 3 次, 連續失敗3次就視為失敗
      for (int i = 0; i < 3; i++) {
        resultOf1p8GCCorNodeLogChunk = await _amp18CCorNodeRepository
            .requestCommand1p8GCCorNodeLogChunk(0);

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
              errorMassage: 'Failed to load logs',
            ));
          } else {
            if (resultOf1p8GCCorNodeLogChunk[2] ==
                CharacteristicError.writeDataError.name) {
              emit(state.copyWith(
                loadingStatus: FormStatus.requestFailure,
                characteristicData: state.characteristicData,
                errorMassage: 'Failed to load logs',
              ));
              break;
            } else {
              continue;
            }
          }
        }
      }
    }

    if (resultOf1p8GCCorNodeLogChunk[0]) {
      String deviceNowTime = state.characteristicData[DataKey.nowDateTime] ??
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      // 寫入目前日期時間 年yyyy 月MM 日dd 時HH 分mm
      await _amp18CCorNodeRepository.set1p8GCCorNodeNowDateTime(deviceNowTime);
    }

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
      device: null,
      characteristicData: const {},
      dateValueCollectionOfLog: const [],
    ));

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

    _scanStreamSubscription = _aciDeviceRepository.scanReport.listen(
      (scanReport) {
        add(DiscoveredDeviceChanged(scanReport));
      },
    );
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

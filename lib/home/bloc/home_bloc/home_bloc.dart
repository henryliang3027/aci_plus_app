import 'dart:async';
import 'dart:math';

import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const HomeState()) {
    on<DiscoveredDeviceChanged>(_onDiscoveredDeviceChanged);
    on<DeviceRefreshed>(_onDeviceRefreshed);
    on<DeviceConnectionChanged>(_onDeviceConnectionChanged);
    on<DeviceCharacteristicChanged>(_onDeviceCharacteristicChanged);

    _scanStreamSubscription = _dsimRepository.scannedDevices.listen(
      (scanReport) {
        add(DiscoveredDeviceChanged(scanReport));
      },
    );
  }

  final DsimRepository _dsimRepository;
  late StreamSubscription<ScanReport>? _scanStreamSubscription;
  late StreamSubscription<ConnectionReport>? _connectionStreamSubscription;
  late StreamSubscription<Map<DataKey, String>>?
      _characteristicDataStreamSubscription;

  final Map<DataKey, String> _characteristicDataMap = {};

  Future<void> _onDiscoveredDeviceChanged(
    DiscoveredDeviceChanged event,
    Emitter<HomeState> emit,
  ) async {
    switch (event.scanReport.scanStatus) {
      case ScanStatus.success:
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          device: event.scanReport.discoveredDevice,
        ));
        // _dsimRepository.connectDevice(state.device!);

        _connectionStreamSubscription =
            _dsimRepository.connectionStateReport.listen((connectionReport) {
          add(DeviceConnectionChanged(connectionReport));
        });
        // _getCharacteristicData();
        break;
      case ScanStatus.failure:
        emit(state.copyWith(
            status: FormStatus.requestFailure,
            device: null,
            errorMassage: 'Device not found.'));
        break;
      case ScanStatus.disable:
        emit(state.copyWith(
            status: FormStatus.requestFailure,
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
          status: FormStatus.requestSuccess,
          connectionStatus: FormStatus.requestInProgress,
        ));
        break;
      case DeviceConnectionState.connected:
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          connectionStatus: FormStatus.requestSuccess,
        ));

        _characteristicDataStreamSubscription =
            _dsimRepository.characteristicData.listen(
          (data) {
            print(data);

            add(DeviceCharacteristicChanged(data.entries.first));
          },
          onDone: () {},
        );

        break;
      case DeviceConnectionState.disconnecting:
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          connectionStatus: FormStatus.requestFailure,
        ));
        break;
      case DeviceConnectionState.disconnected:
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          connectionStatus: FormStatus.requestFailure,
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

  Future<void> _onDeviceRefreshed(
    DeviceRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
      device: null,
      characteristicData: const {},
    ));

    _dsimRepository.clearCache();
    await _dsimRepository.closeConnectionStream();

    _scanStreamSubscription =
        _dsimRepository.scannedDevices.listen((scanReport) async {
      add(DiscoveredDeviceChanged(scanReport));
    });
  }
}

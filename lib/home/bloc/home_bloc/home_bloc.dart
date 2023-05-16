import 'dart:async';
import 'dart:io';

import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const HomeState()) {
    on<DeviceConnected>(_onDeviceConnected);
    on<DeviceChanged>(_onDeviceChanged);

    add(const DeviceConnected());
  }

  final DsimRepository _dsimRepository;
  late StreamSubscription<DiscoveredDevice> _scanStreamSubscription;

  Future<void> _onDeviceConnected(
    DeviceConnected event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      status: FormStatus.requestInProgress,
    ));

    bool permissionGranted = false;
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();

      if (statuses.values.contains(PermissionStatus.granted)) {
        permissionGranted = true;
      } else {
        print('permissionGranted false');
      }
    } else if (Platform.isIOS) {
      permissionGranted = true;
    }

    if (permissionGranted) {
      _scanStreamSubscription =
          _dsimRepository.scanDevices().listen((device) async {
        if (device.name.startsWith('ACI')) {
          print(device.name);
          add(DeviceChanged(true, device));
          await _scanStreamSubscription.cancel();
        }
      });
    }

    // if (result[0]) {
    //   emit(state.copyWith(
    //     status: FormStatus.requestSuccess,
    //     device: result[1],
    //   ));
    // } else {
    //   emit(state.copyWith(
    //     status: FormStatus.requestFailure,
    //     device: null,
    //   ));
    // }
  }

  void _onDeviceChanged(
    DeviceChanged event,
    Emitter<HomeState> emit,
  ) {
    if (event.found) {
      emit(state.copyWith(
        status: FormStatus.requestSuccess,
        device: event.device,
      ));
    } else {
      emit(state.copyWith(
        status: FormStatus.requestFailure,
        device: null,
      ));
    }
  }
}

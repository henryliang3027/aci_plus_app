import 'dart:async';

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
    on<DeviceChanged>(_onDeviceChanged);
    on<DeviceRefreshed>(_onDeviceRefreshed);

    _scanStreamSubscription =
        _dsimRepository.scannedDevices.listen((scanReport) async {
      add(DeviceChanged(scanReport));

      await _dsimRepository.closeScanStream();
      await _scanStreamSubscription?.cancel();
      _scanStreamSubscription = null;
    });

    Future.delayed(const Duration(seconds: 3), () async {
      await _dsimRepository.closeScanStream();
      await _scanStreamSubscription?.cancel();
      _scanStreamSubscription = null;
      if (state.device == null) {
        add(
          const DeviceChanged(
            ScanReport(
              scanStatus: ScanStatus.failure,
            ),
          ),
        );
      } else {
        _dsimRepository.connectDevice(state.device!);
      }
    });
  }

  final DsimRepository _dsimRepository;
  late StreamSubscription<ScanReport>? _scanStreamSubscription;

  void _onDeviceChanged(
    DeviceChanged event,
    Emitter<HomeState> emit,
  ) {
    switch (event.scanReport.scanStatus) {
      case ScanStatus.success:
        emit(state.copyWith(
          status: FormStatus.requestSuccess,
          device: event.scanReport.discoveredDevice,
        ));
        break;
      case ScanStatus.failure:
        emit(state.copyWith(
          status: FormStatus.requestFailure,
          device: null,
        ));
        break;
    }
  }

  void _onDeviceRefreshed(
    DeviceRefreshed event,
    Emitter<HomeState> emit,
  ) {
    _scanStreamSubscription =
        _dsimRepository.scannedDevices.listen((scanReport) async {
      add(DeviceChanged(scanReport));

      await _scanStreamSubscription?.cancel();
    });

    Future.delayed(const Duration(seconds: 3), () async {
      await _scanStreamSubscription?.cancel();
      _dsimRepository.closeScanStream();
      if (state.device == null) {
        add(
          const DeviceChanged(
            ScanReport(
              scanStatus: ScanStatus.failure,
            ),
          ),
        );
      } else {
        //_dsimRepository.connectDevice(state.device!);
      }
    });
  }
}

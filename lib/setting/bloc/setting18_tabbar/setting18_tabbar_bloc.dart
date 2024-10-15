import 'dart:async';

import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/utils.dart';

import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_tabbar_event.dart';
part 'setting18_tabbar_state.dart';

class Setting18TabBarBloc
    extends Bloc<Setting18TabBarEvent, Setting18TabBarState> {
  Setting18TabBarBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18repository = amp18Repository,
        super(const Setting18TabBarState()) {
    on<CurrentForwardCEQUpdated>(_onCurrentForwardCEQUpdated);
    on<CurrentForwardCEQPeriodicUpdateRequested>(
        _onCurrentForwardCEQPeriodicUpdateRequested);
    on<CurrentForwardCEQPeriodicUpdateCanceled>(
        _onCurrentForwardCEQPeriodicUpdateCanceled);

    on<NotifyChildTabUpdated>(_onNotifyChildTabUpdated);

    add(const CurrentForwardCEQPeriodicUpdateRequested());
  }

  Timer? _timer;
  final Amp18Repository _amp18repository;
  final List<String> fakeData = ['1.8', '1.2', '1.2', '1.8'];
  String fakePreviousCEQ = '';

  void _onCurrentForwardCEQPeriodicUpdateRequested(
    CurrentForwardCEQPeriodicUpdateRequested event,
    Emitter<Setting18TabBarState> emit,
  ) {
    if (_timer != null) {
      _timer!.cancel();
    }

    // timer 啟動後 3 秒才會發 CurrentForwardCEQUpdated, 所以第0秒時先 CurrentForwardCEQUpdated
    add(const CurrentForwardCEQUpdated());

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      print('CurrentForwardCEQUpdate timer: ${timer.tick}');

      add(const CurrentForwardCEQUpdated());
    });

    print('CurrentForwardCEQUpdate started');
  }

  Future<void> _onCurrentForwardCEQUpdated(
    CurrentForwardCEQUpdated event,
    Emitter<Setting18TabBarState> emit,
  ) async {
    // 一開始 255 -> 變成非 255
    // 非 255 -> 變成 255
    // 1.2 -> 變成 1.8
    // 1.8 -> 變成 1.2

    Map<DataKey, String> characteristicDataCache =
        _amp18repository.characteristicDataCache;

    List<dynamic> resultOf1p8G2 = await _amp18repository.requestCommand1p8G2();

    if (resultOf1p8G2[0]) {
      Map<DataKey, String> characteristicData = resultOf1p8G2[1];

      String previousCEQType = getCEQTypeFromForwardCEQIndex(
          characteristicDataCache[DataKey.currentForwardCEQIndex] ?? '255');

      String currentCEQType = getCEQTypeFromForwardCEQIndex(
          characteristicData[DataKey.currentForwardCEQIndex] ?? '255');

      if (currentCEQType != 'N/A') {
        bool isForwardCEQIndexChanged = previousCEQType != currentCEQType;

        emit(state.copyWith(
          isForwardCEQIndexChanged: isForwardCEQIndexChanged,
        ));
      }
    }

    // String currentForwardCEQ = fakeData[_timer!.tick % 4];

    // bool isForwardCEQIndexChanged = fakePreviousCEQ != currentForwardCEQ;

    // emit(state.copyWith(
    //   isForwardCEQIndexChanged: isForwardCEQIndexChanged,
    // ));

    // fakePreviousCEQ = currentForwardCEQ;
  }

  void _onNotifyChildTabUpdated(
      NotifyChildTabUpdated event, Emitter<Setting18TabBarState> state) {
    _amp18repository.updateForwardCEQState(true);
  }

  Future<void> _onCurrentForwardCEQPeriodicUpdateCanceled(
    CurrentForwardCEQPeriodicUpdateCanceled event,
    Emitter<Setting18TabBarState> emit,
  ) async {
    if (_timer != null) {
      _timer!.cancel();
      print('CurrentForwardCEQUpdate timer is canceled');
    }
  }

  @override
  Future<void> close() {
    if (_timer != null) {
      _timer!.cancel();

      print('CurrentForwardCEQUpdate timer is canceled due to bloc closing.');
    }

    return super.close();
  }
}

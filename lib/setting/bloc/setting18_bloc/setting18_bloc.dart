import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_event.dart';
part 'setting18_state.dart';

class Setting18Bloc extends Bloc<Setting18Event, Setting18State> {
  Setting18Bloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const Setting18State()) {
    // on<ResetForwardParameterRequested>(_onResetForwardParameterRequested);
    // on<ResetReverseParameterRequested>(_onResetReverseParameterRequested);
  }

  final Amp18Repository _amp18Repository;

  // void _onResetForwardParameterRequested(
  //   ResetForwardParameterRequested event,
  //   Emitter<Setting18State> emit,
  // ) async {
  //   _amp18Repository.set1p8GFactoryDefault(43); // load downstream only

  //   // 等待 device 完成更新後在讀取值
  //   await Future.delayed(const Duration(milliseconds: 1000));

  //   await _amp18Repository.updateCharacteristics();

  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.submissionSuccess,
  //   ));
  // }

  // void _onResetReverseParameterRequested(
  //   ResetReverseParameterRequested event,
  //   Emitter<Setting18State> emit,
  // ) async {
  //   _amp18Repository.set1p8GFactoryDefault(34); // load upstream only

  //   // 等待 device 完成更新後在讀取值
  //   await Future.delayed(const Duration(milliseconds: 1000));

  //   await _amp18Repository.updateCharacteristics();

  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.submissionSuccess,
  //   ));
  // }
}

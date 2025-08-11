import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_event.dart';
part 'setting18_state.dart';

// 預留 Setting18Bloc 用於處理設定頁面的邏輯
class Setting18Bloc extends Bloc<Setting18Event, Setting18State> {
  Setting18Bloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const Setting18State()) {}

  final Amp18Repository _amp18Repository;
}

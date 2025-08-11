import 'package:aci_plus_app/core/form_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_event.dart';
part 'setting18_ccor_node_state.dart';

// 預留 Setting18CCorNodeBloc 用於處理 Node 設定頁面的邏輯
class Setting18CCorNodeBloc
    extends Bloc<Setting18CCorNodeEvent, Setting18CCorNodeState> {
  Setting18CCorNodeBloc() : super(const Setting18CCorNodeState());
}

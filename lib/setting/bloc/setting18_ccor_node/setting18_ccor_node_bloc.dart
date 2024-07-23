import 'package:aci_plus_app/core/form_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_event.dart';
part 'setting18_ccor_node_state.dart';

class Setting18CCorNodeBloc
    extends Bloc<Setting18CCorNodeEvent, Setting18CCorNodeState> {
  Setting18CCorNodeBloc() : super(const Setting18CCorNodeState());
}

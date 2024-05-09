import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_graph_module_event.dart';
part 'setting18_ccor_node_graph_module_state.dart';

class Setting18CCorNodeGraphModuleBloc extends Bloc<
    Setting18CCorNodeGraphModuleEvent, Setting18CCorNodeGraphModuleState> {
  Setting18CCorNodeGraphModuleBloc(
      {required Amp18CCorNodeRepository amp18CCorNodeRepository})
      : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(const Setting18CCorNodeGraphModuleState()) {
    // on<Initialized>(_onInitialized);

    // on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;
}

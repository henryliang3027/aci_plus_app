import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/dsim12_repository.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_graph_view_event.dart';
part 'setting_graph_view_state.dart';

class SettingGraphViewBloc
    extends Bloc<SettingGraphViewEvent, SettingGraphViewState> {
  SettingGraphViewBloc({
    required Dsim12Repository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const SettingGraphViewState()) {}

  final Dsim12Repository _dsimRepository;
}

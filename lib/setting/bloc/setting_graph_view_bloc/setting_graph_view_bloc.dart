import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/setting/model/location.dart';
import 'package:dsim_app/setting/model/pilot_code.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_graph_view_event.dart';
part 'setting_graph_view_state.dart';

class SettingGraphViewBloc
    extends Bloc<SettingGraphViewEvent, SettingGraphViewState> {
  SettingGraphViewBloc({
    required DsimRepository dsimRepository,
    required bool isInitialized,
  })  : _dsimRepository = dsimRepository,
        _isInitialized = isInitialized,
        super(const SettingGraphViewState()) {}

  final DsimRepository _dsimRepository;
  final bool _isInitialized;
}

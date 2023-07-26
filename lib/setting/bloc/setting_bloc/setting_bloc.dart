import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc({required DsimRepository dsimRepository})
      : _dsimRepository = dsimRepository,
        super(const SettingState()) {
    on<GraphViewToggled>(_onGraphViewToggled);
    on<ListViewToggled>(_onListViewToggled);
  }
  final DsimRepository _dsimRepository;

  void _onGraphViewToggled(
    GraphViewToggled event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isGraphType: true,
    ));
  }

  void _onListViewToggled(
    ListViewToggled event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isGraphType: false,
    ));
  }
}

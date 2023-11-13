import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc({required DsimRepository dsimRepository})
      : _dsimRepository = dsimRepository,
        super(const SettingState()) {
    on<ViewToggled>(_onViewToggled);
  }
  final DsimRepository _dsimRepository;

  void _onViewToggled(
    ViewToggled event,
    Emitter<SettingState> emit,
  ) {
    emit(state.copyWith(
      isGraphType: !state.isGraphType,
    ));
  }
}

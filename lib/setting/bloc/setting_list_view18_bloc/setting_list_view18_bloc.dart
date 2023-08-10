import 'package:dsim_app/core/form_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_list_view18_event.dart';
part 'setting_list_view18_state.dart';

class SettingListView18Bloc
    extends Bloc<SettingListView18Event, SettingListView18State> {
  SettingListView18Bloc() : super(const SettingListView18State()) {
    on<Initialized>(_onInitialized);
  }

  Future<void> _onInitialized(
    Initialized event,
    Emitter<SettingListView18State> emit,
  ) async {}
}

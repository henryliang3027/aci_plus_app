import 'package:dsim_app/core/form_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_list_view_event.dart';
part 'setting18_list_view_state.dart';

class Setting18ListViewBloc
    extends Bloc<Setting18ListViewEvent, Setting18ListViewState> {
  Setting18ListViewBloc() : super(const Setting18ListViewState()) {
    on<Initialized>(_onInitialized);
  }

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18ListViewState> emit,
  ) async {}
}

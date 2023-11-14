import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_graph_view_event.dart';
part 'setting18_graph_view_state.dart';

class Setting18GraphViewBloc
    extends Bloc<Setting18GraphViewEvent, Setting18GraphViewState> {
  Setting18GraphViewBloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const Setting18GraphViewState()) {
    on<Setting18GraphViewEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final DsimRepository _dsimRepository;
}

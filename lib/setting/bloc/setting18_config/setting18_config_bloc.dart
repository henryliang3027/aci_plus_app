import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_config_event.dart';
part 'setting18_config_state.dart';

class Setting18ConfigBloc
    extends Bloc<Setting18ConfigEvent, Setting18ConfigState> {
  Setting18ConfigBloc({
    required Amp18Repository amp18repository,
  })  : _amp18repository = amp18repository,
        super(const Setting18ConfigState()) {
    on<Setting18ConfigEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final Amp18Repository _amp18repository;
}

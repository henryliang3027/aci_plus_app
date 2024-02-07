import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_dongle_event.dart';
part 'setting18_dongle_state.dart';

class Setting18DongleBloc
    extends Bloc<Setting18DongleEvent, Setting18DongleState> {
  Setting18DongleBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const Setting18DongleState()) {
    on<Setting18DongleEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final Amp18Repository _amp18Repository;
}

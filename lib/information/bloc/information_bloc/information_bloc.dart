import 'package:bloc/bloc.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:equatable/equatable.dart';

part 'information_event.dart';
part 'information_state.dart';

class InformationBloc extends Bloc<InformationEvent, InformationState> {
  InformationBloc() : super(const InformationState()) {
    on<InformationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

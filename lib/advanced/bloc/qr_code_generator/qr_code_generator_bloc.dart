import 'package:aci_plus_app/core/form_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'qr_code_generator_event.dart';
part 'qr_code_generator_state.dart';

class QRCodeGeneratorBloc
    extends Bloc<QRCodeGeneratorEvent, QRCodeGeneratorState> {
  QRCodeGeneratorBloc() : super(const QRCodeGeneratorState()) {
    on<QRCodeGeneratorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
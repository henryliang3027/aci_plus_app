import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusState()) {
    on<TemperatureUnitChanged>(_onTemperatureUnitChanged);
  }

  void _onTemperatureUnitChanged(
    TemperatureUnitChanged event,
    Emitter<StatusState> emit,
  ) {
    emit(state.copyWith(
      temperatureUnit: event.temperatureUnit,
    ));
    // switch (event.temperatureUnit) {
    //   case TemperatureUnit.fahrenheit:
    //     emit(state.copyWith(
    //       temperatureUnit: event.temperatureUnit,
    //       currentTemperature: currentTemperatureF,
    //       maxTemperature: maxTemperatureF,
    //       minTemperature: minTemperatureF,
    //     ));
    //     break;
    //   case TemperatureUnit.celsius:
    //     emit(state.copyWith(
    //       temperatureUnit: event.temperatureUnit,
    //       currentTemperature: currentTemperatureC,
    //       maxTemperature: maxTemperatureC,
    //       minTemperature: minTemperatureC,
    //     ));
    //     break;
    //   default:
    //     emit(state.copyWith(
    //       temperatureUnit: event.temperatureUnit,
    //       currentTemperature: currentTemperatureF,
    //       maxTemperature: maxTemperatureF,
    //       minTemperature: minTemperatureF,
    //     ));
    //     break;
    // }
  }
}

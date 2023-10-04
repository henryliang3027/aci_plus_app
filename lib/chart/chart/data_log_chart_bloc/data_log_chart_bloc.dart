import 'package:bloc/bloc.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim18_parser.dart';
import 'package:equatable/equatable.dart';

part 'data_log_chart_event.dart';
part 'data_log_chart_state.dart';

class DataLogChartBloc extends Bloc<DataLogChartEvent, DataLogChartState> {
  DataLogChartBloc() : super(const DataLogChartState()) {}
}

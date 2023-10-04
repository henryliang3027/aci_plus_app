import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim18_parser.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'rf_level_chart_event.dart';
part 'rf_level_chart_state.dart';

class RFLevelChartBloc extends Bloc<RFLevelChartEvent, RFLevelChartState> {
  RFLevelChartBloc() : super(const RFLevelChartState()) {}
}

part of 'rf_level_chart_bloc.dart';

abstract class RFLevelChartEvent extends Equatable {
  const RFLevelChartEvent();
}

class RFInOutRequested extends RFLevelChartEvent {
  const RFInOutRequested();

  @override
  List<Object?> get props => [];
}

part of 'rf_level_chart_bloc.dart';

abstract class RFLevelChartEvent extends Equatable {
  const RFLevelChartEvent();
}

class DataRequested extends RFLevelChartEvent {
  const DataRequested();

  @override
  List<Object?> get props => [];
}

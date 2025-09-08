part of 'data_log_chart_bloc.dart';

abstract class DataLogChartEvent extends Equatable {
  const DataLogChartEvent();
}

class Initialized extends DataLogChartEvent {
  const Initialized();

  @override
  List<Object?> get props => [];
}

class MoreLogRequested extends DataLogChartEvent {
  const MoreLogRequested();

  @override
  List<Object?> get props => [];
}

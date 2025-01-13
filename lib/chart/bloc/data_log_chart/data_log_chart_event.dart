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

// class LogRequested extends DataLogChartEvent {
//   const LogRequested();

//   @override
//   List<Object?> get props => [];
// }

// class Event1P8GRequested extends DataLogChartEvent {
//   const Event1P8GRequested();

//   @override
//   List<Object?> get props => [];
// }

part of 'chart_bloc.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();
}

// class EventRequested extends ChartEvent {
//   const EventRequested();

//   @override
//   List<Object?> get props => [];
// }

class DataExported extends ChartEvent {
  const DataExported();

  @override
  List<Object?> get props => [];
}

class DataShared extends ChartEvent {
  const DataShared();

  @override
  List<Object?> get props => [];
}

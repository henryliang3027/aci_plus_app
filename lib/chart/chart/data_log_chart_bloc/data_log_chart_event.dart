part of 'data_log_chart_bloc.dart';

abstract class DataLogChartEvent extends Equatable {
  const DataLogChartEvent();
}

class DataExported extends DataLogChartEvent {
  const DataExported();

  @override
  List<Object?> get props => [];
}

class DataShared extends DataLogChartEvent {
  const DataShared();

  @override
  List<Object?> get props => [];
}

class AllDataExported extends DataLogChartEvent {
  const AllDataExported(
    this.isSuccessful,
    this.log1p8Gs,
    this.errorMessage,
  );

  final bool isSuccessful;
  final List<Log1p8G> log1p8Gs;
  final String errorMessage;

  @override
  List<Object?> get props => [
        isSuccessful,
        log1p8Gs,
        errorMessage,
      ];
}

class MoreLogRequested extends DataLogChartEvent {
  const MoreLogRequested();

  @override
  List<Object?> get props => [];
}

class LogRequested extends DataLogChartEvent {
  const LogRequested();

  @override
  List<Object?> get props => [];
}

class Event1P8GRequested extends DataLogChartEvent {
  const Event1P8GRequested();

  @override
  List<Object?> get props => [];
}

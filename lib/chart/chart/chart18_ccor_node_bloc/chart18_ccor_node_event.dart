part of 'chart18_ccor_node_bloc.dart';

abstract class Chart18CCorNodeEvent extends Equatable {
  const Chart18CCorNodeEvent();
}

class LogRequested extends Chart18CCorNodeEvent {
  const LogRequested();

  @override
  List<Object?> get props => [];
}

class MoreLogRequested extends Chart18CCorNodeEvent {
  const MoreLogRequested();

  @override
  List<Object?> get props => [];
}

class Event1P8GCCorNodeRequested extends Chart18CCorNodeEvent {
  const Event1P8GCCorNodeRequested();

  @override
  List<Object?> get props => [];
}

class DataExported extends Chart18CCorNodeEvent {
  const DataExported();

  @override
  List<Object?> get props => [];
}

class DataShared extends Chart18CCorNodeEvent {
  const DataShared();

  @override
  List<Object?> get props => [];
}

class AllDataDownloaded extends Chart18CCorNodeEvent {
  const AllDataDownloaded();

  @override
  List<Object?> get props => [];
}

class AllDataExported extends Chart18CCorNodeEvent {
  const AllDataExported(
    this.isSuccessful,
    this.log1p8Gs,
    this.errorMessage,
  );

  final bool isSuccessful;
  final List<Log1p8GCCorNode> log1p8Gs;
  final String errorMessage;

  @override
  List<Object?> get props => [
        isSuccessful,
        log1p8Gs,
        errorMessage,
      ];
}

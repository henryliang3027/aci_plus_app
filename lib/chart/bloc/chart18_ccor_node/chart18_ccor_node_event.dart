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
  const DataExported({
    required this.code,
  });

  final String code;

  @override
  List<Object?> get props => [
        code,
      ];
}

class DataShared extends Chart18CCorNodeEvent {
  const DataShared({
    required this.code,
  });

  final String code;

  @override
  List<Object?> get props => [
        code,
      ];
}

class AllDataExported extends Chart18CCorNodeEvent {
  const AllDataExported({
    required this.isSuccessful,
    required this.log1p8Gs,
    required this.errorMessage,
    required this.code,
  });

  final bool isSuccessful;
  final List<Log1p8GCCorNode> log1p8Gs;
  final String errorMessage;
  final String code;

  @override
  List<Object?> get props => [
        isSuccessful,
        log1p8Gs,
        errorMessage,
        code,
      ];
}

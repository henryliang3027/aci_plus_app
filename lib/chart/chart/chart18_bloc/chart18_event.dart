part of 'chart18_bloc.dart';

abstract class Chart18Event extends Equatable {
  const Chart18Event();
}

class DataExported extends Chart18Event {
  const DataExported();

  @override
  List<Object?> get props => [];
}

class DataShared extends Chart18Event {
  const DataShared();

  @override
  List<Object?> get props => [];
}

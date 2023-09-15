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

class AllDataDownloaded extends Chart18Event {
  const AllDataDownloaded();

  @override
  List<Object?> get props => [];
}

class AllDataExported extends Chart18Event {
  const AllDataExported(this.log1p8Gs);

  final List<Log1p8G> log1p8Gs;

  @override
  List<Object?> get props => [log1p8Gs];
}

class MoreDataRequested extends Chart18Event {
  const MoreDataRequested();

  @override
  List<Object?> get props => [];
}

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

class AllDataExported extends Chart18Event {
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

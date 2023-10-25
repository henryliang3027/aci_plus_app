part of 'chart18_bloc.dart';

abstract class Chart18Event extends Equatable {
  const Chart18Event();
}

class TabChangedEnabled extends Chart18Event {
  const TabChangedEnabled();

  @override
  List<Object?> get props => [];
}

class TabChangedDisabled extends Chart18Event {
  const TabChangedDisabled();

  @override
  List<Object?> get props => [];
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

class RFLevelExported extends Chart18Event {
  const RFLevelExported();

  @override
  List<Object?> get props => [];
}

class RFLevelShared extends Chart18Event {
  const RFLevelShared();

  @override
  List<Object?> get props => [];
}

class AllDataDownloaded extends Chart18Event {
  const AllDataDownloaded();

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

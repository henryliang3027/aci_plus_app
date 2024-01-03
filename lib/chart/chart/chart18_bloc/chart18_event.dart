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
  const DataExported({required this.code});

  final String code;

  @override
  List<Object?> get props => [
        code,
      ];
}

class DataShared extends Chart18Event {
  const DataShared({required this.code});

  final String code;

  @override
  List<Object?> get props => [
        code,
      ];
}

class RFLevelExported extends Chart18Event {
  const RFLevelExported({required this.code});

  final String code;

  @override
  List<Object?> get props => [
        code,
      ];
}

class RFLevelShared extends Chart18Event {
  const RFLevelShared({required this.code});

  final String code;

  @override
  List<Object?> get props => [
        code,
      ];
}

class AllDataExported extends Chart18Event {
  const AllDataExported({
    required this.isSuccessful,
    required this.log1p8Gs,
    required this.errorMessage,
    required this.code,
  });

  final bool isSuccessful;
  final List<Log1p8G> log1p8Gs;
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

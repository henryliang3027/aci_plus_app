part of 'information18_bloc.dart';

abstract class Information18Event extends Equatable {
  const Information18Event();

  @override
  List<Object> get props => [];
}

class AppVersionRequested extends Information18Event {
  const AppVersionRequested();

  @override
  List<Object> get props => [];
}

class ConfigLoaded extends Information18Event {
  const ConfigLoaded(this.partId);

  final String partId;

  @override
  List<Object> get props => [partId];
}

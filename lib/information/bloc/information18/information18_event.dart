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

class TestUSBConnection extends Information18Event {
  const TestUSBConnection();

  @override
  List<Object> get props => [];
}

class TestUSBRead extends Information18Event {
  const TestUSBRead();

  @override
  List<Object> get props => [];
}

// class AlarmUpdated extends Information18Event {
//   const AlarmUpdated();

//   @override
//   List<Object> get props => [];
// }

// class AlarmPeriodicUpdateRequested extends Information18Event {
//   const AlarmPeriodicUpdateRequested();

//   @override
//   List<Object> get props => [];
// }

// class AlarmPeriodicUpdateCanceled extends Information18Event {
//   const AlarmPeriodicUpdateCanceled();

//   @override
//   List<Object> get props => [];
// }

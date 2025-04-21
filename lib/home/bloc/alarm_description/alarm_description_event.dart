part of 'alarm_description_bloc.dart';

abstract class AlarmDescriptionEvent extends Equatable {
  const AlarmDescriptionEvent();
}

class AlarmDescriptionRequested extends AlarmDescriptionEvent {
  const AlarmDescriptionRequested();

  @override
  List<Object?> get props => [];
}

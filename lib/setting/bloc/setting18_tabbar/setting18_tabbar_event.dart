part of 'setting18_tabbar_bloc.dart';

sealed class Setting18TabBarEvent extends Equatable {
  const Setting18TabBarEvent();

  @override
  List<Object> get props => [];
}

class CurrentForwardCEQUpdated extends Setting18TabBarEvent {
  const CurrentForwardCEQUpdated();

  @override
  List<Object> get props => [];
}

class CurrentForwardCEQPeriodicUpdateRequested extends Setting18TabBarEvent {
  const CurrentForwardCEQPeriodicUpdateRequested();

  @override
  List<Object> get props => [];
}

class CurrentForwardCEQPeriodicUpdateCanceled extends Setting18TabBarEvent {
  const CurrentForwardCEQPeriodicUpdateCanceled();

  @override
  List<Object> get props => [];
}

class NotifyChildTabUpdated extends Setting18TabBarEvent {
  const NotifyChildTabUpdated();

  @override
  List<Object> get props => [];
}

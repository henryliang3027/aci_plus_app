part of 'setting18_advanced_bloc.dart';

abstract class Setting18AdvancedEvent extends Equatable {
  const Setting18AdvancedEvent();
}

class AllButtonsEnabled extends Setting18AdvancedEvent {
  const AllButtonsEnabled();

  @override
  List<Object?> get props => [];
}

class AllButtonsDisabled extends Setting18AdvancedEvent {
  const AllButtonsDisabled();

  @override
  List<Object?> get props => [];
}

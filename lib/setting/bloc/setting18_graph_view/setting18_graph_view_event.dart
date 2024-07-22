part of 'setting18_graph_view_bloc.dart';

abstract class Setting18GraphViewEvent extends Equatable {
  const Setting18GraphViewEvent();

  @override
  List<Object> get props => [];
}

class LoadGraphRequested extends Setting18GraphViewEvent {
  const LoadGraphRequested();

  @override
  List<Object> get props => [];
}

class ValueTextUpdated extends Setting18GraphViewEvent {
  const ValueTextUpdated();

  @override
  List<Object> get props => [];
}

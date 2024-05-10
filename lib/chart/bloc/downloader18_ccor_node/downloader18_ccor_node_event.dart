part of 'downloader18_ccor_node_bloc.dart';

abstract class Downloader18CCorNodeEvent extends Equatable {
  const Downloader18CCorNodeEvent();

  @override
  List<Object> get props => [];
}

class DownloadStarted extends Downloader18CCorNodeEvent {
  const DownloadStarted();

  @override
  List<Object> get props => [];
}

class StatusUpdated extends Downloader18CCorNodeEvent {
  const StatusUpdated();

  @override
  List<Object> get props => [];
}

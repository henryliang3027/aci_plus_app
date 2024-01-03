part of 'downloader18_bloc.dart';

abstract class Downloader18Event extends Equatable {
  const Downloader18Event();

  @override
  List<Object> get props => [];
}

class DownloadStarted extends Downloader18Event {
  const DownloadStarted();

  @override
  List<Object> get props => [];
}

class StatusUpdated extends Downloader18Event {
  const StatusUpdated();

  @override
  List<Object> get props => [];
}

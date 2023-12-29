part of 'downloader_bloc.dart';

abstract class DownloaderEvent extends Equatable {
  const DownloaderEvent();

  @override
  List<Object> get props => [];
}

class DownloadStarted extends DownloaderEvent {
  const DownloadStarted();

  @override
  List<Object> get props => [];
}

class StatusUpdated extends DownloaderEvent {
  const StatusUpdated();

  @override
  List<Object> get props => [];
}

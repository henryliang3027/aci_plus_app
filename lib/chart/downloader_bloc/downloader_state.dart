part of 'downloader_bloc.dart';

class DownloaderState extends Equatable {
  const DownloaderState({
    this.status = FormStatus.none,
  });

  final FormStatus status;

  @override
  List<Object> get props => [];
}

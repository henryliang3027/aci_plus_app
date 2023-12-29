import 'package:aci_plus_app/chart/downloader_bloc/downloader_bloc.dart';
import 'package:aci_plus_app/chart/view/downloader_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloaderPage extends StatelessWidget {
  const DownloaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DownloaderBloc(
          amp18Repository: RepositoryProvider.of<Amp18Repository>(context)),
      child: const DownloaderForm(),
    );
  }
}

import 'package:aci_plus_app/chart/downloader18_bloc/downloader18_bloc.dart';
import 'package:aci_plus_app/chart/view/downloader18_form.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Downloader18Page extends StatelessWidget {
  const Downloader18Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Downloader18Bloc(
          amp18Repository: RepositoryProvider.of<Amp18Repository>(context)),
      child: const DownloaderForm(),
    );
  }
}

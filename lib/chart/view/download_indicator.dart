import 'package:dsim_app/chart/chart/chart18_bloc/chart18_bloc.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class DownloadIndicatorForm extends StatelessWidget {
//   const DownloadIndicatorForm({super.key});

//   @override
//   Widget build(BuildContext context) {

//     return BlocBuilder<Chart18Bloc, Chart18State>(
//         buildWhen: (previous, current) =>
//             previous.chunckIndex != current.chunckIndex,
//         builder: (context, state) {
//           return AlertDialog(
//             title: Text(
//               AppLocalizations.of(context).dialogTitleProcessing,
//             ),
//             actionsAlignment: MainAxisAlignment.center,
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: <Widget>[
//                   LinearProgressIndicator(),
//                   Text('${state.chunckIndex / 10 * 100.0}%'),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop(); // pop dialog
//                 },
//               ),
//             ],
//           );
//         });
//   }
// }

class DownloadIndicatorForm extends StatefulWidget {
  const DownloadIndicatorForm({super.key, required this.dsimRepository});

  final DsimRepository dsimRepository;

  @override
  State<DownloadIndicatorForm> createState() => _DownloadIndicatorFormState();
}

class _DownloadIndicatorFormState extends State<DownloadIndicatorForm>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late int chunckIndex;
  @override
  void initState() {
    super.initState();
    chunckIndex = 0;

    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    downloadLogs();
  }

  Future<void> downloadLogs() async {
    DsimRepository dsimRepository = widget.dsimRepository;
    List<Log1p8G> log1p8Gs = [];
    for (int i = 0; i < 10; i++) {
      List<dynamic> resultOfLog =
          await dsimRepository.requestCommand1p8GForLogChunk(i);
      print('current: $i');

      if (resultOfLog[0]) {
        log1p8Gs.addAll(resultOfLog[2]);

        if (resultOfLog[1]) {
          chunckIndex += 1;

          if (mounted) {
            controller.animateTo(
              chunckIndex / 10,
              duration: const Duration(milliseconds: 500),
            );
            setState(() {});
          }
        } else {
          chunckIndex = 10;
          if (mounted) {
            controller.animateTo(
              1,
              duration: const Duration(milliseconds: 500),
            );
            setState(() {});
          }
          break;
        }
      }
    }

    await Future.delayed(const Duration(milliseconds: 1500));
    Navigator.of(context).pop([
      true,
      log1p8Gs,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).dialogTitleDownloading,
      ),
      actionsAlignment: MainAxisAlignment.center,
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            LinearProgressIndicator(
              value: controller.value,
            ),
            Text('${chunckIndex / 10 * 100.0}%'),
          ],
        ),
      ),
      // actions: <Widget>[
      //   TextButton(
      //     child: const Text('OK'),
      //     onPressed: () {
      //       controller.dispose();
      //       Navigator.of(context).pop(); // pop dialog
      //     },
      //   ),
      // ],
    );
  }
}

import 'package:aci_plus_app/repositories/dsim18_parser.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DownloadIndicator18Form extends StatefulWidget {
  const DownloadIndicator18Form({
    super.key,
    required this.dsimRepository,
  });

  final DsimRepository dsimRepository;

  @override
  State<DownloadIndicator18Form> createState() =>
      _DownloadIndicator18FormState();
}

class _DownloadIndicator18FormState extends State<DownloadIndicator18Form>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late int chunckIndex;
  late bool isStart = false;
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
  }

  Future<List> getLogChunkWithRetry(int chunkIndex) async {
    DsimRepository dsimRepository = widget.dsimRepository;

    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int j = 0; j < 3; j++) {
      List<dynamic> resultOfLog =
          await dsimRepository.requestCommand1p8GForLogChunk(chunkIndex);

      if (resultOfLog[0]) {
        return resultOfLog;
      } else {
        if (j == 2) {
          break;
        } else {
          continue;
        }
      }
    }
    return [false];
  }

  Future<dynamic> downloadLogs() async {
    List<Log1p8G> log1p8Gs = [];
    bool isSuccessful = false;
    for (int i = 0; i < 10; i++) {
      List<dynamic> resultOfLog = await getLogChunkWithRetry(i);

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
          if (chunckIndex == 9) {
            isSuccessful = true;
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
          isSuccessful = true;
          break;
        }
      } else {
        isSuccessful = false;
        break;
      }
    }

    await Future.delayed(const Duration(milliseconds: 1500));
    if (isSuccessful) {
      return ([
        true,
        log1p8Gs,
        '',
      ]);
    } else {
      return ([
        false,
        log1p8Gs,
        'Data loading failed',
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isStart) {
      downloadLogs().then((result) => Navigator.of(context).pop(result));

      isStart = true;
    }
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
    );
  }
}

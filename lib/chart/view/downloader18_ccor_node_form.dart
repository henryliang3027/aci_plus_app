import 'package:aci_plus_app/chart/downloader18_ccor_node_bloc/downloader18_ccor_node_bloc.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Downloader18CCorNodeForm extends StatefulWidget {
  const Downloader18CCorNodeForm({super.key});

  @override
  State<Downloader18CCorNodeForm> createState() =>
      _Downloader18CCorNodeFormState();
}

class _Downloader18CCorNodeFormState extends State<Downloader18CCorNodeForm>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Downloader18CCorNodeState downloaderState =
            context.read<Downloader18CCorNodeBloc>().state;
        if (downloaderState.status.isRequestSuccess) {
          Navigator.of(context).pop([
            true,
            downloaderState.log1p8Gs,
            downloaderState.errorMessage,
          ]);
        } else if (downloaderState.status.isRequestFailure) {
          // if (ModalRoute.of(context)?.isCurrent == false) {
          //   Navigator.of(context).pop();
          // }

          // Navigator.of(context).pop([
          //   false,
          //   downloaderState.log1p8Gs,
          //   downloaderState.errorMessage,
          // ]);

          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {}
      }
    });

    context.read<Downloader18CCorNodeBloc>().stream.listen((state) {
      print('currentProgress: ${state.currentProgress}');
      animationController.animateTo(
        state.currentProgress / 10,
        duration: const Duration(milliseconds: 200),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.dialogTitleDownloading,
            style: const TextStyle(
              fontSize: CustomStyle.sizeXXL,
            ),
          ),
          const SizedBox(
            height: CustomStyle.sizeXXL,
          ),
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              Downloader18CCorNodeState downloaderState =
                  context.read<Downloader18CCorNodeBloc>().state;
              return SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    LinearProgressIndicator(
                      value: animationController.value,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: Text(
                        '${downloaderState.currentProgress / 10 * 100.0}%',
                        style: const TextStyle(
                          fontSize: CustomStyle.sizeL,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:aci_plus_app/chart/downloader18_rf_out_bloc/downloader18_rf_out_bloc.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Downloader18RFOutForm extends StatefulWidget {
  const Downloader18RFOutForm({super.key});

  @override
  State<Downloader18RFOutForm> createState() => _Downloader18RFOutFormState();
}

class _Downloader18RFOutFormState extends State<Downloader18RFOutForm>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Downloader18RFOutState downloaderState =
            context.read<Downloader18RFOutBloc>().state;
        if (downloaderState.status.isRequestSuccess) {
          Navigator.of(context).pop([
            true,
            downloaderState.rfOutputLog1p8Gs,
            downloaderState.errorMessage,
          ]);
        } else if (downloaderState.status.isRequestFailure) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            Navigator.of(context).pop([
              false,
              downloaderState.rfOutputLog1p8Gs,
              downloaderState.errorMessage,
            ]);
          }
        } else {}
      }
    });

    context.read<Downloader18RFOutBloc>().stream.listen((state) {
      print('currentProgress: ${state.currentProgress}');
      animationController.animateTo(
        state.currentProgress / 10,
        duration: const Duration(milliseconds: 200),
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Padding(
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
                Downloader18RFOutState downloaderState =
                    context.read<Downloader18RFOutBloc>().state;
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
      ),
    );
  }
}

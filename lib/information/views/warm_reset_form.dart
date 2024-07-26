import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/information/bloc/warm_reset/warm_reset_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WarmResetForm extends StatelessWidget {
  const WarmResetForm({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.warmReset,
                  style: const TextStyle(
                    fontSize: CustomStyle.size24,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: CustomStyle.sizeXXL,
            ),
            const _ProgressBar(),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatefulWidget {
  const _ProgressBar({super.key});

  @override
  State<_ProgressBar> createState() => __ProgressBarState();
}

class __ProgressBarState extends State<_ProgressBar>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);
    animationController.addStatusListener((status) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WarmResetBloc, WarmResetState>(
      listenWhen: (previous, current) =>
          previous.currentProgress != current.currentProgress,
      listener: (context, state) {
        animationController.animateTo(
          state.currentProgress,
          duration: const Duration(milliseconds: 200),
        );

        if (state.currentProgress == 1.0) {
          Future.delayed(const Duration(seconds: 1)).then(
            (_) {
              Navigator.pop(context);
            },
          );
        }
      },
      child: BlocBuilder<WarmResetBloc, WarmResetState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      minHeight: 10,
                      value: animationController.value,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    state.message,
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
    );
  }
}

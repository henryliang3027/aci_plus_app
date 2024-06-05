import 'package:aci_plus_app/advanced/bloc/setting18_firmware/setting18_firmware_bloc.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/firmware_file_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18FirmwareForm extends StatelessWidget {
  const Setting18FirmwareForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _UserCaution(),
          _ProgressBar(),
          _Progress(),
        ],
      ),
    );
  }
}

class _UserCaution extends StatelessWidget {
  const _UserCaution({super.key});

  @override
  Widget build(BuildContext context) {
    Widget getInstructionRow({
      required String number,
      required String description,
    }) {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: CustomStyle.sizeXXL,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: CustomStyle.sizeXXL,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30.0,
          ),
          child: Row(
            children: [
              Text(
                '${AppLocalizations.of(context)!.instruction}: ',
                style: TextStyle(
                  fontSize: CustomStyle.size32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        getInstructionRow(
          number: '1. ',
          description: AppLocalizations.of(context)!.firmawreUpdateCaution1,
        ),
        getInstructionRow(
          number: '2. ',
          description: AppLocalizations.of(context)!.firmawreUpdateCaution2,
        ),
        getInstructionRow(
          number: '3. ',
          description: AppLocalizations.of(context)!.firmawreUpdateCaution3,
        ),
      ],
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
    return BlocListener<Setting18FirmwareBloc, Setting18FirmwareState>(
      listenWhen: (previous, current) =>
          previous.updateMessage != current.updateMessage,
      listener: (context, state) {
        animationController.animateTo(
          state.currentProgress,
          duration: const Duration(milliseconds: 200),
        );
      },
      child: BlocBuilder<Setting18FirmwareBloc, Setting18FirmwareState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: animationController.value,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    state.updateMessage,
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

class _Progress extends StatelessWidget {
  const _Progress({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18FirmwareBloc, Setting18FirmwareState>(
        builder: (context, state) {
      return Column(
        children: [
          DropdownButton<String>(
            value: state.selectedBinary,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple, fontSize: 20),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              if (value != null) {
                context
                    .read<Setting18FirmwareBloc>()
                    .add(BinarySelected(value));
              }
            },
            items: FirmwareFileTable.filePathMap.entries
                .map((entry) => DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    ))
                .toList(),
          ),
          // // LinearProgressIndicator(
          // //   value: 0.5,
          // // ),

          Wrap(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size(80, 60),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
                    ),
                    textStyle: const TextStyle(
                      fontSize: CustomStyle.sizeXXL,
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<Setting18FirmwareBloc>()
                        .add(const BootloaderStarted());
                  },
                  child: Text('B'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size(80, 60),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
                    ),
                    textStyle: const TextStyle(
                      fontSize: CustomStyle.sizeXXL,
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<Setting18FirmwareBloc>()
                        .add(const BootloaderExited());
                  },
                  child: Text('M'),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 0),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Theme.of(context).colorScheme.primary,
              //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
              //       minimumSize: const Size(100, 60),
              //       shape: const RoundedRectangleBorder(
              //         borderRadius:
              //             BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
              //       ),
              //       textStyle: const TextStyle(
              //         fontSize: CustomStyle.sizeXXL,
              //       ),
              //     ),
              //     onPressed: () {
              //       context
              //           .read<Setting18FirmwareBloc>()
              //           .add(const UpdateStarted());
              //     },
              //     child: Text(
              //       AppLocalizations.of(context)!.startUpdate,
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size(80, 60),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
                    ),
                    textStyle: const TextStyle(
                      fontSize: CustomStyle.sizeXXL,
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<Setting18FirmwareBloc>()
                        .add(const CommandWrited('C'));
                  },
                  child: Text("C"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size(80, 60),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
                    ),
                    textStyle: const TextStyle(
                      fontSize: CustomStyle.sizeXXL,
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<Setting18FirmwareBloc>()
                        .add(const CommandWrited('Y'));
                  },
                  child: Text("Y"),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 0),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Theme.of(context).colorScheme.primary,
              //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
              //       minimumSize: const Size(100, 60),
              //       shape: const RoundedRectangleBorder(
              //         borderRadius:
              //             BorderRadius.all(Radius.circular(CustomStyle.sizeS)),
              //       ),
              //       textStyle: const TextStyle(
              //         fontSize: CustomStyle.sizeXXL,
              //       ),
              //     ),
              //     onPressed: () {
              //       context
              //           .read<Setting18FirmwareBloc>()
              //           .add(const CommandWrited('N'));
              //     },
              //     child: Text("N"),
              //   ),
              // ),
            ],
          ),
        ],
      );
    });
  }
}

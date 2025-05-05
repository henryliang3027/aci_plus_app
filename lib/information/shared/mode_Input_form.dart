import 'package:aci_plus_app/core/custom_dialog.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/information/bloc/mode_input/mode_input_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModeInputForm extends StatelessWidget {
  ModeInputForm({super.key});

  final TextEditingController _codeTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ModeInputBloc, ModeInputState>(
      listener: (context, state) {
        if (state.isInitialize) {
          _codeTextEditingController.text = state.code;
        }
      },
      child: _CodeInputDialog(
        codeTextEditingController: _codeTextEditingController,
      ),
    );
  }
}

class _CodeInputDialog extends StatelessWidget {
  const _CodeInputDialog({
    required this.codeTextEditingController,
  });

  final TextEditingController codeTextEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModeInputBloc, ModeInputState>(
      builder: (context, state) {
        return CustomDialog(
          title: AppLocalizations.of(context)!.dialogTitleEnterPassword,
          content: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .dialogMessageEnterExpertModePassword,
                    style: const TextStyle(
                      fontSize: CustomStyle.sizeL,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6.0,
              ),
              TextField(
                onChanged: (code) {
                  context.read<ModeInputBloc>().add(CodeChanged(code: code));
                },
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                // ],
                controller: codeTextEditingController,
                // maxLength: 8,
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context)!.dialogMessagePasswordHint,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  contentPadding: const EdgeInsets.all(8.0),
                  isDense: true,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondaryContainer,
                  counterText: '',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.dialogMessageCancel,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false); // pop dialog
                    },
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  ElevatedButton(
                    onPressed: state.isMatched
                        ? () {
                            Navigator.of(context).pop(true);
                          }
                        : null,
                    child: Text(
                      AppLocalizations.of(context)!.dialogMessageOk,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

        // Center(
        //   child: Container(
        //     width: 360,
        //     child: Dialog(
        //       insetPadding: EdgeInsets.all(0),
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Container(
        //             alignment: Alignment.center,
        //             width: double.maxFinite,
        //             height: 58,
        //             decoration: BoxDecoration(
        //               borderRadius: const BorderRadius.only(
        //                   topLeft: Radius.circular(20.0),
        //                   topRight: Radius.circular(20.0)),
        //               color: Theme.of(context).colorScheme.primary,
        //             ),
        //             child: Text(
        //               AppLocalizations.of(context)!.dialogTitleEnterPassword,
        //               style: TextStyle(
        //                 fontSize: CustomStyle.sizeXL,
        //                 color: Theme.of(context).colorScheme.onPrimary,
        //               ),
        //             ),
        //           ),
        //           Flexible(
        //             child: SingleChildScrollView(
        //               child: Padding(
        //                 padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
        //                 child: Column(
        //                   children: [
        //                     Row(
        //                       children: [
        //                         Text(
        //                           AppLocalizations.of(context)!
        //                               .dialogMessageEnterExpertModePassword,
        //                           style: const TextStyle(
        //                             fontSize: CustomStyle.sizeL,
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                     const SizedBox(
        //                       height: 6.0,
        //                     ),
        //                     TextField(
        //                       onChanged: (code) {
        //                         context
        //                             .read<ModeInputBloc>()
        //                             .add(CodeChanged(code: code));
        //                       },
        //                       // inputFormatters: [
        //                       //   FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        //                       // ],
        //                       controller: codeTextEditingController,
        //                       // maxLength: 8,
        //                       decoration: InputDecoration(
        //                         hintText: AppLocalizations.of(context)!
        //                             .dialogMessageCodeHint,
        //                         border: const OutlineInputBorder(
        //                             borderRadius:
        //                                 BorderRadius.all(Radius.circular(4.0))),
        //                         contentPadding: const EdgeInsets.all(8.0),
        //                         isDense: true,
        //                         filled: true,
        //                         fillColor: Theme.of(context)
        //                             .colorScheme
        //                             .secondaryContainer,
        //                         counterText: '',
        //                       ),
        //                     ),
        //                     const SizedBox(
        //                       height: 20,
        //                     ),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.end,
        //                       children: [
        //                         ElevatedButton(
        //                           child: Text(
        //                             AppLocalizations.of(context)!
        //                                 .dialogMessageCancel,
        //                           ),
        //                           onPressed: () {
        //                             Navigator.of(context)
        //                                 .pop(false); // pop dialog
        //                           },
        //                         ),
        //                         SizedBox(
        //                           width: 8.0,
        //                         ),
        //                         ElevatedButton(
        //                           onPressed: state.isMatched
        //                               ? () {
        //                                   Navigator.of(context).pop(true);
        //                                 }
        //                               : null,
        //                           child: Text(
        //                             AppLocalizations.of(context)!
        //                                 .dialogMessageOk,
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // );

        // AlertDialog(
        //   title: Text(
        //     AppLocalizations.of(context)!.dialogTitleEnterPassword,
        //   ),
        //   content: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Text(
        //         AppLocalizations.of(context)!
        //             .dialogMessageEnterExpertModePassword,
        //       ),
        //       const SizedBox(
        //         height: 6.0,
        //       ),
        //       TextField(
        //         onChanged: (code) {
        //           context.read<ModeInputBloc>().add(CodeChanged(code: code));
        //         },
        //         // inputFormatters: [
        //         //   FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        //         // ],
        //         controller: codeTextEditingController,
        //         // maxLength: 8,
        //         decoration: InputDecoration(
        //           hintText: AppLocalizations.of(context)!.dialogMessageCodeHint,
        //           border: const OutlineInputBorder(
        //               borderRadius: BorderRadius.all(Radius.circular(4.0))),
        //           contentPadding: const EdgeInsets.all(8.0),
        //           isDense: true,
        //           filled: true,
        //           fillColor: Theme.of(context).colorScheme.secondaryContainer,
        //           counterText: '',
        //         ),
        //       ),
        //       const SizedBox(
        //         height: 20,
        //       ),
        //     ],
        //   ),
        //   actions: <Widget>[
        //     ElevatedButton(
        //       child: Text(
        //         AppLocalizations.of(context)!.dialogMessageCancel,
        //       ),
        //       onPressed: () {
        //         Navigator.of(context).pop(false); // pop dialog
        //       },
        //     ),
        //     ElevatedButton(
        //       onPressed: state.isMatched
        //           ? () {
        //               Navigator.of(context).pop(true);
        //             }
        //           : null,
        //       child: Text(
        //         AppLocalizations.of(context)!.dialogMessageOk,
        //       ),
        //     ),
        //   ],
        // );

        // Center(
        //   child: SizedBox(
        //     width: 380,
        //     child: Dialog(
        //       insetPadding: EdgeInsets.all(0),
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Container(
        //             alignment: Alignment.center,
        //             width: double.maxFinite,
        //             height: 58,
        //             decoration: BoxDecoration(
        //               borderRadius: const BorderRadius.only(
        //                   topLeft: Radius.circular(20.0),
        //                   topRight: Radius.circular(20.0)),
        //               color: Theme.of(context).colorScheme.primary,
        //             ),
        //             child: Text(
        //               AppLocalizations.of(context)!.expertMode,
        //               style: TextStyle(
        //                 fontSize: CustomStyle.sizeXL,
        //                 color: Theme.of(context).colorScheme.onPrimary,
        //               ),
        //             ),
        //           ),
        //           Flexible(
        //             child: SingleChildScrollView(
        //               child: Padding(
        //                 padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       AppLocalizations.of(context)!
        //                           .dialogMessageEnterExpertModePassword,
        //                       style: TextStyle(fontSize: CustomStyle.sizeL),
        //                     ),
        //                     const SizedBox(
        //                       height: 10.0,
        //                     ),
        //                     TextField(
        //                       onChanged: (code) {
        //                         context
        //                             .read<ModeInputBloc>()
        //                             .add(CodeChanged(code: code));
        //                       },
        //                       // inputFormatters: [
        //                       //   FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        //                       // ],
        //                       controller: codeTextEditingController,
        //                       // maxLength: 8,
        //                       decoration: InputDecoration(
        //                         hintText: AppLocalizations.of(context)!
        //                             .dialogMessageCodeHint,
        //                         border: const OutlineInputBorder(
        //                             borderRadius:
        //                                 BorderRadius.all(Radius.circular(4.0))),
        //                         contentPadding: const EdgeInsets.all(8.0),
        //                         isDense: true,
        //                         filled: true,
        //                         fillColor: Theme.of(context)
        //                             .colorScheme
        //                             .secondaryContainer,
        //                         counterText: '',
        //                       ),
        //                     ),
        //                     const SizedBox(
        //                       height: 20,
        //                     ),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.end,
        //                       children: [
        //                         Padding(
        //                           padding: const EdgeInsets.symmetric(
        //                               horizontal: 0.0),
        //                           child: ElevatedButton(
        //                             onPressed: state.isMatched
        //                                 ? () {
        //                                     Navigator.of(context).pop();
        //                                   }
        //                                 : null,
        //                             style: ElevatedButton.styleFrom(
        //                               padding: const EdgeInsets.symmetric(
        //                                 vertical: 0.0,
        //                                 horizontal: 20.0,
        //                               ),
        //                               tapTargetSize:
        //                                   MaterialTapTargetSize.shrinkWrap,
        //                             ),
        //                             child: Text(
        //                               AppLocalizations.of(context)!
        //                                   .dialogMessageOk,
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }
}

// import 'package:aci_plus_app/core/common_enum.dart';
// import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
// import 'package:aci_plus_app/core/data_key.dart';
// import 'package:aci_plus_app/core/form_status.dart';
// import 'package:aci_plus_app/core/setup_wizard_dialog.dart';
// import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class Status18SetupWizard extends StatelessWidget {
//   const Status18SetupWizard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       buildWhen: (previous, current) =>
//           previous.loadingStatus != current.loadingStatus,
//       builder: (context, state) {
//         String partId = state.characteristicData[DataKey.partId] ?? '';

//         return FloatingActionButton(
//           heroTag: null,
//           shape: const CircleBorder(
//             side: BorderSide.none,
//           ),
//           backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
//           onPressed: () {
//             showSetupWizardDialog(
//               context: context,
//               functionDescriptionType: FunctionDescriptionType.status,
//               aciDeviceType: partId == '4'
//                   ? ACIDeviceType.ampCCorNode1P8G
//                   : ACIDeviceType.amp1P8G,
//             );
//           },
//           child: Icon(
//             CustomIcons.information,
//             color: Theme.of(context).colorScheme.onPrimary,
//           ),
//         );
//       },
//     );
//   }
// }

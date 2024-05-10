import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_button_navigation_bar18.dart';
import 'package:aci_plus_app/setting/views/setting18_views/setting18_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class Setting18Form extends StatefulWidget {
//   const Setting18Form({
//     super.key,
//     required this.pageController,
//   });

//   final PageController pageController;

//   @override
//   State<Setting18Form> createState() => _Setting18FormState();
// }

// class _Setting18FormState extends State<Setting18Form>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     _tabController = TabController(
//       vsync: this,
//       length: 4,
//     );

//     _tabController.addListener(() {
//       if (_tabController.indexIsChanging) {
//         setState(() {});
//       }
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.setting),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         centerTitle: true,
//         leading: const _DeviceStatus(),
//         actions: [
//           _PopupMenu(
//             tabController: _tabController,
//           ),
//         ],
//       ),
//       body: _ViewLayout(
//         tabController: _tabController,
//       ),
//       bottomNavigationBar: HomeBottomNavigationBar(
//         pageController: widget.pageController,
//         selectedIndex: 0,
//         onTap: (int index) {
//           widget.pageController.jumpToPage(
//             index,
//           );
//         },
//       ),
//       // floatingActionButton: const _Setting18FloatingActionButton(),
//     );
//   }
// }

class Setting18Form extends StatelessWidget {
  const Setting18Form({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        leading: const _DeviceStatus(),
        actions: const [
          _DeviceRefresh(),
        ],
      ),
      body: const _ViewLayout(),
      bottomNavigationBar: HomeBottomNavigationBar18(
        pageController: pageController,
        selectedIndex: 0,
        onTap: (int index) {
          pageController.jumpToPage(
            index,
          );
        },
      ),
      // floatingActionButton: const _Setting18FloatingActionButton(),
    );
  }
}

class _DeviceStatus extends StatelessWidget {
  const _DeviceStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.scanStatus.isRequestSuccess) {
          if (state.connectionStatus.isRequestSuccess) {
            return const Icon(
              Icons.bluetooth_connected_outlined,
            );
          } else if (state.connectionStatus.isRequestFailure) {
            return const Icon(
              Icons.nearby_error,
              color: Colors.amber,
            );
          } else {
            return const Center(
              child: SizedBox(
                width: CustomStyle.diameter,
                height: CustomStyle.diameter,
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              ),
            );
          }
        } else if (state.scanStatus.isRequestFailure) {
          return const Icon(
            Icons.nearby_error_outlined,
          );
        } else {
          return const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}

// enum Setting18Menu {
//   refresh,
//   resetForward,
//   resetReverse,
// }

// class _PopupMenu extends StatelessWidget {
//   const _PopupMenu({
//     super.key,
//     required this.tabController,
//   });

//   final TabController tabController;

//   Widget buildControlPageMenu(BuildContext context) {
//     return BlocBuilder<Setting18Bloc, Setting18State>(
//       builder: (context, state) {
//         Future<bool?> showNoticeDialog({
//           required String message,
//         }) async {
//           return showDialog<bool?>(
//             context: context,
//             barrierDismissible: false, // user must tap button!
//             builder: (BuildContext context) {
//               var width = MediaQuery.of(context).size.width;
//               // var height = MediaQuery.of(context).size.height;

//               return AlertDialog(
//                 insetPadding: EdgeInsets.symmetric(
//                   horizontal: width * 0.1,
//                 ),
//                 title: Text(
//                   AppLocalizations.of(context)!.dialogTitleNotice,
//                   style: const TextStyle(
//                     color: CustomStyle.customYellow,
//                   ),
//                 ),
//                 content: SizedBox(
//                   width: width,
//                   child: SingleChildScrollView(
//                     child: ListBody(
//                       children: [
//                         Text(
//                           message,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 actions: <Widget>[
//                   TextButton(
//                     child: Text(
//                       AppLocalizations.of(context)!.dialogMessageOk,
//                     ),
//                     onPressed: () {
//                       Navigator.of(context).pop(true); // pop dialog
//                     },
//                   ),
//                   TextButton(
//                     child: Text(
//                       AppLocalizations.of(context)!.dialogMessageCancel,
//                     ),
//                     onPressed: () {
//                       Navigator.of(context).pop(false); // pop dialog
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//         }

//         return PopupMenuButton<Setting18Menu>(
//           onSelected: (Setting18Menu item) async {
//             switch (item) {
//               case Setting18Menu.refresh:
//                 context.read<HomeBloc>().add(const DeviceRefreshed());
//                 break;
//               case Setting18Menu.resetForward:
//                 showNoticeDialog(
//                   message: AppLocalizations.of(context)!
//                       .dialogMessageResetForwardToDefault,
//                 ).then((isConfirm) {
//                   if (isConfirm != null) {
//                     if (isConfirm) {
//                       context
//                           .read<Setting18ControlBloc>()
//                           .add(const ResetForwardParameterRequested());
//                     }
//                   }
//                 });

//                 break;
//               case Setting18Menu.resetReverse:
//                 showNoticeDialog(
//                   message: AppLocalizations.of(context)!
//                       .dialogMessageResetReverseToDefault,
//                 ).then((isConfirm) {
//                   if (isConfirm != null) {
//                     if (isConfirm) {
//                       context
//                           .read<Setting18ControlBloc>()
//                           .add(const ResetReverseParameterRequested());
//                     }
//                   }
//                 });

//                 break;
//             }
//           },
//           itemBuilder: (BuildContext context) =>
//               <PopupMenuEntry<Setting18Menu>>[
//             PopupMenuItem<Setting18Menu>(
//               value: Setting18Menu.refresh,
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const Icon(
//                     Icons.refresh,
//                     size: 20.0,
//                     color: Colors.black,
//                   ),
//                   const SizedBox(
//                     width: 10.0,
//                   ),
//                   Text(AppLocalizations.of(context)!.reconnect),
//                 ],
//               ),
//             ),
//             PopupMenuItem<Setting18Menu>(
//               value: Setting18Menu.resetForward,
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const Icon(
//                     Icons.arrow_circle_down,
//                     size: 20.0,
//                     color: Colors.black,
//                   ),
//                   const SizedBox(
//                     width: 10.0,
//                   ),
//                   Text(AppLocalizations.of(context)!.resetForward),
//                 ],
//               ),
//             ),
//             PopupMenuItem<Setting18Menu>(
//               value: Setting18Menu.resetReverse,
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const Icon(
//                     Icons.arrow_circle_up,
//                     size: 20.0,
//                     color: Colors.black,
//                   ),
//                   const SizedBox(
//                     width: 10.0,
//                   ),
//                   Text(AppLocalizations.of(context)!.resetReverse),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget buildReFreshMenu(BuildContext context) {
//     return BlocBuilder<Setting18Bloc, Setting18State>(
//       builder: (context, state) {
//         return IconButton(
//           onPressed: () {
//             context.read<HomeBloc>().add(const DeviceRefreshed());
//           },
//           icon: Icon(
//             Icons.refresh,
//             color: Theme.of(context).colorScheme.onPrimary,
//           ),
//         );
//       },
//     );
//   }

//   Widget getMenu(BuildContext context) {
//     if (tabController.index == 2) {
//       return buildControlPageMenu(context);
//     } else {
//       return buildReFreshMenu(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       builder: (context, state) {
//         if (!state.loadingStatus.isRequestInProgress &&
//             !state.connectionStatus.isRequestInProgress) {
//           return getMenu(context);
//         } else {
//           return Container();
//         }
//       },
//     );
//   }
// }

class _DeviceRefresh extends StatelessWidget {
  const _DeviceRefresh({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (!state.loadingStatus.isRequestInProgress &&
            !state.connectionStatus.isRequestInProgress) {
          return IconButton(
              onPressed: () {
                context.read<HomeBloc>().add(const DeviceRefreshed());
              },
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onPrimary,
              ));
        } else {
          return Container();
        }
      },
    );
  }
}

class _ViewLayout extends StatelessWidget {
  const _ViewLayout({
    super.key,
    // required this.tabController,
  });

  // final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadingStatus.isRequestInProgress) {
          return Stack(
            alignment: Alignment.center,
            children: [
              const Setting18TabBar(
                  // tabController: tabController,
                  ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(70, 158, 158, 158),
                ),
                child: const Center(
                  child: SizedBox(
                    width: CustomStyle.diameter,
                    height: CustomStyle.diameter,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Setting18TabBar(
              // tabController: tabController,
              );
        }
      },
    );
  }
}

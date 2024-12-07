import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_button_navigation_bar18.dart';

import 'package:aci_plus_app/setting/views/setting18_views/setting18_tabbar_page.dart';
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
        centerTitle: true,
        leading: const _DeviceStatus(),
        actions: const [
          _DeviceRefresh(),
        ],
      ),
      body: const Setting18TabBarPage(),
      bottomNavigationBar: HomeBottomNavigationBar18(
        pageController: pageController,
        selectedIndex: 0,
        onTap: (int index) {
          NoticeFlag.leftDevicePage = true;
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
  const _DeviceStatus();

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
        } else if (state.scanStatus.isRequestInProgress) {
          return const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        } else {
          return const Center();
        }
      },
    );
  }
}

class _DeviceRefresh extends StatelessWidget {
  const _DeviceRefresh();

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

// class _ViewLayout extends StatelessWidget {
//   const _ViewLayout();

//   // final TabController tabController;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       builder: (context, state) {
//         if (state.loadingStatus.isRequestInProgress) {
//           return Stack(
//             alignment: Alignment.center,
//             children: [
//               const Setting18TabBarPage(
//                   // tabController: tabController,
//                   ),
//               Container(
//                 decoration: const BoxDecoration(
//                   color: Color.fromARGB(70, 158, 158, 158),
//                 ),
//                 child: const Center(
//                   child: SizedBox(
//                     width: CustomStyle.diameter,
//                     height: CustomStyle.diameter,
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return const Setting18TabBarPage(
//               // tabController: tabController,
//               );
//         }
//       },
//     );
//   }
// }

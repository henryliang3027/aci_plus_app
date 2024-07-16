import 'package:aci_plus_app/advanced/bloc/setting18_advanced/setting18_advanced_bloc.dart';
import 'package:aci_plus_app/advanced/view/setting18_advanced_tab_bar.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_button_navigation_bar18.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18AdvancedForm extends StatefulWidget {
  const Setting18AdvancedForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  State<Setting18AdvancedForm> createState() => _Setting18AdvancedFormState();
}

class _Setting18AdvancedFormState extends State<Setting18AdvancedForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.advanced,
        ),
        centerTitle: true,
        leading: const _DeviceStatus(),
        actions: const [
          _DeviceRefresh(),
        ],
      ),
      body: _ViewLayout(
        pageController: widget.pageController,
        tabController: _tabController,
      ),
      bottomNavigationBar: _DynamicBottomNavigationBar(
        pageController: widget.pageController,
      ),
    );
  }
}

class _DynamicBottomNavigationBar extends StatelessWidget {
  const _DynamicBottomNavigationBar({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Setting18AdvancedBloc, Setting18AdvancedState>(
      builder: (context, state) {
        if (state.enableButtonsTap) {
          return HomeBottomNavigationBar18(
            pageController: pageController,
            selectedIndex: 4,
            onTap: (int index) {
              pageController.jumpToPage(
                index,
              );
            },
          );
        } else {
          return HomeBottomNavigationBar18(
            pageController: pageController,
            selectedIndex: 4,
            enableTap: false,
            onTap: (int index) {
              pageController.jumpToPage(
                index,
              );
            },
          );
        }
      },
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
  const _DeviceRefresh({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        HomeState homeState = context.watch<HomeBloc>().state;
        Setting18AdvancedState setting18advancedState =
            context.watch<Setting18AdvancedBloc>().state;

        if (!homeState.loadingStatus.isRequestInProgress &&
            !homeState.connectionStatus.isRequestInProgress &&
            setting18advancedState.enableButtonsTap) {
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
    required this.pageController,
    required this.tabController,
  });

  final PageController pageController;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadingStatus.isRequestInProgress) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Setting18AdvancedTabBar(
                pageController: pageController,
                tabController: tabController,
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
          return Setting18AdvancedTabBar(
            pageController: pageController,
            tabController: tabController,
          );
        }
      },
    );
  }
}

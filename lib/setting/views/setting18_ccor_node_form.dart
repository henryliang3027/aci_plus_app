import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_bottom_navigation_bar.dart';
import 'package:aci_plus_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:aci_plus_app/setting/views/setting18_ccor_node_tab_bar.dart';
import 'package:aci_plus_app/setting/views/setting18_graph_view.dart';
import 'package:aci_plus_app/setting/views/setting18_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting18CCorNodeForm extends StatelessWidget {
  const Setting18CCorNodeForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).setting),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        leading: const _DeviceStatus(),
        actions: const [_DeviceRefresh()],
      ),
      body: const _ViewLayout(),
      bottomNavigationBar: HomeBottomNavigationBar(
        pageController: pageController,
        selectedIndex: 0,
        onTap: (int index) {
          pageController.jumpToPage(
            index,
          );
        },
      ),
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

class _DeviceRefresh extends StatelessWidget {
  const _DeviceRefresh({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (!state.connectionStatus.isRequestInProgress) {
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
  const _ViewLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadingStatus.isRequestInProgress) {
          return Stack(
            alignment: Alignment.center,
            children: [
              const Setting18TabBar(),
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
        } else if (state.loadingStatus.isRequestSuccess) {
          return const _Layout();
        } else if (state.loadingStatus.isRequestFailure) {
          return const _Layout();
        } else if (state.scanStatus.isRequestFailure) {
          return const _Layout();
        } else if (state.connectionStatus.isRequestFailure) {
          return const _Layout();
        } else {
          return const Center(
            child: SizedBox(
              width: CustomStyle.diameter,
              height: CustomStyle.diameter,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) =>
          previous.isGraphType != current.isGraphType,
      builder: (context, state) {
        if (state.isGraphType) {
          return const Setting18GraphView();
        } else {
          return const Setting18CCorNodeTabBar();
        }
      },
    );
  }
}

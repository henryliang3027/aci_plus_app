import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/message_localization.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_bottom_navigation_bar.dart';
import 'package:aci_plus_app/setting/views/setting_views/setting_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingForm extends StatelessWidget {
  const SettingForm({
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
  const _ViewLayout({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> showFailureDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitleError,
              style: const TextStyle(
                color: CustomStyle.customRed,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    getMessageLocalization(
                      msg: msg,
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadingStatus.isRequestInProgress) {
          // context.read<SettingListViewBloc>().add(const Initialized(true));
          return Stack(
            alignment: Alignment.center,
            children: [
              SettingListView(),
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
          return SettingListView();
        } else if (state.loadingStatus.isRequestFailure) {
          return SettingListView();
        } else if (state.scanStatus.isRequestFailure) {
          return SettingListView();
        } else if (state.connectionStatus.isRequestFailure) {
          return SettingListView();
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

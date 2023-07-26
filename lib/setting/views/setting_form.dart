import 'package:dsim_app/core/custom_style.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/core/message_localization.dart';
import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/setting/bloc/setting_bloc/setting_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_graph_view_bloc/setting_graph_view_bloc.dart';
import 'package:dsim_app/setting/bloc/setting_list_view_bloc/setting_list_view_bloc.dart';
import 'package:dsim_app/setting/views/setting_graph_view.dart';
import 'package:dsim_app/setting/views/setting_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingForm extends StatelessWidget {
  const SettingForm({super.key});

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
                width: 20.0,
                height: 20.0,
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
              width: 20.0,
              height: 20.0,
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
    Future<void> showFailureDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).dialogTitleError,
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
        if (state.loadingStatus.isRequestSuccess) {
          return const _Layout(
            isInitialized: true,
          );
        } else if (state.loadingStatus.isRequestFailure) {
          return const _Layout(
            isInitialized: false,
          );
        } else if (state.scanStatus.isRequestFailure) {
          return const _Layout(
            isInitialized: false,
          );
        } else if (state.connectionStatus.isRequestFailure) {
          return const _Layout(
            isInitialized: false,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout({
    super.key,
    required this.isInitialized,
  });

  final bool isInitialized;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) =>
          previous.isGraphType != current.isGraphType,
      builder: (context, state) {
        if (state.isGraphType) {
          return BlocProvider(
            create: (context) => SettingGraphViewBloc(
              dsimRepository: RepositoryProvider.of<DsimRepository>(context),
              isInitialized: isInitialized,
            ),
            child: SettingGraphView(),
          );
        } else {
          return BlocProvider(
            create: (context) => SettingListViewBloc(
              dsimRepository: RepositoryProvider.of<DsimRepository>(context),
              isInitialized: isInitialized,
            ),
            child: SettingListView(),
          );
        }
      },
    );
  }
}

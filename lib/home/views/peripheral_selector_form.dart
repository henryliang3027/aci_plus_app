import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/repositories/ble_peripheral.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PeripheralSelectorForm extends StatelessWidget {
  const PeripheralSelectorForm({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SizedBox(
        width: 370,
        height: 390,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                alignment: Alignment.center,
                width: double.maxFinite,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!
                            .dialogTitleSelectPeripheral,
                        style: TextStyle(
                          fontSize: CustomStyle.sizeXL,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: CustomStyle.size24),
                        child: _ScanCircularProgressIndicator(),
                      ),
                    ),
                  ],
                )),
            const _PeripheralListView(),
            const _DoneButton(),
          ],
        ),
      ),
    );
  }
}

class _ScanCircularProgressIndicator extends StatelessWidget {
  const _ScanCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.scanStatus.isRequestInProgress) {
          return const SizedBox(
            width: CustomStyle.diameter,
            height: CustomStyle.diameter,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _PeripheralListView extends StatelessWidget {
  const _PeripheralListView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.scanStatus != current.scanStatus,
      listener: (context, state) {
        if (state.scanStatus.isRequestSuccess) {
          if (state.peripherals.length == 1) {
            // 用 ModalRoute 檢查目前頁面是否還開著, 如果開著才 pop
            if (ModalRoute.of(context)?.isCurrent == true) {
              Navigator.pop(context, state.peripherals.first);
            }
          }
        }
      },
      buildWhen: (previous, current) =>
          previous.peripherals != current.peripherals,
      builder: (context, state) {
        return Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Column(
                children: [
                  for (Peripheral peripheral in state.peripherals) ...[
                    Card(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            peripheral.name,
                            style: const TextStyle(
                              fontSize: CustomStyle.sizeXL,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context, peripheral);
                        },
                        trailing: Icon(
                          Icons.bluetooth,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          0, CustomStyle.size24, CustomStyle.size24, CustomStyle.size24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 20.0,
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              AppLocalizations.of(context)!.dialogMessageDone,
            ),
          ),
        ],
      ),
    );
  }
}

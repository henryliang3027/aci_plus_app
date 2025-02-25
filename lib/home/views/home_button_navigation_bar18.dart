import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/pulsator.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeBottomNavigationBar18 extends StatelessWidget {
  const HomeBottomNavigationBar18({
    Key? key,
    required this.selectedIndex,
    required this.pageController,
    required this.onTap,
    this.enableTap = true,
  }) : super(key: key);

  final int selectedIndex;
  final PageController pageController;
  final ValueChanged<int> onTap;
  final bool enableTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10, // Adds shadow and elevation

      margin: const EdgeInsets.all(0), // Optional padding around the card
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.zero,
        ),
      ),
      color: Theme.of(context).bottomAppBarTheme.color,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).bottomAppBarTheme.color,
            ),
            child: const Indicator(),
          ),
          BottomNavigationBar(
            elevation: 0,
            // backgroundColor: Theme.of(context).bottomAppBarTheme.color,
            backgroundColor: Colors.transparent,

            type: BottomNavigationBarType.fixed,

            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.setting),
                label: 'Setting',
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.status),
                label: 'Status',
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.home),
                label: 'Information',
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.chart),
                label: 'Chart',
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.advanced),
                label: 'About',
                tooltip: '',
              ),
            ],
            //unselected icon size CustomStyle.size24
            currentIndex: selectedIndex,
            selectedIconTheme: const IconThemeData(size: CustomStyle.size36),
            selectedFontSize: 0.0,
            selectedItemColor:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            onTap: enableTap ? onTap : null,
          ),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Alarm getAlarmEnumFromString(String alarmString) {
      try {
        return Alarm.values.byName(alarmString);
      } catch (e) {
        return Alarm.medium;
      }
    }

    String getUnitStatusAlarmState({
      required String temperatureAlarmState,
      required String voltageAlarmState,
      required String voltageRippleAlarmState,
      required String rfOutputPowerAlarmState,
      required String rfOutputPilotLowFrequencyAlarmState,
      required String rfOutputPilotHighFrequencyAlarmState,
    }) {
      if (temperatureAlarmState == '1' &&
          voltageAlarmState == '1' &&
          voltageRippleAlarmState == '1' &&
          rfOutputPowerAlarmState == '1' &&
          rfOutputPilotLowFrequencyAlarmState == '1' &&
          rfOutputPilotHighFrequencyAlarmState == '1') {
        return '1';
      } else {
        return '0';
      }
    }

    Widget getPulsator({
      required String alarmState,
      required Alarm alarm,
      required String name,
      bool animationEnabled = true,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Pulsator(
          size: 24, // Circle size
          color: alarmState == '0'
              ? CustomStyle.alarmColor[alarm.name] ?? const Color(0xff6c757d)
              : CustomStyle.alarmColor[Alarm.medium.name]!, // Ripple color
          duration: const Duration(
            seconds: 2,
          ), //  animationEnabled = false 時 Ripple duration 可以忽略
          rippleCount:
              animationEnabled ? 1 : 0, // animationEnabled = false 時關閉動畫
          title: name,
        ),
      );
    }

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.characteristicData[DataKey.unitStatusAlarmSeverity] != current.characteristicData[DataKey.unitStatusAlarmSeverity] ||
          previous.characteristicData[DataKey.temperatureAlarmSeverity] !=
              current.characteristicData[DataKey.temperatureAlarmSeverity] ||
          previous.characteristicData[DataKey.voltageAlarmSeverity] !=
              current.characteristicData[DataKey.voltageAlarmSeverity] ||
          previous.characteristicData[DataKey.rfOutputPilotLowFrequencyAlarmSeverity] !=
              current.characteristicData[
                  DataKey.rfOutputPilotLowFrequencyAlarmSeverity] ||
          previous.characteristicData[DataKey.rfOutputPilotHighFrequencyAlarmSeverity] !=
              current.characteristicData[
                  DataKey.rfOutputPilotHighFrequencyAlarmSeverity] ||
          previous.characteristicData[DataKey.voltageRippleAlarmSeverity] !=
              current.characteristicData[DataKey.voltageRippleAlarmSeverity] ||
          previous.characteristicData[DataKey.outputPowerAlarmSeverity] !=
              current.characteristicData[DataKey.outputPowerAlarmSeverity] ||
          previous.characteristicData[DataKey.voltageAlarmState] !=
              current.characteristicData[DataKey.voltageAlarmState] ||
          previous.characteristicData[DataKey.temperatureAlarmState] !=
              current.characteristicData[DataKey.temperatureAlarmState] ||
          previous.characteristicData[DataKey.rfOutputPilotLowFrequencyAlarmState] !=
              current.characteristicData[
                  DataKey.rfOutputPilotLowFrequencyAlarmState] ||
          previous.characteristicData[DataKey.rfOutputPilotHighFrequencyAlarmState] !=
              current.characteristicData[DataKey.rfOutputPilotHighFrequencyAlarmState] ||
          previous.characteristicData[DataKey.voltageRippleAlarmState] != current.characteristicData[DataKey.voltageRippleAlarmState] ||
          previous.characteristicData[DataKey.rfOutputPowerAlarmState] != current.characteristicData[DataKey.rfOutputPowerAlarmState],
      builder: (context, state) {
        Alarm unitStatusAlarmSeverity = getAlarmEnumFromString(
            state.characteristicData[DataKey.unitStatusAlarmSeverity] ?? '');
        Alarm temperatureAlarmSeverity = getAlarmEnumFromString(
            state.characteristicData[DataKey.temperatureAlarmSeverity] ?? '');
        Alarm voltageAlarmSeverity = getAlarmEnumFromString(
            state.characteristicData[DataKey.voltageAlarmSeverity] ?? '');

        String temperatureAlarmState =
            state.characteristicData[DataKey.temperatureAlarmState] ?? '1';

        String voltageAlarmState =
            state.characteristicData[DataKey.voltageAlarmState] ?? '1';

        String voltageRippleAlarmState =
            state.characteristicData[DataKey.voltageRippleAlarmState] ?? '1';

        String rfOutputPowerAlarmState =
            state.characteristicData[DataKey.rfOutputPowerAlarmState] ?? '1';

        String rfOutputPilotLowFrequencyAlarmState = state.characteristicData[
                DataKey.rfOutputPilotLowFrequencyAlarmState] ??
            '1';

        String rfOutputPilotHighFrequencyAlarmState = state.characteristicData[
                DataKey.rfOutputPilotHighFrequencyAlarmState] ??
            '1';

        String unitStatusAlarmState = getUnitStatusAlarmState(
          temperatureAlarmState: temperatureAlarmState,
          voltageAlarmState: voltageAlarmState,
          voltageRippleAlarmState: voltageRippleAlarmState,
          rfOutputPowerAlarmState: rfOutputPowerAlarmState,
          rfOutputPilotLowFrequencyAlarmState:
              rfOutputPilotLowFrequencyAlarmState,
          rfOutputPilotHighFrequencyAlarmState:
              rfOutputPilotHighFrequencyAlarmState,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getPulsator(
                alarmState: unitStatusAlarmState,
                alarm: unitStatusAlarmSeverity,
                name: AppLocalizations.of(context)!.unitStatusAlarm,
                animationEnabled: unitStatusAlarmState == '0' &&
                        unitStatusAlarmSeverity == Alarm.danger
                    ? true
                    : false,
              ),
              getPulsator(
                alarmState: temperatureAlarmState,
                alarm: temperatureAlarmSeverity,
                name: AppLocalizations.of(context)!.temperatureAlarm,
                animationEnabled: temperatureAlarmState == '0' &&
                        temperatureAlarmSeverity == Alarm.danger
                    ? true
                    : false,
              ),
              getPulsator(
                alarmState: voltageAlarmState,
                alarm: voltageAlarmSeverity,
                name: AppLocalizations.of(context)!.powerSupplyAlarm,
                animationEnabled: voltageAlarmState == '0' &&
                        voltageAlarmSeverity == Alarm.danger
                    ? true
                    : false,
              ),
            ],
          ),
        );
      },
    );
  }
}

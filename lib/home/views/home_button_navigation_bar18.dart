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
            //if current page is account which is not list in bottom navigation bar, make all items grey color
            //assign a useless 0 as currentIndex for account page
            currentIndex: selectedIndex,
            selectedIconTheme: const IconThemeData(size: 36),
            selectedFontSize: 10.0,
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

    Widget getPulsator({
      required Alarm alarm,
      required String name,
      bool animationEnabled = true,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Pulsator(
          size: 24, // Circle size
          color: CustomStyle.alarmColor[alarm.name] ??
              const Color(0xff6c757d), // Ripple color
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
          previous.characteristicData[DataKey.unitStatusAlarmSeverity] !=
              current.characteristicData[DataKey.unitStatusAlarmSeverity] ||
          previous.characteristicData[DataKey.temperatureAlarmSeverity] !=
              current.characteristicData[DataKey.temperatureAlarmSeverity] ||
          previous.characteristicData[DataKey.voltageAlarmSeverity] !=
              current.characteristicData[DataKey.voltageAlarmSeverity],
      builder: (context, state) {
        Alarm unitStatusAlarmSeverity = getAlarmEnumFromString(
            state.characteristicData[DataKey.unitStatusAlarmSeverity] ?? '');
        Alarm temperatureAlarmSeverity = getAlarmEnumFromString(
            state.characteristicData[DataKey.temperatureAlarmSeverity] ?? '');
        Alarm voltageAlarmSeverity = getAlarmEnumFromString(
            state.characteristicData[DataKey.voltageAlarmSeverity] ?? '');

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getPulsator(
                alarm: unitStatusAlarmSeverity,
                name: AppLocalizations.of(context)!.unitStatusAlarm,
                animationEnabled:
                    unitStatusAlarmSeverity == Alarm.danger ? true : false,
              ),
              getPulsator(
                alarm: temperatureAlarmSeverity,
                name: AppLocalizations.of(context)!.temperatureAlarm,
                animationEnabled:
                    temperatureAlarmSeverity == Alarm.danger ? true : false,
              ),
              getPulsator(
                alarm: voltageAlarmSeverity,
                name: AppLocalizations.of(context)!.powerSupplyAlarm,
                animationEnabled:
                    voltageAlarmSeverity == Alarm.danger ? true : false,
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/custom_icons/custom_icons.dart';
import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/pulsator.dart';
import 'package:aci_plus_app/core/setup_wizard_dialog.dart';
import 'package:aci_plus_app/core/utils.dart';
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

    // alarmState (alarm mask) == '0' 代表 enable
    // alarmState (alarm mask) == '1' 代表 disable
    String getAmpUnitStatusAlarmState({
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

    // alarmState (alarm mask) == '0' 代表 enable
    // alarmState (alarm mask) == '1' 代表 disable
    String getNodeUnitStatusAlarmState({
      required String temperatureAlarmState,
      required String voltageAlarmState,
      required String rfOutputPower1AlarmState,
      required String rfOutputPower3AlarmState,
      required String rfOutputPower4AlarmState,
      required String rfOutputPower6AlarmState,
    }) {
      if (temperatureAlarmState == '1' &&
          voltageAlarmState == '1' &&
          rfOutputPower1AlarmState == '1' &&
          rfOutputPower3AlarmState == '1' &&
          rfOutputPower4AlarmState == '1' &&
          rfOutputPower6AlarmState == '1') {
        return '1';
      } else {
        return '0';
      }
    }

    Alarm getAmpUnitAlarmSeverityWithoutSplitOption({
      required Alarm splitOptionAlarmSeverity,
      required Alarm temperatureAlarmSeverity,
      required Alarm voltageAlarmSeverity,
      required Alarm voltageRippleAlarmSeverity,
      required Alarm outputPowerAlarmSeverity,
      required Alarm rfOutputPilotLowFrequencyAlarmSeverity,
      required Alarm rfOutputPilotHighFrequencyAlarmSeverity,
    }) {
      if (temperatureAlarmSeverity == Alarm.success &&
          voltageAlarmSeverity == Alarm.success &&
          voltageRippleAlarmSeverity == Alarm.success &&
          outputPowerAlarmSeverity == Alarm.success &&
          rfOutputPilotLowFrequencyAlarmSeverity == Alarm.success &&
          rfOutputPilotHighFrequencyAlarmSeverity == Alarm.success) {
        return Alarm.success;
      } else {
        return Alarm.danger;
      }
    }

    Alarm getNodeUnitAlarmSeverityWithoutSplitOption({
      required Alarm temperatureAlarmSeverity,
      required Alarm voltageAlarmSeverity,
      required Alarm rfOutputPower1AlarmSeverity,
      required Alarm rfOutputPower3AlarmSeverity,
      required Alarm rfOutputPower4AlarmSeverity,
      required Alarm rfOutputPower6AlarmSeverity,
    }) {
      if (temperatureAlarmSeverity == Alarm.success &&
          voltageAlarmSeverity == Alarm.success &&
          rfOutputPower1AlarmSeverity == Alarm.success &&
          rfOutputPower3AlarmSeverity == Alarm.success &&
          rfOutputPower4AlarmSeverity == Alarm.success &&
          rfOutputPower6AlarmSeverity == Alarm.success) {
        return Alarm.success;
      } else {
        return Alarm.danger;
      }
    }

    Widget getPulsator({
      required Color color,
      // required String name,
      required IconData iconData,
      bool animationEnabled = true,
    }) {
      return SizedBox(
        width: 44,
        height: 22,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Pulsator(
            iconData: iconData,
            size: 24, // Circle size
            color: color,
            duration: const Duration(
              seconds: 2,
            ), //  animationEnabled = false 時 Ripple duration 可以忽略
            rippleCount: animationEnabled ? 1 : 0,
            // animationEnabled = false 時關閉動畫
            // title: name,
          ),
        ),
      );
    }

    Color getPulsatorColor({
      required String alarmState,
      required Alarm alarm,
    }) {
      return alarmState == '0'
          ? CustomStyle.alarmColor[alarm.name] ?? const Color(0xff6c757d)
          : CustomStyle.alarmColor[Alarm.success.name]!; // Ripple color
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadingStatus.isRequestSuccess) {
          Alarm unitStatusAlarmSeverity = getAlarmEnumFromString(
              state.characteristicData[DataKey.unitStatusAlarmSeverity] ?? '');

          Alarm splitOptionAlarmSeverity = getAlarmEnumFromString(
              state.characteristicData[DataKey.splitOptionAlarmSeverity] ?? '');

          Alarm temperatureAlarmSeverity = getAlarmEnumFromString(
              state.characteristicData[DataKey.temperatureAlarmSeverity] ?? '');

          Alarm voltageAlarmSeverity = getAlarmEnumFromString(
              state.characteristicData[DataKey.voltageAlarmSeverity] ?? '');

          Alarm voltageRippleAlarmSeverity = getAlarmEnumFromString(
              state.characteristicData[DataKey.voltageRippleAlarmSeverity] ??
                  '');

          Alarm outputPowerAlarmSeverity = getAlarmEnumFromString(
              state.characteristicData[DataKey.outputPowerAlarmSeverity] ?? '');

          Alarm rfOutputPilotLowFrequencyAlarmSeverity = getAlarmEnumFromString(
              state.characteristicData[
                      DataKey.rfOutputPilotLowFrequencyAlarmSeverity] ??
                  '');

          Alarm rfOutputPilotHighFrequencyAlarmSeverity =
              getAlarmEnumFromString(state.characteristicData[
                      DataKey.rfOutputPilotHighFrequencyAlarmSeverity] ??
                  '');

          // Node
          Alarm rfOutputPower1AlarmSeverity = getAlarmEnumFromString(
              state.characteristicData[DataKey.rfOutputPower1AlarmSeverity] ??
                  '');
          Alarm rfOutputPower3AlarmSeverity = getAlarmEnumFromString(
              state.characteristicData[DataKey.rfOutputPower3AlarmSeverity] ??
                  '');

          Alarm rfOutputPower4AlarmSeverity = getAlarmEnumFromString(
              state.characteristicData[DataKey.rfOutputPower4AlarmSeverity] ??
                  '');

          Alarm rfOutputPower6AlarmSeverity = getAlarmEnumFromString(
              state.characteristicData[DataKey.rfOutputPower6AlarmSeverity] ??
                  '');

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

          String rfOutputPilotHighFrequencyAlarmState =
              state.characteristicData[
                      DataKey.rfOutputPilotHighFrequencyAlarmState] ??
                  '1';

          // Node
          String rfOutputPower1AlarmState =
              state.characteristicData[DataKey.rfOutputPower1AlarmState] ?? '1';
          String rfOutputPower3AlarmState =
              state.characteristicData[DataKey.rfOutputPower3AlarmState] ?? '1';
          String rfOutputPower4AlarmState =
              state.characteristicData[DataKey.rfOutputPower4AlarmState] ?? '1';
          String rfOutputPower6AlarmState =
              state.characteristicData[DataKey.rfOutputPower6AlarmState] ?? '1';

          String unitAmpStatusAlarmState = getAmpUnitStatusAlarmState(
            temperatureAlarmState: temperatureAlarmState,
            voltageAlarmState: voltageAlarmState,
            voltageRippleAlarmState: voltageRippleAlarmState,
            rfOutputPowerAlarmState: rfOutputPowerAlarmState,
            rfOutputPilotLowFrequencyAlarmState:
                rfOutputPilotLowFrequencyAlarmState,
            rfOutputPilotHighFrequencyAlarmState:
                rfOutputPilotHighFrequencyAlarmState,
          );

          // 不使用 splitOptionAlarmSeverity
          Alarm ampUnitAlarmSeverityWithoutSplitOption =
              getAmpUnitAlarmSeverityWithoutSplitOption(
            splitOptionAlarmSeverity: splitOptionAlarmSeverity,
            temperatureAlarmSeverity: temperatureAlarmSeverity,
            voltageAlarmSeverity: voltageAlarmSeverity,
            voltageRippleAlarmSeverity: voltageRippleAlarmSeverity,
            outputPowerAlarmSeverity: outputPowerAlarmSeverity,
            rfOutputPilotLowFrequencyAlarmSeverity:
                rfOutputPilotLowFrequencyAlarmSeverity,
            rfOutputPilotHighFrequencyAlarmSeverity:
                rfOutputPilotHighFrequencyAlarmSeverity,
          );

          String nodeUnitStatusAlarmState = getNodeUnitStatusAlarmState(
            temperatureAlarmState: temperatureAlarmState,
            voltageAlarmState: voltageAlarmState,
            rfOutputPower1AlarmState: rfOutputPower1AlarmState,
            rfOutputPower3AlarmState: rfOutputPower3AlarmState,
            rfOutputPower4AlarmState: rfOutputPower4AlarmState,
            rfOutputPower6AlarmState: rfOutputPower6AlarmState,
          );

          // 不使用 splitOptionAlarmSeverity
          Alarm nodeUnitAlarmSeverityWithoutSplitOption =
              getNodeUnitAlarmSeverityWithoutSplitOption(
            temperatureAlarmSeverity: temperatureAlarmSeverity,
            voltageAlarmSeverity: voltageAlarmSeverity,
            rfOutputPower1AlarmSeverity: rfOutputPower1AlarmSeverity,
            rfOutputPower3AlarmSeverity: rfOutputPower3AlarmSeverity,
            rfOutputPower4AlarmSeverity: rfOutputPower4AlarmSeverity,
            rfOutputPower6AlarmSeverity: rfOutputPower6AlarmSeverity,
          );

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getPulsator(
                  color: getPulsatorColor(
                    alarmState: unitAmpStatusAlarmState,
                    alarm: state.aciDeviceType == ACIDeviceType.amp1P8G
                        ? ampUnitAlarmSeverityWithoutSplitOption
                        : nodeUnitAlarmSeverityWithoutSplitOption,
                  ),
                  iconData: CustomIcons.device,
                  // name: AppLocalizations.of(context)!.unitStatusAlarm,
                  animationEnabled: unitAmpStatusAlarmState == '0' &&
                          ampUnitAlarmSeverityWithoutSplitOption == Alarm.danger
                      ? true
                      : false,
                ),
                getPulsator(
                  color: getPulsatorColor(
                    alarmState: temperatureAlarmState,
                    alarm: temperatureAlarmSeverity,
                  ),
                  iconData: CustomIcons.temperature,
                  // name: AppLocalizations.of(context)!.temperatureAlarm,
                  animationEnabled: temperatureAlarmState == '0' &&
                          temperatureAlarmSeverity == Alarm.danger
                      ? true
                      : false,
                ),
                getPulsator(
                  color: getPulsatorColor(
                    alarmState: voltageAlarmState,
                    alarm: voltageAlarmSeverity,
                  ),
                  iconData: CustomIcons.power,
                  animationEnabled: voltageAlarmState == '0' &&
                          voltageAlarmSeverity == Alarm.danger
                      ? true
                      : false,
                ),
                Container(
                  width: 44,
                  height: 22,
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
                Container(
                  width: 44,
                  height: 22,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: IconButton(
                    visualDensity:
                        const VisualDensity(horizontal: -4.0, vertical: -4.0),
                    onPressed: () {
                      showSetupWizardDialog(
                        context: context,
                        functionDescriptionType:
                            SetupWizardProperty.functionDescriptionType,
                        aciDeviceType: state.aciDeviceType,
                      );
                    },
                    icon: Icon(
                      CustomIcons.information,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getPulsator(
                  color: const Color(0xff6c757d),
                  iconData: CustomIcons.device,
                  // name: AppLocalizations.of(context)!.unitStatusAlarm,
                  animationEnabled: false,
                ),
                getPulsator(
                  color: const Color(0xff6c757d),
                  iconData: CustomIcons.temperature,
                  // name: AppLocalizations.of(context)!.temperatureAlarm,
                  animationEnabled: false,
                ),
                getPulsator(
                  color: const Color(0xff6c757d),
                  iconData: CustomIcons.power,
                  // name: AppLocalizations.of(context)!.powerSupplyAlarm,
                  animationEnabled: false,
                ),
                Container(
                  width: 44,
                  height: 22,
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
                Container(
                  width: 44,
                  height: 22,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: IconButton(
                    visualDensity:
                        const VisualDensity(horizontal: -4.0, vertical: -4.0),
                    onPressed: () {
                      showSetupWizardDialog(
                        context: context,
                        functionDescriptionType:
                            SetupWizardProperty.functionDescriptionType,
                        aciDeviceType: ACIDeviceType.amp1P8G,
                      );
                    },
                    icon: Icon(
                      CustomIcons.information,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
